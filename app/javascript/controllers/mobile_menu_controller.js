import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.toggle("open")
    }
  }

  close() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.remove("open")
    }
  }
}
