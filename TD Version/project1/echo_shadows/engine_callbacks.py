"""
Script CHOP callbacks: engine
Input 0: audio (switch_audio: Line In or a test file), stereo.
Output:  dmx1..dmx80 (-> null_engine -> select_dmx -> dmxout1)
         dbg_* channels for monitoring (band data, p, sw, fade, state).
Controls are the custom parameters on parent.Echo (Control / Audio pages).
"""

import numpy as np

FFT_SIZE = 1024   # Minim getLineIn() default buffer size
STATES = {'OFF': 0, 'DEMO': 1, 'NORMAL': 2, 'ST1': 3, 'ST2': 4}
BOOSTER_KEYS = {'norbooster': 'NORBOOSTER', 'boosterplus': 'BOOSTER+', 'boosterplus2': 'BOOSTER++'}

# live engine + audio buffer; kept out of op storage because EchoEngine cannot be pickled into the .toe
STATE = {}


def _controls(p):
	booster = BOOSTER_KEYS.get(p.Booster.eval())
	return {
		'soundMode': float(p.Soundmode.eval()), 'demoMode': float(p.Demomode.eval()),
		'unit1': float(p.Unit1.eval()), 'unit2': float(p.Unit2.eval()),
		'unit3': float(p.Unit3.eval()), 'unit4': float(p.Unit4.eval()),
		'NORBOOSTER': float(booster == 'NORBOOSTER'),
		'BOOSTER+': float(booster == 'BOOSTER+'),
		'BOOSTER++': float(booster == 'BOOSTER++'),
		'red': p.Red.eval(), 'green': p.Green.eval(), 'blue': p.Blue.eval(),
	}


def onSetupParameters(scriptOp):
	return


def onPulse(par):
	return


def onCook(scriptOp):
	mod = op('echo_engine').module
	p = parent.Echo.par

	engine = STATE.get('engine')
	if engine is None:
		engine = mod.EchoEngine()
		STATE['engine'] = engine
	engine.legacy_demo_override = bool(p.Legacydemo.eval())

	# rolling 1024-sample mono buffer (Minim: myAudio.mix = (L + R) / 2)
	buf = STATE.get('audio_buf')
	if buf is None:
		buf = np.zeros(FFT_SIZE, dtype=np.float32)
	if scriptOp.inputs:
		block = scriptOp.inputs[0].numpyArray()
		if block is not None and block.size:
			buf = np.concatenate([buf, block.mean(axis=0)])[-FFT_SIZE:]
	STATE['audio_buf'] = buf

	avgs = mod.minim_lin_averages(buf, 15)
	values = engine.update(avgs, _controls(p), absTime.seconds * 1000.0,
						   input_gain=p.Inputgain.eval())

	scriptOp.clear()
	scriptOp.isTimeSlice = False
	scriptOp.numSamples = 1
	for i, v in enumerate(values):
		scriptOp.appendChan('dmx{}'.format(i + 1))[0] = v

	debug = {
		'dbg_d0': engine.data[0], 'dbg_d1': engine.data[1], 'dbg_d2': engine.data[2],
		'dbg_p': engine.p, 'dbg_sw': engine.sw, 'dbg_fade': engine.fade,
		'dbg_switch_s': engine.switch_ms / 1000.0, 'dbg_state': STATES.get(engine.state, -1),
	}
	for name, v in debug.items():
		scriptOp.appendChan(name)[0] = v

	return
