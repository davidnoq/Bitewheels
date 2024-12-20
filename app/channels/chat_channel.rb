# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    @event_application = EventApplication.find(params[:event_application_id])
    stream_from "chat_channel_#{@event_application.id}"
    Rails.logger.info "User #{current_user.id} subscribed to chat_channel_#{@event_application.id}"
  end

  def unsubscribed
    Rails.logger.info "User #{current_user.id} unsubscribed from chat_channel_#{@event_application.id}"
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Rails.logger.info "speak action received with data: #{data.inspect}"
    message = @event_application.messages.create!(
      content: data["message"],
      user: current_user
    )
    ActionCable.server.broadcast("chat_channel_#{@event_application.id}", render_message(message))
    broadcast_new_message_count
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create message: #{e.message}"
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: "messages/message", locals: { message: message })
  end

  def broadcast_new_message_count
    # Identify users associated with the EventApplication
    users = [@event_application.event.user, @event_application.food_truck.user].compact.uniq

    users.each do |user|
      # Calculate new message count since the user's last read
      read_status = UserEventApplicationRead.find_by(user: user, event_application: @event_application)
      unread_count = read_status.unread_messages_since_last_email

      # Check if unread_count reaches or exceeds 3
      if unread_count >= 3
        # Send email notification
        MailgunMailer.new.send_unread_messages_email(
          to: user.email,
          event_application: @event_application,
          unread_count: unread_count
        )

        # Update last_email_sent_at to prevent immediate duplicate emails
        read_status.update(last_email_sent_at: Time.current)
      end
      last_read_at = read_status&.last_read_at || Time.at(0)
      new_count = @event_application.messages.where("created_at > ?", last_read_at).count
      new_count = new_count > 9 ? "9+" : new_count.to_s

      # Broadcast the new message count to the user's NotificationsChannel
      NotificationsChannel.broadcast_to(user, {
        event_application_id: @event_application.id,
        new_message_count: new_count
      })
    end
  end
end
