import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
    this.handleEscape = this.handleEscape.bind(this)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    if (!this.hasMenuTarget) return

    const isCurrentlyOpen = this.menuTarget.classList.contains("open")

    // Close all other dropdowns first
    this.closeAllDropdowns()

    if (!isCurrentlyOpen) {
      this.open()
    }
  }

  open() {
    if (!this.hasMenuTarget) return

    this.menuTarget.classList.add("open")
    this.element.classList.add("dropdown-open")

    // Add listeners
    document.addEventListener("click", this.handleClickOutside, true)
    document.addEventListener("keydown", this.handleEscape)
  }

  close() {
    if (!this.hasMenuTarget) return

    this.menuTarget.classList.remove("open")
    this.element.classList.remove("dropdown-open")

    // Remove listeners
    document.removeEventListener("click", this.handleClickOutside, true)
    document.removeEventListener("keydown", this.handleEscape)
  }

  closeAllDropdowns() {
    document.querySelectorAll('.dropdown-menu.open, .user-dropdown-menu.open').forEach(menu => {
      menu.classList.remove("open")
    })
    document.querySelectorAll('.nav-dropdown.dropdown-open, .dropdown-open').forEach(dropdown => {
      dropdown.classList.remove("dropdown-open")
    })
  }

  handleClickOutside(event) {
    // If clicking inside the dropdown, don't close
    if (this.element.contains(event.target)) {
      return
    }

    this.close()
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  // Called when clicking a menu item
  select(event) {
    // Small delay to allow navigation to happen
    setTimeout(() => this.close(), 100)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside, true)
    document.removeEventListener("keydown", this.handleEscape)
  }
}
