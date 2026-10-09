"""
OSC In DAT callbacks: oscin_touchosc (port 9100, same as the 2024 sketch)
TouchOSC layout: ../../Processing Version/EchoShadows2024.tosc
Every control sends '/<name>' with one float, e.g. /soundMode 1.0, /red 0.42.
Messages are written into the custom parameters of parent.Echo.
"""

TOGGLES = {'soundMode': 'Soundmode', 'demoMode': 'Demomode',
		   'unit1': 'Unit1', 'unit2': 'Unit2', 'unit3': 'Unit3', 'unit4': 'Unit4'}
FADERS = {'red': 'Red', 'green': 'Green', 'blue': 'Blue'}
BOOSTERS = {'NORBOOSTER': 'norbooster', 'BOOSTER+': 'boosterplus', 'BOOSTER++': 'boosterplus2'}


def onReceiveOSC(dat, rowIndex, message, byteData, timeStamp, address, args, peer):
	if not args:
		return
	key = address.lstrip('/')
	value = float(args[0])
	p = parent.Echo.par

	if key in TOGGLES:
		p[TOGGLES[key]] = int(value == 1)
	elif key in FADERS:
		p[FADERS[key]] = value
	elif key in BOOSTERS:
		# Processing: a booster only applies while exactly that button is on
		if value == 1:
			p.Booster = BOOSTERS[key]
		elif p.Booster.eval() == BOOSTERS[key]:
			p.Booster = 'default'
	elif key == 'resetButton' and value == 1:
		p.Reset.pulse()
	return
