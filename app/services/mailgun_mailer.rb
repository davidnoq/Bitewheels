# app/services/mailgun_mailer.rb

class MailgunMailer
    def initialize
      @mg_client = MailgunClient
      @domain = MAILGUN_DOMAIN
      @from_email = FROM_EMAIL
    end
  
    # Send approval email to food truck owner
    def send_approval_email(to:, event:)
      subject = "Your Application to #{event.name} Has Been Approved!"
      text = "Congratulations! Your application to participate in #{event.name} has been approved. We look forward to having you at the event."
  
      send_email(to: to, subject: subject, text: text)
    end
  
    # Send decline email to food truck owner
    def send_decline_email(to:, event:)
      subject = "Your Application to #{event.name} Has Been Declined"
      text = "We're sorry to inform you that your application to participate in #{event.name} has been declined. We appreciate your interest and encourage you to apply for future events."
  
      send_email(to: to, subject: subject, text: text)
    end
  
    # Notify event organizer about a new food truck application
    def notify_event_organizer(to:, food_truck:, event:)
      subject = "New Food Truck Application for #{event.name}"
      text = "Hello,\n\nA new food truck, #{food_truck.name}, has applied to participate in your event, #{event.name}.\n\nRegards,\nBiteWheels Team"
  
      send_email(to: to, subject: subject, text: text)
    end
  
    # Generic method to send emails
    def send_email(to:, subject:, text:, html: nil)
      message_params = {
        from: @from_email,
        to: to,
        subject: subject,
        text: text
      }
      message_params[:html] = html if html.present?
  
      @mg_client.send_message(@domain, message_params)
    end
  end