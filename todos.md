# Elixir UIkit - Todo List

## Critical (Blockers)

- [x] Fix package name inconsistency - align mix.exs, package.json, and README
- [x] Remove `System.unique_integer/1` from ID generation - use deterministic IDs or require user-provided IDs
- [x] Add `destroyed()` callbacks to all JS hooks to prevent memory leaks
- [x] Fix O(n²) algorithm in SortableLive demo

## Major

- [ ] Add tests for components and form components
- [x] Remove Tailwind/DaisyUI from dev app - use UIkit-only styling
- [ ] Fix type specifications in component attrs (`:any` → proper types)
- [ ] Add LICENSE file
- [ ] Add CHANGELOG.md

## Medium

- [ ] Split lib/components.ex into logical modules by category
- [ ] Fix redundant server push in Modal hook when programatically hidden
- [ ] Add ARIA attributes for accessibility
- [ ] Simplify attribute preparation functions using proper attr definitions

## Completed

- [x] Initial project review and assessment
- [x] Add form components (`Uikit.FormComponents`) with Phoenix form integration
- [x] Fix missing `default: nil` on `id` attr for `uk_icon` and `uk_spinner`
