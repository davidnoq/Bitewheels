// app/javascript/channels/notifications_channel.js
import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to NotificationsChannel")
  },

  disconnected() {
    console.log("Disconnected from NotificationsChannel")
  },

  received(data) {
    console.log("Received notification data:", data)
    if (data.new_message_count && data.event_application_id) {
      const applicationId = data.event_application_id
      const badge = document.querySelector(`#application-${applicationId} .badge-new-messages`)
      if (badge) {
        badge.textContent = data.new_message_count > 9 ? "9+" : data.new_message_count
        badge.style.display = data.new_message_count > 0 ? "inline-block" : "none"
      }
    }
  }
})
