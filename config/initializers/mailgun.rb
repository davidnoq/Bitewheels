# config/initializers/mailgun.rb

require 'mailgun-ruby'

# Initialize the Mailgun client with credentials from Rails

   # Initialize the Mailgun client with credentials from Rails
MailgunClient = Mailgun::Client.new(Rails.application.credentials.dig(:mailgun, :mailgun_api_key))

   # Define your Mailgun sandbox domain from credentials
MAILGUN_DOMAIN = Rails.application.credentials.dig(:mailgun, :domain) 

# Define the default sender email
FROM_EMAIL = 'no-reply@sandboxf3fc29752b99411d8217b64e8dfbbdcb.mailgun.org'