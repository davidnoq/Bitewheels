// app/javascript/channels/chat_channel.js
import consumer from "./consumer"

console.log("chat_channel.js is loaded")

document.addEventListener("turbo:load", () => {
  const eventApplicationId = window.eventApplicationId

  if (eventApplicationId) {
    console.log(`Attempting to subscribe to ChatChannel with event_application_id: ${eventApplicationId}`)

    if (consumer) {
      const chatSubscription = consumer.subscriptions.create(
        { channel: "ChatChannel", event_application_id: eventApplicationId },
        {
          connected() {
            console.log("Connected to ChatChannel")
          },

          disconnected() {
            console.log("Disconnected from ChatChannel")
          },

          received(data) {
            console.log("Received data:", data)
            const messagesContainer = document.getElementById("messages")
            if (messagesContainer) {
              messagesContainer.insertAdjacentHTML("beforeend", data)
              messagesContainer.scrollTop = messagesContainer.scrollHeight // Auto-scroll to the latest message
            }
          },

          speak(message) {
            console.log("Sending message:", message)
            this.perform("speak", { message: message })
          }
        }
      )

      // Handle form submission
      const form = document.getElementById("chat-form")
      const input = document.getElementById("message-input")

      if (form && input) {
        form.addEventListener("submit", (event) => {
          event.preventDefault()
          const message = input.value.trim()
          if (message !== "") {
            console.log("Form submitted with message:", message)
            chatSubscription.speak(message)
            input.value = ""
          }
        })
      } else {
        console.error("Chat form or input not found in the DOM.")
      }
    } else {
      console.error("ActionCable consumer is not defined. Ensure that channels/consumer.js is correctly loaded.")
    }
  } else {
    console.error("eventApplicationId is not defined. Ensure it's set in the view.")
  }
})
