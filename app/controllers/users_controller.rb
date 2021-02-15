# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[update]

  def create
    user = User.new(user_params_for_create)
    user.errors.add(:role, "can't create admin")
    if user.role == 'admin'
      render json: { errors: user.errors }, status: :unprocessable_entity
    elsif user.save
      render json: token_json_hash(user)
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def update
    return render_errors(current_user.errors) unless
      current_user.update(user_params_for_update)

    render json: current_user
  end

  private

  def token_json_hash(user)
    {
      jwt: "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}",
      payload: user.as_json
    }
  end

  def user_params_for_create
    params.require(:user).permit(
      :first_name, :last_name, :phone, :email, :password, :role
    )
  end

  def user_params_for_update
    params.require(:user)
          .permit(:first_name, :last_name, :phone, :email, :password)
  end
end
