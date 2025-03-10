import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-form"
export default class extends Controller {
  static targets = [ "input" ]
  static values = { channelId: Number }

  connect() {
    this.inputTarget.focus()
  }

  submit(event) {
    event.preventDefault()
    const message = this.inputTarget.value.trim()
    if (message) {
      // Find the chat subscription controller and use its subscription
      const subscriptionController = this.application.getControllerForElementAndIdentifier(
        this.element.closest('[data-controller="chat-subscription"]'),
        'chat-subscription'
      )
      if (subscriptionController?.subscription) {
        console.log("Sending message through subscription:", message)
        subscriptionController.subscription.sendMessage(message)
        this.clear()
      } else {
        console.error("No chat subscription found")
      }
    }
  }

  clear() {
    this.inputTarget.value = ""
    this.inputTarget.focus()
  }
}
