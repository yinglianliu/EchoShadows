"""
Echo Shadows - TouchDesigner engine
Port of the 2024 Processing sketch (v19), see ../../Processing Version/EchoShadows2024.

Pure Python (numpy only for the FFT), so it can run inside a Text DAT in TD
and also be tested outside TD.

Output = 80 DMX target values: 4 units x 20 channels (20-channel mode),
unit addresses 1 / 21 / 41 / 61. Inside one unit, LED k (0-4) uses
R = 1+4k, G = 2+4k, B = 3+4k, W = 4+4k.
"""

import random

NUM_UNITS = 4
CHANNELS_PER_UNIT = 20
NUM_LEDS = 5
COLOR_OFFSET = {'r': 1, 'g': 2, 'b': 3}
CHAN_INTERVAL = 4

TH = 69.0                 # sound mode threshold (Processing: th)
MAX_SWITCH_MS = 9000
MIN_SWITCH_MS = 1000

# Booster presets: (amp, index, step, fade_lo, fade_hi)
# band weight i = amp * (index + i * step); fade = map(band0, 0, 100, fade_lo, fade_hi)
BOOSTERS = {
	'default':    (15.0, 0.415, 0.225, 0.05,  0.25),
	'NORBOOSTER': (22.5, 0.35,  0.475, 0.025, 0.195),
	'BOOSTER+':   (33.0, 0.35,  0.475, 0.020, 0.190),
	'BOOSTER++':  (44.0, 0.357, 0.48,  0.010, 0.175),
}
AUDIO_MAX = 100.0


def default_controls():
	"""Same names as the TouchOSC addresses (without '/')."""
	return {
		'soundMode': 0.0, 'demoMode': 0.0,
		'unit1': 0.0, 'unit2': 0.0, 'unit3': 0.0, 'unit4': 0.0,
		'NORBOOSTER': 0.0, 'BOOSTER+': 0.0, 'BOOSTER++': 0.0,
		'red': 0.0, 'green': 0.0, 'blue': 0.0,
	}


# --------------------------------------------------------------------------
# Audio: reproduce Minim's FFT + linAverages(15) so the 2024 gains still fit
# --------------------------------------------------------------------------

def minim_lin_averages(samples, num_avg=15):
	"""samples: 1024 mono samples (-1..1). Returns Minim-style getAvg() list."""
	import numpy as np
	x = np.asarray(samples, dtype=np.float64)
	n = len(x)
	window = 0.54 - 0.46 * np.cos(2.0 * np.pi * np.arange(n) / (n - 1))  # FFT.HAMMING
	spectrum = np.abs(np.fft.rfft(x * window))  # n/2+1 bins, not normalised (like Minim)
	width = len(spectrum) // num_avg
	avgs = []
	for i in range(num_avg):
		chunk = spectrum[i * width:(i + 1) * width]
		avgs.append(float(chunk.sum()) / (len(chunk) + 1))  # Minim divides by j+1
	return avgs


def booster_name(c):
	n, p, pp = c['NORBOOSTER'] == 1, c['BOOSTER+'] == 1, c['BOOSTER++'] == 1
	if p and not pp and not n:
		return 'BOOSTER+'
	if pp and not p and not n:
		return 'BOOSTER++'
	if n and not p and not pp:
		return 'NORBOOSTER'
	return 'default'


def band_data(avgs, booster, input_gain=1.0):
	"""myAudioDataUpdate(): weighted + clamped 0..100."""
	amp, index, step, _, _ = BOOSTERS[booster]
	return [min(max(a * input_gain * amp * (index + i * step), 0.0), AUDIO_MAX)
			for i, a in enumerate(avgs)]


def fade_rate(d0, booster):
	_, _, _, lo, hi = BOOSTERS[booster]
	return lo + (hi - lo) * d0 / 100.0


# --------------------------------------------------------------------------
# Pattern tables (redPer, redPer2, greenPer ... bluePer2)
# step p -> 5 LEDs, each (factor for unit A, factor for unit B) * color value
# 'other' = branch for any other p: ('factor' | 'const', {led: (a, b)})
# --------------------------------------------------------------------------

