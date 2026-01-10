import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    // Sync icon with current theme
    const currentTheme = document.documentElement.getAttribute("data-theme") || "light"
    this.updateIcon(currentTheme)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const currentTheme = document.documentElement.getAttribute("data-theme") || "light"
    const newTheme = currentTheme === "dark" ? "light" : "dark"
    
    document.documentElement.setAttribute("data-theme", newTheme)
    localStorage.setItem("theme", newTheme)
    
    this.updateIcon(newTheme)
  }

  updateIcon(theme) {
    if (!this.hasIconTarget) return
    
    const icon = this.iconTarget
    if (theme === "dark") {
      // Sun icon for dark mode (clicking will switch to light)
      icon.innerHTML = `
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="12" cy="12" r="5"/>
          <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>
        </svg>
      `
    } else {
      // Moon icon for light mode (clicking will switch to dark)
      icon.innerHTML = `
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
        </svg>
      `
    }
  }
}
