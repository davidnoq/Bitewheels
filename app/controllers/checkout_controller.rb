# app/controllers/checkout_controller.rb

class CheckoutController < ApplicationController
    before_action :authenticate_user!
    before_action :set_credit_package, only: [:create]
    before_action :authorize_checkout, only: [:create]
  
    def create
      begin
        # Create a Stripe Checkout Session
        session = Stripe::Checkout::Session.create({
          payment_method_types: ['card'],
          line_items: [{
            price_data: {
              currency: 'usd',
              product_data: {
                name: @credit_package.name,
              },
              unit_amount: @credit_package.price_cents,
            },
            quantity: 1
          }],
          mode: 'payment',
          success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
          cancel_url: checkout_cancel_url,
          metadata: {
            user_id: current_user.id,
            credit_package_id: @credit_package.id
          }
        })
  
        # Redirect to the Stripe Checkout page
        redirect_to session.url, allow_other_host: true
      rescue Stripe::StripeError => e
        redirect_to root_path, alert: "Stripe Error: #{e.message}"
      rescue => e
        redirect_to root_path, alert: "An error occurred: #{e.message}"
      end
    end
  
    def success
      session_id = params[:session_id]
  
      if session_id.blank?
        redirect_to root_path, alert: "Session ID is missing."
        return
      end
  
      begin
        # Retrieve the Stripe Checkout Session
        session = Stripe::Checkout::Session.retrieve(session_id)
  
        # Retrieve metadata
        user_id = session.metadata.user_id
        credit_package_id = session.metadata.credit_package_id
  
        # Find the user and credit package
        user = User.find(user_id)
        credit_package = CreditPackage.find(credit_package_id)
  
        # Update user credits
        user.increment!(:credits, credit_package.credits)
  
        redirect_to user_path(user), notice: "Successfully purchased #{credit_package.credits} credits!"
      rescue Stripe::StripeError => e
        redirect_to root_path, alert: "Stripe Error: #{e.message}"
      rescue ActiveRecord::RecordNotFound => e
        redirect_to root_path, alert: "Record not found: #{e.message}"
      rescue => e
        redirect_to root_path, alert: "An error occurred: #{e.message}"
      end
    end
  
    def cancel
      redirect_to root_path, alert: "Payment was canceled."
    end
  
    private
  
    def set_credit_package
      @credit_package = CreditPackage.find(params[:credit_package_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Credit package not found."
    end
  
    def authorize_checkout
      authorize @credit_package, :purchase?
    end
  end
  