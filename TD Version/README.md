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
tools/
├── shadow_etudes.py                      composes "Shadow Etudes", music written to steer the shadows
└── make_synth_track.py                   a 124 BPM electronic test track with two drops
test_audio/                               generated test music (not tracked in git)
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
| Fixtures | Layout Preset / Apply Layout Preset | **Floor Row** (all four on the floor), **Pairs** (units 1 & 2 hung on stands, 3 & 4 on the floor), **Mixed** (1 & 3 hung, 2 & 4 on the floor). Choosing one fills in the values below |
| | Unit 1–4 Position / Aim on Wall | Each fixture's position (x, height, distance from wall) and the point on the wall it is aimed at, in metres |
| | Unit 1–4 Bulb Row | **Horizontal**: the 5 bulbs run left to right (floor fixtures). **Vertical**: bottom to top (hung fixtures); lighting the bulbs in turn makes the shadow grow taller |

**Preview**: `echo_shadows/visualizer` is a Container COMP whose background is the preview image, so its node tile shows it directly; right-click it → View for a large window, or press **Open Preview Window** on the Visualizer page of `echo_shadows`.
- 3D scene: 4 fixtures aimed at the wall (positions on the Fixtures page), one swaying visitor 1.5 m and a second one 0.9 m in front of the wall, coloured shadows on the wall
- Top left: live colour of the 4×5 LEDs (U1 is the top row)
- Top right: current state, pattern number and name, p, switch interval, d0/d1/d2
- Smoke shadows: `smoke_density` (GLSL) draws the puff, `smoke_proj` works out where it sits in each light's view, and `gobo1–4` are the lights' projector maps that cast the smoke onto the wall, so the 4 fixtures throw 4 offset, differently coloured smoke shadows.

Each of the 20 bulbs is its own shadow-casting light (`light_<unit>_<bulb>`), so the shadows from one fixture are offset by the bulb spacing; that is what makes them grow taller (vertical row) or spread sideways (horizontal row) as the bulbs light in turn. The scene is rendered once per fixture (`render1`–`render4`, five lights each, to stay under the GPU's limit on shadow maps per pass) and the passes are added together in `comp_light`.

Fixture positions live on the **Fixtures** page; the presets themselves are defined in `LAYOUTS` at the top of `visualizer/fixture_data_callbacks.py`. Hung fixtures (higher than 0.6 m) are drawn on a stand.

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

`echo_engine.py` reproduces Minim's FFT in Python (1024 points, Hamming window, 15 linear bands, including its divide-by-(j+1) averaging) instead of using TD's Audio Spectrum CHOP. That way the gains and threshold tuned indoors in 2024 (amp/index/step, th = 69) still apply. After changing the audio interface, adjust **Input Gain** first.

---

## 6. Test music written for the engine

The scripts in `tools/` synthesize music from plain waveforms (sines, saws, filtered noise) with numpy. Run them from this folder with TouchDesigner's bundled Python, then pick the file as **Test Audio File**:

```
/Applications/TouchDesigner.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 tools/shadow_etudes.py test_audio/shadow_etudes.wav
```

**Shadow Etudes** (80 s) is composed backwards from the engine: the score is a pair of target curves for d0 and d1, played by a warm chord timbre that only sounds in band 0 (0–1.47 kHz) and a bell timbre that only sounds in band 1 (1.47–2.94 kHz). Each timbre is calibrated so the needed loudness can be computed from the target. Measured with the Default booster:

| Section | Intention | Result |
|---|---|---|
| Breath (0–24 s) | Slow low swells: 1 → 5 → 1 bulbs, shadows grow and shrink | NORMAL, p rises and falls 1 → 5 → 1 |
| Heartbeat (24–40 s) | An accelerating lub-dub | NORMAL, p pulses between 1 and 3 |
| Fireflies (40–52 s) | One dim bulb, random bell sparkles tint it green | NORMAL, d1 up to ~66 |
| Storm (52–64 s) | Low and bright accents alternating at 140 BPM | ST1 about a third of the time, fast switching |
| Twins (64–72 s) | Both bands saturated | ST2 about 90% of the time (p reaches 6) |
| Exhale (72–80 s) | One long breath out | Back to one bulb |

What the engine responds to:
- In NORMAL, the number of lit bulbs follows the **level** of band 0, not the beat: p = 1 + d0 × 0.04. A slow low crescendo lights the bulbs one by one, which on a vertical fixture makes the shadow grow taller.
- Keeping band 1 below d1 = 10 holds the engine in NORMAL however loud the lows get; band 1 above 10 with d0 above 69 gives ST1.
- ST2 needs bands 0 and 1 both saturated at once, which ordinary music rarely does: a deliberate climax.
- Each band is the average of 35 FFT bins, so energy spread across the band counts far more than a single loud low note. Mixed and mastered music fills the bands; a bare kick drum barely moves them.
