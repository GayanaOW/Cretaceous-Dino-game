<div align="center">

# 🦖 Dinosaur Survival Game

*A long-term survival game inspired by 7 Days to Die — dinosaurs instead of zombies.*

You and your friends wake up as dinosaurs from a park have escaped into the world. Craft, build, and survive.

![Engine](https://img.shields.io/badge/Engine-Godot%204.7.1-478CBF?logo=godotengine&logoColor=white)
![Language](https://img.shields.io/badge/Language-GDScript-355570)
![Status](https://img.shields.io/badge/Status-Phase%202%20Polish-yellow)
![License](https://img.shields.io/badge/License-TBD-lightgrey)

</div>

---

## 📋 Status

**MVP complete** — currently in a Phase 2 polish pass (graphics, HUD, animated raptor model).

| | Feature |
|:---:|---|
| ✅ | First-person movement, camera, jump |
| ✅ | Raptor AI — state machine, pack-alert via signals, NavigationAgent3D pathfinding |
| ✅ | Combat — player/raptor attacks, reusable `Health` component |
| ✅ | Knockout system (no death — brief loss of control, then recovery) |
| ✅ | Gather/craft loop — wood → spear, reusable `Inventory` component |
| ✅ | Dynamic day/night — sun, sky, fog, glow, shadows, all in sync |
| ✅ | Styled HUD — health bar, knockout overlay, wood counter slot |
| ✅ | Visible weapon with procedural swing animation |
| ✅ | Rigged, animated raptor model — custom-built in Blender |
| 🚧 | More raptor animations (idle, attack), base-building groundwork, more craftables |

---

## 🛠️ Tech Stack

<table>
<tr><td><b>Engine</b></td><td>Godot 4.7.1 stable</td></tr>
<tr><td><b>Language</b></td><td>GDScript</td></tr>
<tr><td><b>3D Models</b></td><td>Blender (custom raptor rig)</td></tr>
</table>

---

## 🚀 Getting Started

1. Install **Godot 4.7.1 stable** — Standard build (not .NET/Mono)
2. Clone this repo
3. Godot → **Import** (not "New Project") → select the cloned folder
4. Open and run `scenes/world/test_level.tscn` (<kbd>F6</kbd>)

> ⚠️ **Stick to Godot 4.7.1 stable** across the whole team — don't upgrade without a team discussion, since project files can behave unpredictably across version jumps.

---

## 🎮 Controls

| Key | Action |
|:---:|---|
| `W` `A` `S` `D` | Move |
| Mouse | Look around |
| `Space` | Jump |
| Left Click | Attack |
| `E` | Interact / Gather |
| `C` | Craft spear *(5 wood)* |

---

## 📁 Project Structure

```
dino-game/
├── assets/
│   ├── models/
│   │   ├── dinosaurs/     # raptor model + animations
│   │   ├── environment/   # trees, terrain assets
│   │   └── props/
│   ├── textures/
│   ├── audio/
│   └── fonts/
├── scenes/
│   ├── player/
│   ├── dinosaurs/         # raptor.tscn
│   ├── world/              # test_level.tscn, wood_resource.tscn
│   └── ui/                  # hud.tscn
├── scripts/
└── addons/
```

> Scenes are saved in **text format** so Git diffs/merges stay readable — please don't change this setting.
>
> **Gotcha:** instanced scenes (e.g. `WoodResource` inside `test_level.tscn`) hide their internal children by default. Right-click the instance → **Editable Children** to view/edit them.

---

## ✍️ Coding Conventions

- Tunable values go in `const` at the top of scripts — no inline magic numbers
- State machines use GDScript `enum` + `match` *(see `raptor.gd`)*
- Shared behavior is a reusable component node (`Health`, `Inventory`) — follow this pattern for anything new
- Cross-node references use `@export` typed slots + drag-and-drop in the Inspector, **not** hardcoded `get_node("/root/...")` paths
- Remove debug `print()` statements before committing
- Commit after each completed piece of work, not just at sprint end

---

## 🙏 Credits & Asset Licenses

| Asset | Source | License |
|---|---|---|
| Raptor model | Custom — modeled, shaded & rigged in Blender by the team | Original work |
| Ground texture (rocky terrain) | [Poly Haven](https://polyhaven.com) | CC0 |
| Tree models | [gltf-trees.donmccurdy.com](https://gltf-trees.donmccurdy.com), [florasynth.com](https://www.florasynth.com) | ⚠️ *confirm before public release* |

> Adding a new third-party asset? List it here with its source and license.

---

## 🔭 Out of Scope (for now)

Base building · Multiple dinosaur species · Procedural world generation · Multiplayer · Save/load · Hunger/stamina/thirst · Complex crafting trees

