"""
Script CHOP callbacks: led_data  (visualizer)
Input 0: fixture_data. One sample per bulb (20, unit-major).
Bulb row runs along local x (horizontal units) or local y (vertical units), bulb 1 = left / bottom.
  tx ty tz r g b   visible bulb: peeks out of the housing so it reads from behind the fixture,
                   unlit bulbs keep a dim grey floor
  lx ly lz         emitter on the front face, drives light_<unit>_<bulb>
  lr lg lb         emitted colour: (RGB + W) / 255 / 5 * Visgain, so 5 bulbs add up to the old single beam
"""

import math

LED_SPACING = 0.08   # metres between the 5 bulbs of one unit
FRONT = -0.08        # front face of the housing (local -Z faces the wall)
PEEK = 0.07          # how far the visible bulbs stick out past the housing edge
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
	gain = parent.Echo.par.Visgain.eval()
	scriptOp.clear()
	scriptOp.numSamples = 20
	names = ('tx', 'ty', 'tz', 'rx', 'ry', 'r', 'g', 'b', 'lx', 'ly', 'lz', 'lr', 'lg', 'lb')
	chans = {n: scriptOp.appendChan(n) for n in names}
	if fx is None:
		return
	for u in range(4):
		px, py, pz = fx['tx'][u], fx['ty'][u], fx['tz'][u]
		rx, ry = fx['rx'][u], fx['ry'][u]
		vertical = fx['vertical'][u] > 0.5
		for k in range(5):
			i = u * 5 + k
			along = (k - 2) * LED_SPACING
			row = (0.0, along, 0.0) if vertical else (along, 0.0, 0.0)
			peek = (PEEK, 0.0, 0.0) if vertical else (0.0, PEEK, 0.0)
			ex, ey, ez = rotate((row[0], row[1], FRONT), rx, ry)
			bx, by, bz = rotate((row[0] + peek[0], row[1] + peek[1], FRONT + 0.03), rx, ry)
			base = u * 20 + k * 4
			w = dmx['dmx{}'.format(base + 4)].eval() / 255.0 if dmx else 0.0
			raw = [(dmx['dmx{}'.format(base + c + 1)].eval() / 255.0 if dmx else 0.0) + w for c in range(3)]
			shown = [FLOOR + (1.0 - FLOOR) * min(1.0, c) for c in raw]
			vals = dict(tx=px + bx, ty=py + by, tz=pz + bz, rx=rx, ry=ry, r=shown[0], g=shown[1], b=shown[2],
						lx=px + ex, ly=py + ey, lz=pz + ez,
						lr=raw[0] / 5 * gain, lg=raw[1] / 5 * gain, lb=raw[2] / 5 * gain)
			for n, ch in chans.items():
				ch[i] = vals[n]
	return
