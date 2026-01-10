import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "input"]

  connect() {
    this.scrollToBottom()
    this.observeMessages()
  }

  observeMessages() {
    const observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    if (this.hasMessagesTarget) {
      observer.observe(this.messagesTarget, { childList: true, subtree: true })
    }
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }

  insertSuggestion(event) {
    const text = event.currentTarget.dataset.text
    if (this.hasInputTarget && text) {
      this.inputTarget.value = text
      this.inputTarget.focus()
    }
  }
}
