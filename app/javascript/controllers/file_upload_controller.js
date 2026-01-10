import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "fileName"]

  updateFileName() {
    if (this.hasInputTarget && this.hasFileNameTarget) {
      const file = this.inputTarget.files[0]
      if (file) {
        this.fileNameTarget.textContent = file.name
        this.fileNameTarget.classList.add("text-blue-600", "font-medium")
      }
    }
  }
}
