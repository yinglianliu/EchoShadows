"""
Script SOP callbacks: branch_gen  (visualizer prop)
A tapered, forking branch about 1.4 m tall, built from 6-sided tube segments.
Deterministic: the same SEED always grows the same branch.
"""

import math
import random

SEED = 7
DEPTH = 5            # forks
TRUNK_LENGTH = 0.42  # metres
TRUNK_RADIUS = 0.022
SIDES = 6


def _basis(d):
	"""Two unit vectors perpendicular to direction d."""
	ref = (0.0, 0.0, 1.0) if abs(d[1]) > 0.9 else (0.0, 1.0, 0.0)
	a = (d[1] * ref[2] - d[2] * ref[1], d[2] * ref[0] - d[0] * ref[2], d[0] * ref[1] - d[1] * ref[0])
	la = math.sqrt(sum(c * c for c in a))
	a = tuple(c / la for c in a)
	b = (d[1] * a[2] - d[2] * a[1], d[2] * a[0] - d[0] * a[2], d[0] * a[1] - d[1] * a[0])
	return a, b


def _tilt(d, angle, spin):
	"""Rotate direction d away from itself by angle (rad), around it by spin (rad)."""
	a, b = _basis(d)
	s = math.sin(angle)
	off = tuple(math.cos(spin) * a[i] + math.sin(spin) * b[i] for i in range(3))
	v = tuple(math.cos(angle) * d[i] + s * off[i] for i in range(3))
	lv = math.sqrt(sum(c * c for c in v))
	return tuple(c / lv for c in v)


def _segments():
	rng = random.Random(SEED)
	out = []

	def grow(start, d, length, radius, depth):
		d = _tilt(d, rng.uniform(0.0, 0.12), rng.uniform(0, 2 * math.pi))
		d = (d[0], d[1] + 0.08, d[2])  # gentle phototropism
		ld = math.sqrt(sum(c * c for c in d))
		d = tuple(c / ld for c in d)
		end = tuple(start[i] + d[i] * length for i in range(3))
		out.append((start, end, radius, radius * 0.72))
		if depth == 0:
			return
		n = 2 if rng.random() < 0.55 else 3
		spin0 = rng.uniform(0, 2 * math.pi)
		for k in range(n):
			ang = math.radians(rng.uniform(22, 42))
			child = _tilt(d, ang, spin0 + k * 2 * math.pi / n)
			grow(end, child, length * rng.uniform(0.66, 0.8), radius * 0.72, depth - 1)

	grow((0.0, 0.0, 0.0), (0.0, 1.0, 0.0), TRUNK_LENGTH, TRUNK_RADIUS, DEPTH)
	return out


def onSetupParameters(scriptOp):
	return


def onPulse(par):
	return


def onCook(scriptOp):
	scriptOp.clear()
	for start, end, r0, r1 in _segments():
		d = tuple(end[i] - start[i] for i in range(3))
		ld = math.sqrt(sum(c * c for c in d))
		d = tuple(c / ld for c in d)
		a, b = _basis(d)
		rings = []
		for centre, r in ((start, r0), (end, r1)):
			ring = []
			for s in range(SIDES):
				t = 2 * math.pi * s / SIDES
				pt = scriptOp.appendPoint()
				pt.P = tuple(centre[i] + r * (math.cos(t) * a[i] + math.sin(t) * b[i]) for i in range(3))
				ring.append(pt)
			rings.append(ring)
		for s in range(SIDES):
			quad = scriptOp.appendPoly(4, closed=True, addPoints=False)
			quad[0].point = rings[0][s]
			quad[1].point = rings[0][(s + 1) % SIDES]
			quad[2].point = rings[1][(s + 1) % SIDES]
			quad[3].point = rings[1][s]
	return
