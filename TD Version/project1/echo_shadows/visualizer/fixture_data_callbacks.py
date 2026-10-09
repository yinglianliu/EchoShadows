"""
Script CHOP callbacks: fixture_data  (visualizer)
One sample per fixture (4): position, aim rotation, beam colour, housing size and stand.
Positions, aim points and bulb-row direction come from the Fixtures page of parent.Echo.
Beam colour = sum of the unit's 5 LEDs (RGB + W) / 5, times Visgain (used for the smoke glow).
"""

import math

# Layout presets: per unit (x, height, distance from wall, aim x on wall, aim height on wall, bulb row), metres.
# x is left to right as seen by the audience; the wall is at distance 0.
# Bulb row: 'horizontal' = the 5 bulbs run left to right (fixtures on the floor),
# 'vertical' = bottom to top (hung fixtures), so lighting them in turn makes the shadow grow taller.
LAYOUTS = {
	'floorrow': [(-1.8, 0.35, 3.2, -0.63, 1.5, 'horizontal'), (-0.6, 0.35, 3.2, -0.21, 1.5, 'horizontal'),
				 (0.6, 0.35, 3.2, 0.21, 1.5, 'horizontal'), (1.8, 0.35, 3.2, 0.63, 1.5, 'horizontal')],
	# units 1 & 2 hung on stands (about 5 ft, one higher), 3 & 4 on the floor (one raised on a box)
	'pairs': [(-1.6, 1.65, 3.0, -0.55, 1.6, 'vertical'), (1.6, 1.4, 3.0, 0.55, 1.5, 'vertical'),
			  (-0.6, 0.25, 3.2, -0.2, 1.6, 'horizontal'), (0.6, 0.5, 3.2, 0.2, 1.6, 'horizontal')],
	# hung and floor units alternate: 1 & 3 hung, 2 & 4 on the floor
	'mixed': [(-1.8, 1.65, 3.0, -0.6, 1.6, 'vertical'), (-0.6, 0.25, 3.2, -0.2, 1.6, 'horizontal'),
			  (0.6, 1.4, 3.0, 0.2, 1.5, 'vertical'), (1.8, 0.5, 3.2, 0.6, 1.6, 'horizontal')],
}
HOUSING_LONG = 0.46   # housing size along the bulb row
HOUSING_SHORT = 0.13
STAND_MIN = 0.6       # fixtures higher than this get a stand drawn under them


def apply_layout(comp, name):
	"""Write a preset into the Fixtures page of comp (the echo_shadows COMP)."""
	for n, (x, y, z, ax, ay, row) in enumerate(LAYOUTS[name], start=1):
		comp.par['Fix%dposx' % n] = x
		comp.par['Fix%dposy' % n] = y
		comp.par['Fix%dposz' % n] = z
		comp.par['Fix%daimx' % n] = ax
		comp.par['Fix%daimy' % n] = ay
		comp.par['Fix%drow' % n] = row


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
	echo = parent.Echo
	p = echo.par
	dmx = echo.op('null_engine')
	gain = p.Visgain.eval()
	scriptOp.clear()
	scriptOp.numSamples = 4
	names = ('tx', 'ty', 'tz', 'rx', 'ry', 'r', 'g', 'b', 'vertical', 'sx', 'sy', 'standh', 'standon')
	chans = {n: scriptOp.appendChan(n) for n in names}
	for u in range(4):
		n = u + 1
		pos = (p['Fix%dposx' % n].eval(), p['Fix%dposy' % n].eval(), p['Fix%dposz' % n].eval())
		rx, ry = aim_rotation(pos, (p['Fix%daimx' % n].eval(), p['Fix%daimy' % n].eval(), 0.0))
		vertical = p['Fix%drow' % n].eval() == 'vertical'
		sx, sy = (HOUSING_SHORT, HOUSING_LONG) if vertical else (HOUSING_LONG, HOUSING_SHORT)
		hung = pos[1] > STAND_MIN
		rgb = [0.0, 0.0, 0.0]
		for k in range(5):
			base = u * 20 + k * 4
			w = dmx['dmx{}'.format(base + 4)].eval() if dmx else 0.0
			for c in range(3):
				rgb[c] += ((dmx['dmx{}'.format(base + c + 1)].eval() if dmx else 0.0) + w) / 255.0
		vals = dict(tx=pos[0], ty=pos[1], tz=pos[2], rx=rx, ry=ry,
					r=rgb[0] / 5 * gain, g=rgb[1] / 5 * gain, b=rgb[2] / 5 * gain,
					vertical=float(vertical), sx=sx, sy=sy,
					standh=pos[1] - sy / 2 if hung else 0.0, standon=float(hung))
		for name, ch in chans.items():
			ch[u] = vals[name]
	return
