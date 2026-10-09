# Echo Shadows

*the music already has a shape. this makes it visible.*

A sound-reactive light installation by Yinglian Liu, developed from November 2023 to May 2024. Exhibited in early May 2024 at Battery Park, New York City, as part of [Illumination NYC 2024](https://www.illumination.nyc/featured-artists-battery-park-2024).

- **Project page:** https://yinglianliu.com/projects/echo-shadows
- **Videos:** https://vimeo.com/yinglian

---

## About

ECHO SHADOWS is an immersive light installation that transforms live music into a visual display. As participants stand in front of the light fixtures, the beats and rhythms are translated into vibrant color changes on the surface, casting dynamic and colored shadows that shift with the music. Through this fusion of sound, light, and shadow, Echo Shadows makes tangible the connection between musical rhythms and visual changes, offering visitors a unique sensory experience as they become part of the evolving dance of light and shadow, engaging audiences as they immerse in silhouettes shaped by the rhythm and themselves.

Visitors stand between a bank of lights and a surface, and their silhouettes become the image: the audience is not watching the piece, it is the piece. Nothing is rendered as pixels. The shadows stretch, swing and split because the light sources themselves change, while colour and intensity follow the frequency and amplitude of the music.

**Process notes**

- The physical distances between the fixtures, the people and the surface were worked out before anything was built.
- No operator runs the piece during a show. The combinations of lit bulbs are generated at random, which produces states nobody designed in advance.
- Children who played with the piece worked out on their own how to move together.

---

## How it works

```
music (computer) ─► Scarlett 2i2 loopback ─► FFT analysis ─► pattern engine ─► DMX ─► 4 fixtures × 5 RGBW bulbs ─► surface
                                                                    ▲
                                                      TouchOSC (modes, gain, demo)
```

1. **Listening.** The music plays from the computer and loops back through a Focusrite Scarlett 2i2, so the analysis hears the track itself. Every frame it is split into frequency bands. The low bands drive everything: how bright the colours are, how many bulbs light up, and how often the lighting pattern changes (every 9 s in silence, down to every 1 s at full level).
2. **Patterns.** Ten lighting patterns spread red, green and blue across the four fixtures and their five individually controlled bulbs. A timer picks a new one at random, faster when the music is louder; loud peaks push the colours to full brightness.
3. **Coloured shadows.** Each fixture lights the surface from a different position in a different colour. Where a visitor blocks one fixture, the surface shows the mix of the remaining ones, so every visitor casts several shadows at once, each in its own colour, changing with the music.

---

## Repository

```
EchoShadows/
├── Processing Version/          the original 2024 installation
│   ├── EchoShadows2024/         Processing sketch (v19)
│   └── EchoShadows2024.tosc     TouchOSC control layout (used by both versions)
└── TD Version/                  TouchDesigner rebuild with a 3D preview of the installation
```

---

## Hardware

| Item | Notes |
|---|---|
| 4 LED wash fixtures | 5 individually controlled RGBW bulbs each, set to **20-channel mode**, DMX addresses **001 / 021 / 041 / 061** |
| ENTTEC DMX USB Pro | USB-to-DMX interface |
| Focusrite Scarlett 2i2 | Audio interface; the music plays from the computer and loops back into it for analysis |
| Computer | Runs Processing or TouchDesigner |
| Computer with TouchOSC | Optional live control |

---

## Versions

### Processing version (November 2023 – May 2024)

The original installation. Development started in November 2023, the first fixture tests ran in December 2023, it was tuned indoors in April 2024 and exhibited at Battery Park for Illumination NYC 2024 in early May 2024.

The code was first published on GitHub on 2024-11-23. That snapshot is tagged [`processing-2024`](https://github.com/yinglianliu/EchoShadows/tree/processing-2024), so the original 2024 version stays easy to find even as the repository changes.

- **Tools:** Processing, Minim (audio and FFT), DMX through dmx4artists, oscP5 for TouchOSC. Install the libraries with Processing's Contribution Manager.
- **Run:** open `Processing Version/EchoShadows2024/EchoShadows2024.pde` and press Run. It listens for TouchOSC on port 9100 and sends feedback to port 12000.
- Development notes for each version (v1 to v19) are at the top of the main sketch.

### TouchDesigner version (2026, in progress)

A rebuild of the same behaviour in TouchDesigner, plus a 3D visualizer for previewing the installation before the lights are set up: the four fixtures, their beams and the coloured shadows of visitors, props and exhaled smoke on the surface.

- **Requires** TouchDesigner 2025.33230 or later.
- **Open** `TD Version/EchoShadows - TD.toe`; all controls are on the `/project1/echo_shadows` component.
- The audio analysis reproduces the Processing version, so the gains tuned in 2024 still apply.
- Setup, controls and notes on the original code's behaviour: [TD Version/README.md](TD%20Version/README.md).
- The project uses [Embody](https://github.com/dylanroscover/Embody), which stores the network and scripts as text files so they can be versioned in git.

---

## TouchOSC controls

Both versions use the same layout (`Processing Version/EchoShadows2024.tosc`). Each control sends `/<name>` with one value.

| Address | Control |
|---|---|
| `/soundMode` | Music-reactive mode |
| `/demoMode` | Manual demo mode |
| `/unit1` … `/unit4` | Light one fixture in demo mode |
| `/red` `/green` `/blue` | Demo brightness, 0–1 |
| `/NORBOOSTER` `/BOOSTER+` `/BOOSTER++` | Input gain presets for quieter sources |
| `/resetButton` | Turn every control off |
