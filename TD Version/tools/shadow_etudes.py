"""
Shadow Etudes: electronic music composed for the Echo Shadows engine.

The engine reads three bands of a Minim-style FFT (band 0: 0-1.47 kHz, band 1: 1.47-2.94 kHz,
band 2: 2.94-4.41 kHz) and, with the Default booster, scales them to d0, d1, d2 (0-100):
  - NORMAL state: p (bulbs lit per pattern step) = int(1 + d0 * 0.04), so d0 25/50/75/100 -> 2/3/4/5 bulbs;
    red and blue follow d0, green follows d1; louder d0 = faster pattern switching.
  - ST1: d0 > 69, d1 > 10, d0 > d1 -> full-brightness flashes with random p.
  - ST2: d0 == d1 (both clamped at 100) and d0 > d2 -> full brightness, p up to 6.
So the piece is written as target curves for d0 and d1. Two timbres are used:
  WARM  only band 0 (dense detuned chords, every partial below 1.40 kHz)
  AIR   only band 1 (bell partials between 1.55 and 2.85 kHz)
Each timbre is calibrated so that gain 1.0 gives a band average of 1.0; the gain needed for a
target is then d / weight. Nothing goes into band 2, which keeps ST2 reachable.

Run with any Python that has numpy, e.g. TouchDesigner's bundled
/Applications/TouchDesigner.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3:

    python3 tools/shadow_etudes.py test_audio/shadow_etudes.wav     (run from "TD Version"; test_audio/ is not tracked in git)
"""

import sys
import wave
import numpy as np

SR = 44100
HOP = 735                      # samples per TouchDesigner frame at 60 fps
W0, W1 = 15 * 0.415, 15 * (0.415 + 0.225)   # Default booster band weights
rng = np.random.default_rng(11)

SECTIONS = [                   # name, seconds
	('breath', 24.0), ('heartbeat', 16.0), ('fireflies', 12.0),
	('storm', 12.0), ('twins', 8.0), ('exhale', 8.0),
]
TOTAL = sum(s for _, s in SECTIONS)
CHORDS = [[45, 57, 60, 64, 69], [41, 53, 57, 60, 65], [48, 55, 60, 64, 67], [43, 55, 59, 62, 67]]  # Am F C G


def hz(n):
	return 440.0 * 2 ** ((n - 69) / 12)


def minim_avgs(x):
	window = 0.54 - 0.46 * np.cos(2 * np.pi * np.arange(1024) / 1023)
	spec = np.abs(np.fft.rfft(x * window))
	return [spec[i * 34:(i + 1) * 34].sum() / 35 for i in range(3)]


def band_level(sig, band):
	"""Mean Minim band average over the signal, sampled every 1024 samples."""
	vals = [minim_avgs(sig[i:i + 1024])[band] for i in range(0, len(sig) - 1024, 1024)]
	return float(np.mean(vals))


def additive(partials, seconds):
	"""Sum of sines (freq, amp) with random phases."""
	t = np.arange(int(seconds * SR)) / SR
	out = np.zeros_like(t)
	for f, a in partials:
		out += a * np.sin(2 * np.pi * f * t + rng.uniform(0, 2 * np.pi))
	return out


def warm(chord, seconds):
	partials = []
	for n in chord:
		f0 = hz(n)
		for k in range(1, 40):
			f = f0 * k
			if f > 1400:
				break
			for det in (0.997, 1.0, 1.003):        # detuned triple: slow, breathing beats
				partials.append((f * det, 1.0 / k ** 0.8))
	return additive(partials, seconds)


def air(seconds):
	notes = [91, 93, 96, 98, 100]                  # G6 A6 C7 D7 E7, 1.57-2.64 kHz
	partials = [(hz(n) * det, 1.0) for n in notes for det in (0.998, 1.0, 1.002)]
	return additive(partials, seconds)


def calibrated(sig, band):
	return sig / band_level(sig, band)


def frame_curve(fn):
	"""Per-sample gain curve from a function of time in seconds (evaluated per frame, smoothed)."""
	n = int(TOTAL * SR)
	frames = np.arange(0, n, HOP)
	vals = np.array([fn(f / SR) for f in frames], dtype=np.float64)
	curve = np.interp(np.arange(n), frames, vals)
	k = np.ones(256) / 256                         # 6 ms smoothing so gain steps do not click
	return np.convolve(curve, k, mode='same')


