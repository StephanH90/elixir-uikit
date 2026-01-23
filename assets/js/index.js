import UIkit from "uikit";

const Sortable = {
  mounted() {
    UIkit.util.on(this.el, "moved", (e) => {
      const items = Array.from(this.el.children).map((child) => child.id);
      const eventName = this.el.dataset.event || "uikit:reorder";
      this.pushEvent(eventName, { items: items });
    });
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
      // We only call hide if UIkit thinks it's shown, 
      // otherwise it might trigger 'hidden' event loops.
      this.modal.hide();
    }
  }
};

export default {
  Sortable,
  Modal
};
