import { Controller } from "@hotwired/stimulus"
import createChatChannelSubscription from "channels/chat_channel"

export default class extends Controller {
  static values = { channelId: Number }

  connect() {
    console.log("ChatSubscription controller connected", this.channelIdValue)
    if (!this.channelIdValue) {
      console.error("No channel ID provided")
      return
    }
    
    this.subscription = createChatChannelSubscription(this.channelIdValue)
    console.log("Subscription created:", this.subscription)
  }

  disconnect() {
    console.log("ChatSubscription controller disconnecting")
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }
} 
