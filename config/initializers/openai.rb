# config/initializers/openai.rb

require 'openai'

OPENAI_CLIENT = OpenAI::Client.new(access_token: Rails.application.credentials.openai[:api_key])
