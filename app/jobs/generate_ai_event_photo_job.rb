# app/jobs/generate_ai_event_photo_job.rb

class GenerateAiEventPhotoJob < ApplicationJob
    queue_as :default
  
    def perform(event_id)
      event = Event.find(event_id)
      AiImageGeneratorService.new(event).generate_and_attach_image
    end
  end
  