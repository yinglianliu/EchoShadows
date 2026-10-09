"""
Parameter Execute DAT: control_parexec (watches parent.Echo, custom pars only)
Reset        -> every control back to 0 here and on TouchOSC (/resetButton does the same)
Resetengine  -> fresh EchoEngine (pattern timer, fades, DMX targets)
Openpreview  -> floating window with the visualizer output
Layoutpreset / Applylayout -> write the chosen fixture layout into the Fixtures page
"""

# same list as oscAddr[] in the Processing sketch
OSC_ADDRESSES = ['/soundMode', '/demoMode', '/unit1', '/unit2', '/unit3', '/unit4',
				 '/NORBOOSTER', '/BOOSTER+', '/BOOSTER++', '/threshold', '/red', '/green', '/blue']
RESET_PARS = ['Soundmode', 'Demomode', 'Unit1', 'Unit2', 'Unit3', 'Unit4', 'Red', 'Green', 'Blue']


def onPulse(par):
	comp = parent.Echo
	if par.name == 'Reset':
		for name in RESET_PARS:
			comp.par[name] = 0
		comp.par.Booster = 'default'
		osc = op('oscout_touchosc')
		for addr in OSC_ADDRESSES:
			osc.sendOSC(addr, [0.0])
	elif par.name == 'Applylayout':
		_applyLayout()
	elif par.name == 'Openpreview':
		op('visualizer/out1').openViewer(unique=True, borders=True)
	elif par.name == 'Resetengine':
		op('engine_callbacks').module.STATE.clear()
	return


def onValueChange(par, prev):
	if par.name == 'Layoutpreset':
		_applyLayout()
	return


def _applyLayout():
	module = op('visualizer/fixture_data_callbacks').module
	module.apply_layout(parent.Echo, parent.Echo.par.Layoutpreset.eval())
