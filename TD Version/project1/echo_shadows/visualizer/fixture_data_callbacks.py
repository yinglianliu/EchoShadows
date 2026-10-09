"""
Script CHOP callbacks: fixture_data  (visualizer)
One sample per fixture (4): position, aim rotation and beam colour.
Beam colour = sum of the unit's 5 LEDs (RGB + W) / 5, times Visgain.
"""

import math

FIXTURE_X = [-1.8, -0.6, 0.6, 1.8]   # metres, left to right, seen from the audience
FIXTURE_Y = 0.35                      # on the floor, slightly raised
FIXTURE_Z = 3.2                       # distance from the wall
AIM_Y = 1.5                           # where the beams meet the wall
AIM_SPREAD = 0.35                     # 0 = all aim at the wall centre, 1 = straight ahead


def aim_rotation(pos, target):
	"""rx, ry (degrees) that turn TD's default -Z forward toward target (rotate order xyz)."""
	dx, dy, dz = (target[i] - pos[i] for i in range(3))
	length = math.sqrt(dx * dx + dy * dy + dz * dz)
	rx = math.degrees(math.asin(dy / length))
	ry = math.degrees(math.atan2(-dx, -dz))
	return rx, ry


def onSetupParameters(scriptOp):
	return


def onPulse(par):
	return


def onCook(scriptOp):
	dmx = parent.Echo.op('null_engine')
	gain = parent.Echo.par.Visgain.eval()
	scriptOp.clear()
	scriptOp.numSamples = 4
	chans = {n: scriptOp.appendChan(n) for n in ('tx', 'ty', 'tz', 'rx', 'ry', 'r', 'g', 'b')}
	for u, x in enumerate(FIXTURE_X):
		pos = (x, FIXTURE_Y, FIXTURE_Z)
		rx, ry = aim_rotation(pos, (x * AIM_SPREAD, AIM_Y, 0.0))
		rgb = [0.0, 0.0, 0.0]
		for k in range(5):
			base = u * 20 + k * 4
			w = dmx['dmx{}'.format(base + 4)].eval() if dmx else 0.0
			for c in range(3):
				rgb[c] += ((dmx['dmx{}'.format(base + c + 1)].eval() if dmx else 0.0) + w) / 255.0
		vals = dict(tx=x, ty=FIXTURE_Y, tz=FIXTURE_Z, rx=rx, ry=ry,
					r=rgb[0] / 5 * gain, g=rgb[1] / 5 * gain, b=rgb[2] / 5 * gain)
		for n, ch in chans.items():
			ch[u] = vals[n]
	return
