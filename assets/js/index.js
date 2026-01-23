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

export default {
  Sortable
};
