# Dinosaur Survival Game

A long-term dinosaur survival game inspired by *7 Days to Die* — dinosaurs instead of zombies. You and your friends wake up as dinosaurs from a park have escaped into the world, and you have to craft, build, and survive. Built as an open-source portfolio project by a team of first-time game developers, using Godot.

---

## Status

**MVP complete**, currently in a Phase 2 polish pass (graphics, HUD, animated raptor model).

- First-person movement, camera, jump
- Raptor AI: state machine (idle/alert/chase/attack), pack-alert behavior via signals, NavigationAgent3D pathfinding around obstacles
- Combat: player attack (raycast), raptor attack, reusable `Health` component
- Knockout system (no death — lose all control briefly, then recover at reduced health)
- Gather/craft loop: wood → spear (reusable `Inventory` component)
- Dynamic day/night cycle: sun, sky, fog, glow, shadows all animated together
- Styled HUD: health bar, knockout screen overlay, wood counter slot
- Visible weapon with procedural swing animation
- Rigged, animated raptor model (custom-modeled in Blender)
- In progress: more raptor animations (idle, attack), base-building groundwork, additional craftables

---

## Tech Stack

- **Engine:** Godot 4.7.1 stable
- **Language:** GDScript
- **3D models:** Blender (for the custom raptor rig)

---

## Getting Started

**Important:** Stick to Godot 4.7.1 stable across the team — don't upgrade without discussing it first, since project files can behave unpredictably across version jumps.

---

## Controls

| Key | Action |
|---|---|
| **W / A / S / D** | Move |
| **Mouse** | Look around |
| **Space** | Jump |
| **Left Click** | Attack |
| **E** | Interact / Gather |
| **C** | Craft spear (requires 5 wood) |

---

## Project Structure

```text
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
│   ├── dinosaurs/        # raptor.tscn
│   ├── world/            # test_level.tscn, wood_resource.tscn
│   └── ui/               # hud.tscn
├── scripts/
└── addons/
text```


---
Scenes are saved in **text format** so Git diffs/merges stay readable — please don't change this setting.

**Note:** Instanced scenes (e.g. `WoodResource` inside `test_level.tscn`) hide their internal children by default in the Scene panel. Right-click the instance → **"Editable Children"** to view/edit them.

---

## Coding Conventions

- **Tunable values:** Place in `const` at the top of scripts, not inline magic numbers.
- **State machines:** Use GDScript `enum` + `match` (see `raptor.gd`).
- **Shared behavior:** Build as a reusable component node (`Health`, `Inventory`) — follow this pattern for anything new that multiple entities need.
- **Cross-node references:** Use `@export` typed slots + drag-and-drop in the Inspector, not hardcoded `get_node("/root/...")` paths.
- **Clean commits:** Remove debug `print()` statements before committing.
- **Commit frequency:** Commit after each completed piece of work, not just at the end of a sprint.

---

## Credits & Asset Licenses

- **Raptor model:** Custom-modeled, shaded, and rigged in Blender by the team.
- **Ground texture (rocky terrain):** [Poly Haven](https://polyhaven.com) — CC0
- **Tree models:** [gltf-trees.donmccurdy.com](https://gltf-trees.donmccurdy.com), [florasynth.com](https://www.florasynth.com) — *(confirm and fill in specific license terms here before public release)*

---

## Currently Out of Scope

Base building, multiple dinosaur species, procedural world generation, multiplayer, save/load, hunger/stamina/thirst systems, complex crafting trees.
---