def section_at(t):
	start = 0.0
	for name, secs in SECTIONS:
		if t < start + secs:
			return name, t - start, secs
		start += secs
	return SECTIONS[-1][0], SECTIONS[-1][1], SECTIONS[-1][1]


# ---- the score: target d0 and d1 over time ------------------------------------------

def heartbeat_env(x, period):
	"""Lub-dub: two decaying thumps per period."""
	ph = x % period
	return np.exp(-ph / 0.09) + 0.7 * np.exp(-max(ph - 0.28, 0) / 0.09) * (ph >= 0.28)


def target_d0(t):
	name, x, secs = section_at(t)
	if name == 'breath':        # three slow breaths: 1 -> 5 bulbs -> 1
		return 4 + 100 * (0.5 - 0.5 * np.cos(2 * np.pi * x / 8.0))
	if name == 'heartbeat':     # accelerating heartbeat, peaks at ~3 bulbs
		period = 1.1 - 0.5 * (x / secs)
		return 6 + 62 * heartbeat_env(x, period)
	if name == 'fireflies':     # a dim glow, one bulb
		return 14 + 6 * np.sin(2 * np.pi * x / 3.0)
	if name == 'storm':         # gated eighth notes at 140 BPM, loud
		step = 60 / 140 / 2
		return 105 if (x % step) < step * 0.6 else 40
	if name == 'twins':         # headroom: both bands must stay clamped at 100 through the chord beats
		return 160
	if name == 'exhale':        # one long breath out
		return 160 * np.exp(-x / 1.4)
	return 0


def target_d1(t):
	name, x, secs = section_at(t)
	if name in ('breath', 'heartbeat'):
		return 0                # keep band 1 silent: stays in NORMAL, p follows d0 exactly
	if name == 'fireflies':     # random bell sparkles: green flickers
		k = int(x / 0.25)
		r = np.random.default_rng(1000 + k).random()
		return 55 * np.exp(-(x % 0.25) / 0.08) if r < 0.45 else 0
	if name == 'storm':         # bright accents on the off-steps push the ST1 flashes
		step = 60 / 140 / 2
		return 45 if (x % (2 * step)) < step * 0.6 else 8
	if name == 'twins':
		return 160
	if name == 'exhale':
		return 160 * np.exp(-x / 0.7)
	return 0


def render():
	n = int(TOTAL * SR)
	chord_len = 4.0
	warm_track = np.zeros(n)
	for i in range(int(np.ceil(TOTAL / chord_len))):
		seg = calibrated(warm(CHORDS[i % 4], chord_len + 0.2), 0)
		s = int(i * chord_len * SR)
		e = min(n, s + len(seg))
		fade = np.ones(e - s)
		ramp = int(0.2 * SR)
		fade[:ramp] = np.linspace(0, 1, ramp)        # crossfade between chords
		if i > 0:
			warm_track[s:s + ramp] *= np.linspace(1, 0, ramp)[: len(warm_track[s:s + ramp])]
		warm_track[s:e] = warm_track[s:e] + seg[: e - s] * fade
	air_track = calibrated(air(TOTAL), 1)
	g0 = frame_curve(lambda t: target_d0(t) / W0)
	g1 = frame_curve(lambda t: target_d1(t) / W1)
	mix = warm_track * g0 + air_track * g1
	peak = np.abs(mix).max()
	return mix, peak


if __name__ == '__main__':
	mix, peak = render()
	print('peak before limiting %.2f' % peak)
	if peak > 0.95:
		mix = np.tanh(mix) * 0.98      # soft clip: near-unity for quiet parts, so the calibration holds
	stereo = np.stack([mix, mix], axis=1)
	with wave.open(sys.argv[1], 'wb') as w:
		w.setnchannels(2)
		w.setsampwidth(2)
		w.setframerate(SR)
		w.writeframes((stereo * 32767).astype(np.int16).tobytes())
	t = 0.0
	for name, secs in SECTIONS:
		print('%-10s %5.1f - %5.1f s' % (name, t, t + secs))
		t += secs