Z = (0, 0)
PER = {
	'redPer': dict(units=(0, 1), color='r', steps={
		1: [(1, 0), Z, Z, Z, Z],
		2: [(1, .9), Z, Z, Z, Z],
		3: [(1, .8), Z, (.65, .55), Z, Z],
		4: [(1, 0), Z, (.75, 0), (0, .65), Z],
		5: [(1, 0), (0, .85), (.65, 0), (0, .5), (.85, 0)],
	}, other=('const', {0: (0, 255), 2: (0, 255), 4: (0, 255)})),

	'redPer2': dict(units=(2, 3), color='r', steps={
		1: [(1, 1), Z, Z, Z, Z],
		2: [(1, 1), Z, Z, Z, Z],
		3: [(1, 1), Z, (1, 1), Z, Z],
		4: [(.85, .85), Z, (.65, .65), Z, Z],
		5: [(.85, .85), Z, (.65, .65), Z, (.5, .5)],
	}, other=('factor', dict(enumerate([(1, 0), (0, 1), Z, (0, 1), (1, 0)])))),

	'greenPer': dict(units=(0, 1), color='g', steps={
		1: [(1, 0), Z, Z, Z, Z],
		2: [(1, 0), (0, 1), Z, Z, Z],
		3: [(1, 0), (0, 1), (1, 0), Z, Z],
		4: [(1, 0), (0, 1), (1, 0), (0, 1), Z],
		5: [(1, 0), (0, 1), (1, 0), (0, 1), (1, 0)],
	}, other=('const', dict(enumerate([Z] * 5)))),

	'greenPer2': dict(units=(2, 3), color='g', steps={
		1: [(1, 1), Z, Z, Z, Z],
		2: [(1, 1), Z, Z, Z, Z],
		3: [(1, 1), Z, (1, 1), Z, Z],
		4: [(1, 1), Z, (1, 1), Z, Z],
		5: [(1, 1), Z, (1, 1), Z, (1, 1)],
	}, other=('const', dict(enumerate([(200, 200)] * 5)))),

	'bluePer': dict(units=(0, 1), color='b', steps={
		1: [Z, (1, 1), Z, Z, Z],
		2: [Z, (1, 1), (1, 1), Z, Z],
		3: [Z, (1, 1), (1, 1), Z, Z],
		4: [Z, (1, 1), (1, 1), Z, Z],
		5: [Z, (1, 1), (1, 1), Z, (1, 1)],
	}, other=('const', dict(enumerate([(127, 255), (255, 127), (127, 255), (255, 127), (127, 255)])))),

	'bluePer2': dict(units=(2, 3), color='b', steps={
		1: [(1, 0), Z, Z, Z, Z],
		2: [(1, 0), (0, 1), Z, Z, Z],
		3: [(1, 0), (0, 1), (1, 0), Z, Z],
		4: [(1, 0), (0, 1), (1, 0), (0, 1), Z],
		5: [(1, 0), (0, 1), (1, 0), (0, 1), (1, 0)],
	}, other=('const', dict(enumerate([(127, 255), (255, 127), (127, 255), (255, 127), (127, 255)])))),
}

U12, U34, ALL = (0, 1), (2, 3), (0, 1, 2, 3)

