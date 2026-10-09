"""
Script CHOP callbacks: led_data  (visualizer)
Input 0: fixture_data. One sample per LED (20): world position, rotation, colour.
Unlit LEDs keep a dim grey floor so the bulbs stay readable.
"""

import math

LED_SPACING = 0.08   # metres between the 5 LEDs of one unit
FRONT = -0.05        # front half of the housing (local -Z faces the wall)
TOP = 0.07           # bulbs peek over the housing top so they read from behind the fixtures
FLOOR = 0.07


def rotate(v, rx, ry):
	"""Rotate a local vector by rx then ry (degrees), matching rotate order xyz."""
	a, b = math.radians(rx), math.radians(ry)
	x, y, z = v
	y, z = y * math.cos(a) - z * math.sin(a), y * math.sin(a) + z * math.cos(a)
	x, z = x * math.cos(b) + z * math.sin(b), -x * math.sin(b) + z * math.cos(b)
	return x, y, z


def onSetupParameters(scriptOp):
	return


def onPulse(par):
	return


def onCook(scriptOp):
	fx = scriptOp.inputs[0] if scriptOp.inputs else None
	dmx = parent.Echo.op('null_engine')
	scriptOp.clear()
	scriptOp.numSamples = 20
	chans = {n: scriptOp.appendChan(n) for n in ('tx', 'ty', 'tz', 'rx', 'ry', 'r', 'g', 'b')}
	if fx is None:
		return
	for u in range(4):
		px, py, pz = fx['tx'][u], fx['ty'][u], fx['tz'][u]
		rx, ry = fx['rx'][u], fx['ry'][u]
		for k in range(5):
			i = u * 5 + k
			ox, oy, oz = rotate(((k - 2) * LED_SPACING, TOP, FRONT), rx, ry)
			base = u * 20 + k * 4
			w = dmx['dmx{}'.format(base + 4)].eval() / 255.0 if dmx else 0.0
			rgb = [min(1.0, (dmx['dmx{}'.format(base + c + 1)].eval() / 255.0 if dmx else 0.0) + w) for c in range(3)]
			rgb = [FLOOR + (1.0 - FLOOR) * c for c in rgb]
			vals = dict(tx=px + ox, ty=py + oy, tz=pz + oz, rx=rx, ry=ry, r=rgb[0], g=rgb[1], b=rgb[2])
			for n, ch in chans.items():
				ch[i] = vals[n]
	return
