class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    authorize @user
  end

  def edit
    @user = current_user
    authorize @user
  end

  def update
    @user = current_user
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  def purchase_credits
    amount = params[:amount].to_i
    if amount > 0
      ActiveRecord::Base.transaction do
        current_user.increment!(:credits, amount)
        CreditTransaction.create!(
          user: current_user,
          amount: amount,
          transaction_type: 'purchase',
          description: 'Purchased additional credits'
        )
      end
      redirect_to user_path(current_user), notice: "#{amount} credits added successfully."
    else
      redirect_to user_path(current_user), alert: "Invalid credit amount."
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to user_path(current_user), alert: "Failed to add credits: #{e.message}"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone_number, :country)
  end
end
