import consumer from "channels/consumer"
import { Turbo } from "@hotwired/turbo-rails"

function createChatChannel(channelId) {
  console.log("Creating chat channel for", channelId)
  const subscription = consumer.subscriptions.create({ 
    channel: "ChatChannel",
    id: channelId
  }, {
    connected() {
      console.log("Connected to channel", channelId)
    },
    
    disconnected() {
      console.log("Disconnected from channel", channelId)
    },

    received(data) {
      console.log("Received data:", data)
      if (data.turbo_stream) {
        console.log("Turbo stream content:", data.turbo_stream)
        
        // Create a template and set its innerHTML to the turbo stream content
        const template = document.createElement('template')
        template.innerHTML = data.turbo_stream
        
        // Process each turbo-stream element
        const streamElements = template.content.querySelectorAll('turbo-stream')
        console.log("Found stream elements:", streamElements.length)
        
        if (streamElements.length > 0) {
          // Use Turbo's API to process the stream
          Turbo.renderStreamMessage(template.content)
        } else {
          console.error("No turbo-stream elements found")
        }
      }
    },

    sendMessage(message) {
      console.log("Sending message in channel:", message)
      return this.perform("receive", { message: message })
    }
  })

  // For debugging
  window.chatSubscription = subscription
  return subscription
}

export default createChatChannel
