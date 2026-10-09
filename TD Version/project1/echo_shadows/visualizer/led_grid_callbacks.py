"""
Script TOP callbacks: led_grid  (visualizer)
The 4 units x 5 LEDs as a flat grid, unit 1 on the top row.
"""

import numpy as np

CELL = 44
GAP = 8
BG = (0.02, 0.02, 0.025, 0.75)


def onSetupParameters(scriptOp):
	return


def onPulse(par):
	return


def onCook(scriptOp):
	dmx = parent.Echo.op('null_engine')
	rows, cols = 4, 5
	h, w = rows * (CELL + GAP) + GAP, cols * (CELL + GAP) + GAP
	img = np.empty((h, w, 4), dtype=np.float32)
	img[:] = BG
	for u in range(rows):
		for k in range(cols):
			base = u * 20 + k * 4
			white = dmx['dmx{}'.format(base + 4)].eval() / 255.0 if dmx else 0.0
			rgb = [min(1.0, (dmx['dmx{}'.format(base + c + 1)].eval() / 255.0 if dmx else 0.0) + white)
				   for c in range(3)]
			y0 = h - (u + 1) * (CELL + GAP)  # numpy row 0 is the bottom of a TOP
			x0 = GAP + k * (CELL + GAP)
			img[y0:y0 + CELL, x0:x0 + CELL] = (0.12 + 0.88 * rgb[0], 0.12 + 0.88 * rgb[1], 0.12 + 0.88 * rgb[2], 1.0)
	scriptOp.copyNumpyArray(img)
	return
