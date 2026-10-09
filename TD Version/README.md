# Echo Shadows: TouchDesigner Version

A TouchDesigner rebuild of the 2024 Processing installation (`../Processing Version/EchoShadows2024`, v19). The project is managed with Embody: the network is stored as `.tdxn` text and every script as a `.py` / `.glsl` file, so everything can be tracked in git.

```
TD Version/
├── EchoShadows - TD.toe                  TD project (incremental saves such as .7.toe are not tracked)
└── project1/
    ├── echo_shadows.tdxn                 the whole network: operators, parameters, wiring, annotations
    └── echo_shadows/
        ├── echo_engine.py                core logic: Minim-style FFT, ST1/ST2/NORMAL, 10 patterns, fades
        ├── engine_callbacks.py           Script CHOP: audio -> dmx1..dmx80 + dbg_* channels
        ├── oscin_touchosc_callbacks.py   TouchOSC -> Control parameters
        ├── control_parexec.py            Reset / Reset Engine / Open Preview Window buttons
        └── visualizer/                   scripts and shader of the 3D preview
```

**Edit code in TD or directly in these files** (Embody keeps both in sync). Never edit `externalizations.tsv` by hand.

---

## 1. How to use it

Open `/project1/echo_shadows`; every control lives in this component's parameters:

| Page | Parameter | What it does |
|---|---|---|
| Control | Sound Mode / Demo Mode | Same as TouchOSC `/soundMode` and `/demoMode` |
| | Unit 1–4, Red / Green / Blue | Light single units by hand in Demo mode |
| | Booster | Default / NORBOOSTER / BOOSTER+ / BOOSTER++ |
| | Reset Controls | Set everything to 0, here and on TouchOSC |
| Audio | Audio Source | **Line In** (the audio interface at the venue) or **Test File** (preview without live music) |
| | Test Audio File | Defaults to a TD sample track; replace it with your own music |
| | Input Gain | Overall input gain; adjust this first after changing the audio interface |
| | Monitor Test File | Play the test file through the computer speakers |
| Engine | Legacy Demo Override | On = exactly like 2024 (see section 4, item 1) |
| | Reset Engine | Restart the engine |
| | DMX Output Active | **Turn on only after the ENTTEC is plugged in** |
| Visualizer | Open Preview Window | Open the preview in a floating window |
| | Beam Brightness / Moving Visitor | Preview only, no effect on DMX |
| | Second Visitor | A second visitor with raised arms, further back on the left |
| | Prop: Hanging Lattice / Prop: Branch | A perforated panel turning on a string / a branch in a pot |
| | Smoke / Smoke Puff Every / Smoke Density | The first visitor exhales a puff every few seconds; it glows in the beams and throws coloured smoke shadows on the wall |

**Preview**: `echo_shadows/visualizer` is a Container COMP whose background is the preview image, so its node tile shows it directly; right-click it → View for a large window, or press **Open Preview Window** on the Visualizer page of `echo_shadows`.
- 3D scene: 4 fixtures on the floor, 3.2 m from the wall and 1.2 m apart, aimed at the wall; a slowly swaying visitor 1.5 m in front of the wall; coloured shadows on the wall
- Top left: live colour of the 4×5 LEDs (U1 is the top row)
- Top right: current state, pattern number and name, p, switch interval, d0/d1/d2
- Smoke shadows: `smoke_density` (GLSL) draws the puff, `smoke_proj` works out where it sits in each light's view, and `gobo1–4` are the lights' projector maps that cast the smoke onto the wall, so the 4 fixtures throw 4 offset, differently coloured smoke shadows.

Fixture positions and aim are at the top of `visualizer/fixture_data_callbacks.py` (`FIXTURE_X`, `FIXTURE_Z`, `AIM_Y`, …); change them to match the venue.

---

## 2. Network

```
audiodevin1 ─┐
             ├─ switch_audio ─ engine (Script CHOP) ─ null_engine ─ select_dmx ─ dmxout1 (ENTTEC USB Pro)
audiofilein1 ┘                    │                      │
      └─ audiodevout1             echo_engine (module)   └─► visualizer (reads null_engine)

oscin_touchosc (9100) ─► Control parameters ◄─ control_parexec ─► oscout_touchosc (12000)
```

---

## 3. Before connecting the lights

1. **Fixture channel mode: 20CH.** The Processing code uses the 20-channel mode (`lightChannels = 20`; the 2023-12-18 note says "20 channel mode"): 5 LEDs × RGBW = 20 channels per fixture. The 22CH mode in the fixture menu usually adds master dimmer and strobe channels, so the channel layout is different.
2. **DMX addresses:** Unit 1 = 001, Unit 2 = 021, Unit 3 = 041, Unit 4 = 061.
3. **ENTTEC DMX USB Pro:** once plugged in, pick `/dev/cu.usbserial-…` on the Serial page of `dmxout1`, then turn on **DMX Output Active** on `echo_shadows`.
4. **TouchOSC:** keep using `Processing Version/EchoShadows2024.tosc`. Connections → OSC: Host = IP of the computer running TD, Send Port 9100, Receive Port 12000.

---

## 4. Behaviour of the original code and open decisions

**Pattern switch time** follows d0 (low-band level): `switchTime = map(d0, 0, 100, 9000, 1000)`. Silence switches every 9 s, full level every 1 s, linear in between. When the time is up, one of the 10 patterns is picked at random (it can pick the same one again).

1. **Some colours were always off in sound mode.** `draw()` runs the unit1–4 demo blocks at the end of every frame. Outside Demo mode they write 0 to unit1 red, unit2 green, unit3 blue and 7 channels of unit4, so in 2024 unit1 never showed red in sound mode. **Legacy Demo Override** On keeps that behaviour; Off shows every colour the patterns were designed with. The saved project currently has it **Off**; toggle it in the preview to compare.
2. **The ST1/ST2 colours are constants.** `map(diff, 0, diff/510, …)` does not depend on diff and always gives 325 (full brightness); `p` is random 1–5 (1–6 in ST2).
3. **Reset:** the original only zeroed the TouchOSC interface, not the sketch's internal state. The TD version resets both.
4. **The W (white) channels** are not used anywhere in the project.
5. The three mutually exclusive booster buttons became one menu in TD. Booster messages from TouchOSC are translated into the matching menu entry.

---

## 5. Why a custom FFT

`echo_engine.py` reproduces Minim's FFT in Python (1024 points, Hamming window, 15 linear bands, including its divide-by-(j+1) averaging) instead of using TD's Audio Spectrum CHOP. That way the gains and threshold tuned in room 103B in 2024 (amp/index/step, th = 69) still apply. After changing the audio interface, adjust **Input Gain** first.
