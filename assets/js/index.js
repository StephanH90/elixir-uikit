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
    if (show) {
      this.modal.show();
    } else {
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
// UIkit attributes that cause SVG injection into the element
const UIKIT_SVG_ATTRS = ["uk-icon", "uk-close", "uk-spinner", "uk-totop", "uk-marker"];

export function onBeforeElUpdated(from, to) {
  // Preserve UIkit-injected SVGs across patches
  for (const attr of UIKIT_SVG_ATTRS) {
    if (from.hasAttribute(attr)) {
      if (from.getAttribute(attr) === to.getAttribute(attr)) {
        to.innerHTML = from.innerHTML;
      } else {
        // Attribute changed — re-render after patch
        requestAnimationFrame(() => UIkit.update(to));
      }
      break;
    }
  }

  // Preserve dropdown open state and positioning across patches
  if (from.classList.contains("uk-open") && from.hasAttribute("uk-dropdown")) {
    to.classList.add("uk-open");
    const style = from.getAttribute("style");
    if (style) to.setAttribute("style", style);
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
