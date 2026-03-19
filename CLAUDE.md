# CLAUDE.md — elixir_uikit

## Project Overview

UIkit 3 component library for Phoenix LiveView. Ships UIkit's JS and SCSS directly via Hex — no Node.js or npm required. The Igniter-based `mix uikit.setup` task handles full installation into a Phoenix app.

## Repository Structure

```
/                   # Library (elixir_uikit hex package)
├── lib/
│   ├── components.ex        # Uikit.Components — all UI components
│   ├── form_components.ex   # Uikit.FormComponents — form inputs
│   └── mix/tasks/           # mix uikit.setup (Igniter installer)
├── assets/js/               # JS hooks (Sortable, Modal, Switcher)
├── priv/                    # Vendored UIkit CSS/JS/SCSS assets
├── usage-rules/             # LLM usage rules for this library
├── dev/                     # Dev workbench app (Phoenix LiveView)
│   ├── lib/dev_web/live/    # LiveView pages for testing components
│   └── mix.exs              # Separate Mix project (depends on parent via path)
└── AGENTS.md                # Session learnings & dependency usage-rules index
```

## Development Commands

All development happens inside the `dev/` directory:

```bash
cd dev
mix deps.get          # Fetch dependencies
mix phx.server        # Start dev server (localhost:4000)
mix test              # Run tests
mix format            # Format code
```

The dev app depends on the parent library via `{:elixir_uikit, path: ".."}`, so changes to `lib/` are picked up immediately.

## Architecture

- **Uikit.Components** (`lib/components.ex`) — All UI components (`uk_button`, `uk_card`, `uk_modal`, `uk_sortable`, etc.). Uses Phoenix.Component with slots and global attributes.
- **Uikit.FormComponents** (`lib/form_components.ex`) — Form-specific components (`uk_input`, `uk_checkbox`, `uk_radio`, etc.).
- **JS Hooks** (`assets/js/`) — Three LiveView hooks: Sortable (drag-and-drop), Modal (server-controlled show/hide), Switcher (tab sync). Events are prefixed with `uikit:` namespace.
- **Igniter Installer** (`lib/mix/tasks/`) — `mix uikit.setup` removes Tailwind, configures dart_sass, wires up JS hooks and component imports.
- **Vendored Assets** (`priv/`) — UIkit's JS bundle and SCSS source files, resolved via dart_sass load paths.

## Critical Integration Rules

These are hard-won lessons — violating them causes real bugs:

1. **Stable DOM IDs are mandatory.** Any element UIkit manipulates (`uk-subnav`, `uk-switcher`, `uk-sortable`) MUST have a stable, unique `id`. Without it, UIkit's JS and LiveView's morphdom will conflict, creating duplicated/ghost nodes.

2. **Modals must use `container: false`.** UIkit modals default to moving themselves to `<body>` end (`container: true`), which breaks LiveView DOM tracking. Always set `container: false`.

3. **No Tailwind.** The installer removes Tailwind. This library uses UIkit's own SCSS-based styling. Do not mix Tailwind classes with UIkit components.

4. **Use `phx-update="ignore"` with `uk-sticky`.** UIkit's sticky wraps elements in dynamic divs that confuse LiveView patching.

## Usage Rules

Detailed component API docs, CSS utilities, hook patterns, and architectural patterns live in `usage-rules/`:

- `usage-rules/components.md` — Component API reference
- `usage-rules/css-utilities.md` — UIkit CSS class reference
- `usage-rules/hooks.md` — JS hook usage and events
- `usage-rules/patterns.md` — Common integration patterns

**Consult these before building or modifying components.** Also see `AGENTS.md` for dependency-level usage rules (Phoenix, LiveView, Igniter, etc.).
