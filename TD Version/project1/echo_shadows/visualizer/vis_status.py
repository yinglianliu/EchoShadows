"""
Text DAT module: vis_status  (visualizer)
status_text() feeds the status overlay Text TOP.
"""

STATE_LABELS = {'OFF': 'OFF', 'DEMO': 'DEMO', 'NORMAL': 'SOUND - normal', 'ST1': 'SOUND - ST1 peak', 'ST2': 'SOUND - ST2 peak'}
BOOSTER_LABELS = {'default': 'Default', 'NORBOOSTER': 'NORBOOSTER', 'BOOSTER+': 'BOOSTER+', 'BOOSTER++': 'BOOSTER++'}


def status_text():
	eng = parent.Echo.op('engine_callbacks').module.STATE.get('engine')
	if eng is None:
		return 'engine not running'
	state = STATE_LABELS.get(eng.state, eng.state)
	d0, d1, d2 = eng.data[:3]
	data = 'd0 {:5.1f}   d1 {:5.1f}   d2 {:5.1f}'.format(d0, d1, d2)
	if eng.state in ('OFF', 'DEMO'):
		return state + '\n' + data
	lines = [
		'{}   |   booster {}'.format(state, BOOSTER_LABELS.get(eng.booster, eng.booster)),
		'pattern {:>2}: {}   |   p = {}   |   next switch every {:.1f} s'.format(eng.sw, eng.pattern_name, eng.p, eng.switch_ms / 1000.0),
		data,
	]
	return '\n'.join(lines)
