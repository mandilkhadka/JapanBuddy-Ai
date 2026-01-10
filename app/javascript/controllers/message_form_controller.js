import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.loadingIndicator = document.getElementById("loading-indicator")
  }

  submit(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.requestSubmit()
    }
  }

  showLoading() {
    if (this.loadingIndicator) {
      this.loadingIndicator.classList.remove("hidden")
    }
    if (this.hasInputTarget) {
      this.inputTarget.disabled = true
    }
  }

  hideLoading() {
    if (this.loadingIndicator) {
      this.loadingIndicator.classList.add("hidden")
    }
    if (this.hasInputTarget) {
      this.inputTarget.disabled = false
      this.inputTarget.value = ""
      this.inputTarget.focus()
    }
  }
}
