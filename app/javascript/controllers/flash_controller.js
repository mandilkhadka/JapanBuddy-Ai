import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    this.element.style.animation = 'slideOut 0.3s ease forwards'
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