# Sound-mode switch patterns (sw 1-10), executed in the same order as Processing.
# ('per', name) | ('zero', units, colors) | ('zero_all', units) -> channels 1..19
SWITCH_PATTERNS = {
	1:  ("Full color, unit 1 & 2", [('per', 'redPer'), ('per', 'greenPer'), ('per', 'bluePer'), ('zero_all', U34)]),
	2:  ("Full color, unit 3 & 4", [('per', 'redPer2'), ('per', 'greenPer2'), ('per', 'bluePer2'), ('zero_all', U12)]),
	3:  ("Pure red, unit 1 & 2", [('per', 'redPer'), ('zero', U34, 'r'), ('zero', ALL, 'g'), ('zero', ALL, 'b')]),
	4:  ("Green unit 1 & 2, full color unit 3 & 4", [('per', 'greenPer'), ('per', 'redPer2'), ('per', 'greenPer2'),
		('per', 'bluePer2'), ('zero', U12, 'r'), ('zero', U12, 'b')]),
	5:  ("Pure blue + red", [('per', 'redPer'), ('per', 'bluePer'), ('per', 'bluePer2'), ('zero', U34, 'r'), ('zero', ALL, 'g')]),
	6:  ("Full color, all units", [('per', 'greenPer'), ('per', 'bluePer'), ('per', 'redPer2'), ('per', 'bluePer2'),
		('zero', U12, 'r'), ('zero', U34, 'g')]),
	7:  ("Green, unit 1 & 2", [('per', 'greenPer'), ('zero', ALL, 'r'), ('zero', ALL, 'b'), ('zero', U34, 'g')]),
	8:  ("Green, unit 3 & 4", [('per', 'greenPer2'), ('zero', ALL, 'r'), ('zero', ALL, 'b'), ('zero', U12, 'g')]),
	9:  ("Pure red, unit 3 & 4", [('per', 'redPer2'), ('zero', U12, 'r'), ('zero', ALL, 'g'), ('zero', ALL, 'b')]),
	10: ("Pure blue, unit 3 & 4", [('per', 'bluePer2'), ('zero', U12, 'b'), ('zero', ALL, 'r'), ('zero', ALL, 'g')]),
}


def _map(v, a, b, c, d):
	return c + (d - c) * ((v - a) / (b - a))


def _constrain(v, lo, hi):
	# Processing's constrain(), including its behaviour when lo > hi
	return lo if v < lo else (hi if v > hi else v)


