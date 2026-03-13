<!-- usage-rules-start -->
# Session Learnings: Elixir Uikit & Phoenix LiveView

## UIkit & LiveView Integration
- **Stable IDs**: CRITICAL. Any element that UIkit manipulates (e.g., `uk-subnav`, `uk-switcher`, `uk-sortable`) MUST have a stable, unique DOM ID. Without it, UIkit's JS and LiveView's `morphdom` will conflict, leading to duplicated or "ghost" nodes.
- **Modal Lifecycle**: UIkit modals move themselves to the end of the `<body>` by default (`container: true`). This breaks LiveView tracking. Always set `container: false` in the component defaults to keep the modal in its original DOM position.
- **Sticky & phx-update**: UIkit's `uk-sticky` wraps elements in dynamic `div`s. Use `phx-update="ignore"` on the parent container if LiveView updates are causing the sticky element to disappear or jump.

## JavaScript Hooks & Programmatic Control
- **Namespacing**: Prefix events sent from the library hooks (e.g., `uikit:reorder`, `uikit:modal_closed`) to avoid conflicts with application-specific events.
- **Bidirectional Sync**: Hooks should not only trigger UIkit actions (via `data-*` attributes) but also notify the server when the user interacts manually (e.g., closing a modal with Esc or clicking a switcher tab).
- **Attribute Mapping**: Remember that `data-on-close` in HTML maps to `this.el.dataset.onClose` in JS (camelCase).

## Component Patterns
- **Rest Attributes**: Use `attr :rest, :global, include: ~w(uk-toggle uk-icon ...)` to whitelist UIkit-specific attributes while maintaining strict HTML attribute validation.
- **Smart Wrappers**: Components like `uk_button` should detect navigation attributes (`href`, `navigate`) and automatically switch between `<button>` and `<.link>` to match Phoenix conventions.

## Packaging & Asset Pipeline
- **Peer Dependencies**: If your library JS depends on a package (like `uikit`), add it to `peerDependencies` in the library `package.json` and to `devDependencies` in the root `package.json` to ensure `esbuild` can resolve it during development.
- **Local Consumption**: Use `"my_lib": "file:../deps/my_lib"` in the consuming app's `package.json` for seamless local development of the asset pipeline.

---

<!-- usage-rules-header -->
# Usage Rules

**IMPORTANT**: Consult these usage rules early and often when working with the packages listed below.
Before attempting to use any of these packages or to discover if you should use them, review their
usage rules to understand the correct patterns, conventions, and best practices.
<!-- usage-rules-header-end -->

<!-- usage_rules-start -->
## usage_rules usage
_A dev tool for Elixir projects to gather LLM usage rules from dependencies_

[usage_rules usage rules](deps/usage_rules/usage-rules.md)
<!-- usage_rules-end -->
<!-- usage_rules:elixir-start -->
## usage_rules:elixir usage
[usage_rules:elixir usage rules](deps/usage_rules/usage-rules/elixir.md)
<!-- usage_rules:elixir-end -->
<!-- usage_rules:otp-start -->
## usage_rules:otp usage
[usage_rules:otp usage rules](deps/usage_rules/usage-rules/otp.md)
<!-- usage_rules:otp-end -->
<!-- igniter-start -->
## igniter usage
_A code generation and project patching framework_

[igniter usage rules](deps/igniter/usage-rules.md)
<!-- igniter-end -->
<!-- phoenix:ecto-start -->
## phoenix:ecto usage
[phoenix:ecto usage rules](deps/phoenix/usage-rules/ecto.md)
<!-- phoenix:ecto-end -->
<!-- phoenix:elixir-start -->
## phoenix:elixir usage
[phoenix:elixir usage rules](deps/phoenix/usage-rules/elixir.md)
<!-- phoenix:elixir-end -->
<!-- phoenix:html-start -->
## phoenix:html usage
[phoenix:html usage rules](deps/phoenix/usage-rules/html.md)
<!-- phoenix:html-end -->
<!-- phoenix:liveview-start -->
## phoenix:liveview usage
[phoenix:liveview usage rules](deps/phoenix/usage-rules/liveview.md)
<!-- phoenix:liveview-end -->
<!-- phoenix:phoenix-start -->
## phoenix:phoenix usage
[phoenix:phoenix usage rules](deps/phoenix/usage-rules/phoenix.md)
<!-- phoenix:phoenix-end -->
<!-- usage-rules-end -->
