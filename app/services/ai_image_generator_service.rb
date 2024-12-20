# app/services/ai_image_generator_service.rb

require 'open-uri'

class AiImageGeneratorService
  def initialize(event)
    @event = event
    @client = OPENAI_CLIENT
  end

  def generate_and_attach_image
    prompt = generate_prompt
    image_url = fetch_ai_generated_image(prompt)
    return unless image_url

    attach_image(image_url)
  rescue StandardError => e
    Rails.logger.error "AI Image Generation Failed for Event #{@event.id}: #{e.message}"
    # Optionally, notify admins or take other actions
  end

  private

  def generate_prompt
    # Customize the prompt based on event attributes
    "Generate a photorealistic image of #{@event.address}. NO TEXT OR SYMBOLS ALLOWED. Show a clear daytime view with natural lighting and colors. Make it look like a real photograph with proper perspective."
  end

  def fetch_ai_generated_image(prompt)
    response = @client.images.generate(
      parameters: {
        prompt: prompt,
        n: 1,
        size: "1024x1024"  # Adjust size as needed
      }
    )
    response.dig("data", 0, "url")
  end

  def attach_image(image_url)
    downloaded_image = OpenURI.open_uri(image_url)  # Changed from URI.open to OpenURI.open_uri
    @event.photo.attach(
      io: downloaded_image,
      filename: "event_photo_#{@event.id}.png",
      content_type: "image/png"
    )
  end
end
