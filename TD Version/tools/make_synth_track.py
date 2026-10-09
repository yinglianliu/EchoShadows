"""
Synthesize a 124 BPM electronic test track for Echo Shadows, built only from waveforms.
Sections are written to exercise the engine: quiet intro, build, drop 1 (ST1 peaks),
breakdown, drop 2 with a bright lead in band 1 (1.47-2.94 kHz) for ST2 moments, outro.

Run with any Python that has numpy, e.g. TouchDesigner's bundled
/Applications/TouchDesigner.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3:
    python3 tools/make_synth_track.py test_audio/echo_synth_test.wav     (run from "TD Version"; test_audio/ is not tracked in git)
"""

import sys
import wave
import numpy as np

SR = 44100
BPM = 124
BEAT = 60.0 / BPM
BAR = 4 * BEAT
rng = np.random.default_rng(7)


def t_axis(seconds):
	return np.arange(int(seconds * SR)) / SR


def place(track, clip, start_s, gain=1.0):
	i = int(start_s * SR)
	n = min(len(clip), len(track) - i)
	if n > 0:
		track[i:i + n] += clip[:n] * gain


def one_pole_lowpass(x, cutoff):
	a = np.exp(-2 * np.pi * cutoff / SR)
	y = np.empty_like(x)
	acc = 0.0
	for i, v in enumerate(x):
		acc = (1 - a) * v + a * acc
		y[i] = acc
	return y


def highpass(x):
	return np.diff(x, prepend=0.0)


def saw(freq, t, harmonics=12):
	out = np.zeros_like(t)
	for k in range(1, harmonics + 1):
		out += ((-1) ** (k + 1)) * np.sin(2 * np.pi * freq * k * t) / k
	return out * (2 / np.pi)


def note(n):
	"""MIDI note number to Hz."""
	return 440.0 * 2 ** ((n - 69) / 12)


# ---- drum sounds --------------------------------------------------------------

def kick():
	t = t_axis(0.4)
	freq = 45 + 105 * np.exp(-t / 0.03)
	phase = 2 * np.pi * np.cumsum(freq) / SR
	body = np.sin(phase) * np.exp(-t / 0.16) + 0.3 * np.exp(-t / 0.004) * rng.standard_normal(len(t))
	return np.tanh(body * 3.0)          # saturation adds the mid-range harmonics a real kick has


def clap():
	t = t_axis(0.25)
	noise = highpass(rng.standard_normal(len(t)))
	env = np.exp(-t / 0.07) * (1 + 0.6 * (np.sin(2 * np.pi * 90 * t) > 0))
	return noise * env * 0.5


def hat(open_=False):
	t = t_axis(0.25 if open_ else 0.06)
	noise = highpass(highpass(rng.standard_normal(len(t))))
	return noise * np.exp(-t / (0.08 if open_ else 0.015)) * 0.25


def snare():
	t = t_axis(0.2)
	body = np.sin(2 * np.pi * 190 * t) * np.exp(-t / 0.05)
	return (0.6 * body + 0.5 * highpass(rng.standard_normal(len(t))) * np.exp(-t / 0.08))


# ---- tonal parts -------------------------------------------------------------

PROGRESSION = [57, 53, 48, 55]   # A minor, F, C, G roots (MIDI)


def pad_bar(root, seconds):
	t = t_axis(seconds)
	chord = [root, root + (3 if root == 57 else 4), root + 7]
	out = sum(saw(note(n + 12), t, 8) + saw(note(n + 12) * 1.004, t, 8) for n in chord)
	env = np.minimum(1, t / 0.4) * np.minimum(1, (seconds - t) / 0.3)
	return one_pole_lowpass(out * env, 900) * 0.12


def bass_bar(root, seconds):
	t = t_axis(seconds)
	out = np.zeros_like(t)
	step = BEAT / 2
	for k in range(int(seconds / step)):
		s, e = int(k * step * SR), int((k * step + step * 0.8) * SR)
		tt = t[s:e] - t[s]
		out[s:e] = saw(note(root - 12), tt, 10) * np.exp(-tt / 0.18)
	return one_pole_lowpass(out, 1200) * 0.9


