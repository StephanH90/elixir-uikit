import UIkit from "uikit";

const Sortable = {
  mounted() {
    this.sortable = UIkit.sortable(this.el);

    UIkit.util.on(this.el, "moved", (e) => {
      const items = Array.from(this.el.children).map((child) => {
        if (!child.id) {
          console.warn(
            `[elixir_uikit] Sortable item is missing an ID. Reordering will fail to sync correctly with LiveView.`,
            child
          );
        }
        return child.id;
      });
      const eventName = this.el.dataset.event || "uikit:reorder";
      this.pushEvent(eventName, { items: items });
    });
  },
  destroyed() {
    if (this.sortable) {
      this.sortable.$destroy();
    }
  }
};

const Modal = {
  mounted() {
    this.modal = UIkit.modal(this.el);
    
    // Notify server when modal is hidden (e.g. clicking background or Esc)
    UIkit.util.on(this.el, "hidden", () => {
      if (this.el.dataset.show === "true") {
        const eventName = this.el.dataset.onClose || "uikit:modal_closed";
        this.pushEvent(eventName, { id: this.el.id });
      }
    });

    this.handleAttr();
  },
  updated() {
    this.handleAttr();
  },
  handleAttr() {
    const show = this.el.dataset.show === "true";
    const isOpen = this.el.classList.contains("uk-open");
    if (show && !isOpen) {
      this.modal.show();
    } else if (!show && isOpen) {
      this.modal.hide();
    }
  },
  destroyed() {
    if (this.modal) {
      this.modal.$destroy();
    }
  }
};

// DOM callback for LiveView's liveSocket `dom` option.
// Runs before morphdom patches each element, letting us copy UIkit's
// runtime state from the current DOM (from) into the incoming DOM (to)
// so morphdom never strips it.
//
// Usage in app.js:
//   import UikitHooks, { onBeforeElUpdated } from "elixir_uikit"
//   let liveSocket = new LiveSocket("/live", Socket, {
//     hooks: UikitHooks,
//     dom: { onBeforeElUpdated }
//   })

// When UIkit initialises one of these components, it adds classes to the
// element. A `<div uk-dropdown>` becomes `<div uk-dropdown class="uk-dropdown
// uk-drop">`, and those classes are what hide it and position it.
//
// The server never renders them, so a patch takes them away again. The element
// itself stays, so UIkit does not run a second time and cannot put them back.
// The dropdown is then stuck open, sitting in the normal page flow.
const UIKIT_CLASS_ATTRS = ["uk-dropdown", "uk-drop", "uk-modal", "uk-offcanvas"];

// These components render an SVG into the element instead.
const UIKIT_SVG_ATTRS = [
  "uk-icon",
  "uk-drop-parent-icon",
  "uk-nav-parent-icon",
  "uk-navbar-parent-icon",
  "uk-navbar-toggle-icon",
  "uk-overlay-icon",
  "uk-pagination-next",
  "uk-pagination-previous",
  "uk-search-icon",
  "uk-slidenav-next",
  "uk-slidenav-previous",
  "uk-close",
  "uk-spinner",
  "uk-totop",
  "uk-marker",
];

export function onBeforeElUpdated(from, to) {
  // Preserve UIkit-injected SVGs across patches
  for (const attr of UIKIT_SVG_ATTRS) {
    if (from.hasAttribute(attr)) {
      if (from.getAttribute(attr) === to.getAttribute(attr)) {
        to.innerHTML = from.innerHTML;
        // UIkit also adds classes to the element itself (e.g. `uk-icon`).
        // Copy them over so morphdom does not strip the icon styling.
        from.classList.forEach((cls) => to.classList.add(cls));
      } else {
        // Attribute changed — re-render after patch. Update `from`: morphdom
        // keeps `from` in the DOM and discards `to`.
        requestAnimationFrame(() => UIkit.update(from));
      }
      break;
    }
  }

  // Carry over the classes UIkit added, plus the position and visibility it
  // manages. `uk-open` comes along with the rest, so an open dropdown stays
  // open.
  //
  // Only classes starting with `uk-` are copied, and only on the elements
  // listed above. A class the template itself removed still goes away.
  if (UIKIT_CLASS_ATTRS.some((attr) => from.hasAttribute(attr))) {
    from.classList.forEach((cls) => {
      if (cls.startsWith("uk-")) to.classList.add(cls);
    });

    const style = from.getAttribute("style");
    if (style) to.setAttribute("style", style);

    if (from.hasAttribute("hidden")) to.setAttribute("hidden", "");
  }

  // An open modal also needs its aria attributes. UIkit sets them when the
  // modal opens, so a patch takes them away and the Modal hook runs show() or
  // hide() again, making the modal flash or vanish. Classes and style are
  // already handled above.
  if (from.classList.contains("uk-open") && from.hasAttribute("uk-modal")) {
    for (const attr of ["aria-hidden", "aria-modal", "tabindex"]) {
      const value = from.getAttribute(attr);
      if (value !== null) to.setAttribute(attr, value);
    }
  }
}

const Switcher = {
  mounted() {
    this.switcher = UIkit.switcher(this.el);
    
    // Check for stable IDs on children in development
    Array.from(this.el.children).forEach((child, index) => {
      if (!child.id) {
        console.warn(
          `[elixir_uikit] Switcher toggle (item ${index}) is missing a stable ID. This will cause DOM patching issues in LiveView.`,
          child
        );
      }
    });

    // Notify server when switcher changes (e.g. user clicks a tab)
    UIkit.util.on(this.el, "show", (e) => {
      const toggles = Array.from(this.el.children);
      const index = toggles.indexOf(e.target);
      const active = parseInt(this.el.dataset.active);
      
      if (index !== -1 && index !== active) {
        const eventName = this.el.dataset.onChange || "uikit:switcher_changed";
        this.pushEvent(eventName, { id: this.el.id, index: index });
      }
    });

    this.handleAttr();
  },
  updated() {
    this.handleAttr();
  },
  handleAttr() {
    if (this.el.dataset.active !== undefined) {
      const index = parseInt(this.el.dataset.active);
      if (this.switcher && this.switcher.index !== index) {
        this.switcher.show(index);
      }
    }
  },
  destroyed() {
    if (this.switcher) {
      this.switcher.$destroy();
    }
  }
};

export default {
  Sortable,
  Modal,
  Switcher
};