class EchoEngine:

	def __init__(self, legacy_demo_override=True, seed=None):
		# legacy_demo_override: the v19 sketch runs the demo-unit blocks every
		# frame, so in sound mode unit1 red / unit2 green / unit3 blue / some
		# unit4 channels are always forced back to 0. True = look exactly like 2024.
		self.legacy_demo_override = legacy_demo_override
		self.rng = random.Random(seed)
		# DMX targets keep their value until written again (like DMXFixture.sendValue)
		self.targets = [[0.0] * (CHANNELS_PER_UNIT + 1) for _ in range(NUM_UNITS)]  # index 1..20
		self.output = [0.0] * (NUM_UNITS * CHANNELS_PER_UNIT)
		self.sw = 6
		self.last_switch_ms = 0
		self.p = 1
		self.red = self.green = self.blue = 0
		self.state = 'NORMAL'
		self.switch_ms = MAX_SWITCH_MS
		self.data = [0.0] * 15
		self.fade = 0.0
		self.booster = 'default'

	# --- low level ---------------------------------------------------------

	def _send(self, unit, chan, value):
		self.targets[unit][chan] = float(value)

	def _zero(self, units, color):
		for u in units:
			for k in range(NUM_LEDS):
				self._send(u, COLOR_OFFSET[color] + CHAN_INTERVAL * k, 0)

	def _zero_all(self, units):
		for u in units:
			for c in range(1, CHANNELS_PER_UNIT):  # Processing loop: i = 1; i < 20
				self._send(u, c, 0)

	def _per(self, name):
		spec = PER[name]
		ua, ub = spec['units']
		off = COLOR_OFFSET[spec['color']]
		value = {'r': self.red, 'g': self.green, 'b': self.blue}[spec['color']]
		if self.p in spec['steps']:
			kind, leds = 'factor', dict(enumerate(spec['steps'][self.p]))
		else:
			kind, leds = spec['other']
		for k, (a, b) in leds.items():
			if kind == 'factor':
				a, b = value * a, value * b
			self._send(ua, off + CHAN_INTERVAL * k, a)
			self._send(ub, off + CHAN_INTERVAL * k, b)

	# --- modes -------------------------------------------------------------

	def _sound_mode(self, now_ms):
		d0, d1, d2 = self.data[0], self.data[1], self.data[2]
		r = self.rng.random
		if d0 > TH and d1 > 10 and d0 > d1 and (d0 - d1) > 0:
			diff = d0 - d1
			self.state = 'ST1'
			lo = _map(diff, 0, diff * 32.5, 1, 6)
			self.p = int(lo + r() * (6 - lo))  # random(lo, 6)
			self.red = _constrain(int(_map(diff, 0, diff / 510, 42, 255)), -80, 325)
			self.green = _constrain(int(_map(diff, 0, diff / 510, 72, 255)), -70, 325)
			self.blue = _constrain(int(_map(diff, 0, diff / 510, 255, 72)), 325, -50)
		elif (d0 - d1) == 0 and (d0 - d2) > 0:
			diff = d0 - d2
			self.state = 'ST2'
			lo = _map(diff, 0, diff * 32.5, 1, 7)
			self.p = int(lo + r() * (7 - lo))  # random(lo, 7)
			self.red = _constrain(int(_map(diff, 0, diff / 510, 42, 255)), -60, 325)
			self.green = _constrain(int(_map(diff, 0, diff / 510, 72, 255)), -70, 325)
			self.blue = _constrain(int(_map(diff, 0, diff / 510, 255, 72)), 325, -50)
		else:
			self.state = 'NORMAL'
			self.p = int(_map(d0, 0, 150, 1, 7))
			self.red = int(_map(d0, 0, 100, 127, 255))
			self.green = int(_map(d1, 0, 60, 82, 255))
			self.blue = int(_map(d0, 0, 100, 255, 120))

		self.switch_ms = int(_map(d0, 0, 100, MAX_SWITCH_MS, MIN_SWITCH_MS))
		if now_ms - self.last_switch_ms > self.switch_ms:
			self.sw = self.rng.randint(1, 10)
			self.last_switch_ms = now_ms

		for op in SWITCH_PATTERNS[self.sw][1]:
			if op[0] == 'per':
				self._per(op[1])
			elif op[0] == 'zero':
				self._zero(op[1], op[2])
			else:
				self._zero_all(op[1])

	def _demo_units(self, c):
		demo = c['demoMode'] == 1
		red_demo, green_demo, blue_demo = c['red'] * 255, c['green'] * 255, c['blue'] * 255

		if demo and c['unit1'] == 1:
			for k in range(NUM_LEDS):
				self._send(0, 1 + 4 * k, red_demo)
		elif self.legacy_demo_override:
			self._zero((0,), 'r')

		if demo and c['unit2'] == 1:
			for k in range(NUM_LEDS):
				self._send(1, 2 + 4 * k, green_demo)
		elif self.legacy_demo_override:
			self._zero((1,), 'g')

		if demo and c['unit3'] == 1:
			for k in range(NUM_LEDS):
				self._send(2, 3 + 4 * k, blue_demo)
		elif self.legacy_demo_override:
			self._zero((2,), 'b')

		if demo and c['unit4'] == 1:
			for chan, v in ((1, 255), (3, 255), (5, 255 * .95), (7, 255 * .45), (9, 255),
							(14, 255 * .85), (15, 255 * .40), (18, 255), (19, 255)):
				self._send(3, chan, v)
		elif self.legacy_demo_override:
			for chan in (1, 6, 11, 13, 15, 18, 19):
				self._send(3, chan, 0)

	# --- public ------------------------------------------------------------

	def update(self, avgs, controls, now_ms, input_gain=1.0):
		"""One frame (= Processing draw()). avgs: Minim-style band averages.
		Returns 80 smoothed DMX values (0-255)."""
		c = controls
		self.booster = booster_name(c)
		self.data = band_data(avgs, self.booster, input_gain)
		self.fade = fade_rate(self.data[0], self.booster)

		sound, demo = c['soundMode'] == 1, c['demoMode'] == 1
		if sound and not demo:
			self._sound_mode(now_ms)
		else:
			self.state = 'DEMO' if (demo and not sound) else 'OFF'
			self._zero_all(range(NUM_UNITS))
		self._demo_units(c)

		# DMX fixture fade: value moves toward its target by `fade` every frame
		i = 0
		for u in range(NUM_UNITS):
			for ch in range(1, CHANNELS_PER_UNIT + 1):
				t = min(max(self.targets[u][ch], 0.0), 255.0)
				self.output[i] += (t - self.output[i]) * self.fade
				if abs(t - self.output[i]) < 0.01:
					# snap: an endless fade toward 0 reaches denormals, which TD writes as inf
					self.output[i] = t
				i += 1
		return self.output

	@property
	def pattern_name(self):
		return SWITCH_PATTERNS[self.sw][0]