def stab_bar(root, seconds):
	"""Offbeat saw chord stabs in the mid range (about 220-900 Hz): fills band 0 like a dense mix."""
	t = t_axis(seconds)
	out = np.zeros_like(t)
	chord = [root, root + (3 if root == 57 else 4), root + 7, root + 12]
	for k in range(4):
		s, e = int((k * BEAT + BEAT / 2) * SR), int((k * BEAT + BEAT * 0.85) * SR)
		tt = t[s:e] - t[s]
		out[s:e] = sum(saw(note(n), tt, 14) for n in chord) * np.exp(-tt / 0.12)
	return out * 0.35


def lead_bar(bar_index, seconds):
	t = t_axis(seconds)
	out = np.zeros_like(t)
	notes = [90, 93, 96, 100, 96, 93, 91, 95]      # F#6..E7, 1.48-2.64 kHz: inside band 1
	step = BEAT / 2
	for k in range(int(seconds / step)):
		n = notes[(k + bar_index * 2) % len(notes)]
		s, e = int(k * step * SR), int((k * step + step * 0.9) * SR)
		tt = t[s:e] - t[s]
		square = np.sign(np.sin(2 * np.pi * note(n) * tt))
		out[s:e] = one_pole_lowpass(square, 3000) * np.exp(-tt / 0.25)
	return out * 0.55


# ---- arrangement ---------------------------------------------------------------

SECTIONS = [            # (name, bars)
	('intro', 8), ('build', 4), ('drop1', 8), ('breakdown', 4), ('drop2', 8), ('outro', 2),
]


def render():
	total = sum(b for _, b in SECTIONS) * BAR
	track = np.zeros(int(total * SR) + SR)
	bar = 0
	for name, bars in SECTIONS:
		for b in range(bars):
			start = (bar + b) * BAR
			root = PROGRESSION[(bar + b) % 4]
			if name in ('intro', 'breakdown', 'outro'):
				place(track, pad_bar(root, BAR), start, 0.8 if name == 'intro' else 0.6)
				if name == 'intro' and b >= 4:
					for k in range(8):
						place(track, hat(), start + k * BEAT / 2 + BEAT / 4, 0.6)
			if name == 'build':
				place(track, pad_bar(root, BAR), start, 0.6)
				place(track, bass_bar(root, BAR), start, 0.3 + 0.15 * b)
				hits = 4 * 2 ** b                  # snare roll speeds up: 4, 8, 16, 32 per bar
				for k in range(hits):
					place(track, snare(), start + k * BAR / hits, 0.25 + 0.12 * b)
			if name in ('drop1', 'drop2'):
				for k in range(4):
					place(track, kick(), start + k * BEAT, 1.0)
					place(track, hat(open_=True), start + k * BEAT + BEAT / 2, 0.5)
				place(track, clap(), start + BEAT, 0.8)
				place(track, clap(), start + 3 * BEAT, 0.8)
				place(track, bass_bar(root, BAR), start, 0.7)
				place(track, pad_bar(root, BAR), start, 0.3)
				place(track, stab_bar(root, BAR), start, 1.0)
				if name == 'drop2':
					place(track, lead_bar(b, BAR), start, 1.0)
		bar += bars
	track = track[:int(total * SR)]
	fade = int(BAR * 2 * SR)
	track[-fade:] *= np.linspace(1, 0, fade)
	track = track / np.abs(track).max()
	track = np.tanh(track * 3.0) / np.tanh(3.0)    # limiter: pushes loudness like a mastered track
	return track * 0.9


def section_times():
	out, t = [], 0.0
	for name, bars in SECTIONS:
		out.append((name, t, t + bars * BAR))
		t += bars * BAR
	return out


if __name__ == '__main__':
	mono = render()
	stereo = np.stack([mono, mono], axis=1)
	with wave.open(sys.argv[1], 'wb') as w:
		w.setnchannels(2)
		w.setsampwidth(2)
		w.setframerate(SR)
		w.writeframes((stereo * 32767).astype(np.int16).tobytes())
	print('seconds', round(len(mono) / SR, 1))
	for name, a, b in section_times():
		print('%-10s %5.1f - %5.1f s' % (name, a, b))
