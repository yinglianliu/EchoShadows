"""
Script CHOP callbacks: smoke_proj  (visualizer)
Where the smoke sheet sits in each light's projector image, one sample per light:
cu, cv = centre (0-1), su, sv = size (0-1). Drives the gobo_N Transform TOPs.
"""

import math

SMOKE_W = 1.3        # metres, must match geo_smoke/sheet
SMOKE_H = 1.9
MOUTH_Y = 1.58       # height of the first visitor's mouth
FRONT = 0.25         # smoke sheet sits this far in front of the face, toward the wall
PROJ_FOV = 90.0      # = projangle on every light


def _to_light(v, rx, ry):
	"""World vector into a light's local frame (undo ry, then rx)."""
	a, b = math.radians(-rx), math.radians(-ry)
	x, y, z = v
	x, z = x * math.cos(b) + z * math.sin(b), -x * math.sin(b) + z * math.cos(b)
	y, z = y * math.cos(a) - z * math.sin(a), y * math.sin(a) + z * math.cos(a)
	return x, y, z


def sheet_centre():
	person = parent.Vis.op('geo_person')
	bottom = MOUTH_Y - 0.05 * SMOKE_H   # the mouth is 5% up from the bottom of the image
	return (person.par.tx.eval(), bottom + SMOKE_H / 2, person.par.tz.eval() - FRONT)


def onSetupParameters(scriptOp):
	return


def onPulse(par):
	return


def onCook(scriptOp):
	fx = parent.Vis.op('fixture_data')
	cx, cy, cz = sheet_centre()
	k = 1.0 / (2.0 * math.tan(math.radians(PROJ_FOV) / 2.0))
	scriptOp.clear()
	scriptOp.numSamples = 4
	chans = {n: scriptOp.appendChan(n) for n in ('cu', 'cv', 'su', 'sv')}
	for i in range(4):
		lx, ly, lz = _to_light((cx - fx['tx'][i], cy - fx['ty'][i], cz - fx['tz'][i]), fx['rx'][i], fx['ry'][i])
		depth = max(-lz, 0.01)
		vals = dict(cu=0.5 + lx / depth * k, cv=0.5 + ly / depth * k,
					su=SMOKE_W / depth * k, sv=SMOKE_H / depth * k)
		for n, ch in chans.items():
			ch[i] = vals[n]
	return
