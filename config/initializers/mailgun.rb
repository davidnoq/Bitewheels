# config/initializers/mailgun.rb

require 'mailgun-ruby'

# Initialize the Mailgun client with credentials from Rails

   # Initialize the Mailgun client with credentials from Rails
MailgunClient = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])

   # Define your Mailgun sandbox domain from credentials
MAILGUN_DOMAIN = ENV['MAILGUN_DOMAIN'] 

# Define the default sender email
FROM_EMAIL = 'no-reply@sandboxf3fc29752b99411d8217b64e8dfbbdcb.mailgun.org'