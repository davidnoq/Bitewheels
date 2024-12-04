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
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create message: #{e.message}"
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: "messages/message", locals: { message: message })
  end
end
