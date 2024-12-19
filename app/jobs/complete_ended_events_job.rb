# app/jobs/complete_ended_events_job.rb

class CompleteEndedEventsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Fetch events that need completion
    events_to_complete = Event.needs_completion
    Rails.logger.info "CompleteEndedEventsJob: Found #{events_to_complete.count} event(s) to complete."

    # Iterate through each event and mark as completed
    events_to_complete.find_each do |event|
      begin
        event.mark_as_completed!
        Rails.logger.info "CompleteEndedEventsJob: Event '#{event.name}' (ID: #{event.id}) marked as completed."
      rescue => e
        Rails.logger.error "CompleteEndedEventsJob: Failed to complete Event '#{event.name}' (ID: #{event.id}): #{e.message}"
      end
    end
  end
end
