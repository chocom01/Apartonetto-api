# frozen_string_literal: true

class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token
  before_action :authenticate, only: :sign_in
  def sign_in
    render json: token_json_hash(entity)
  end

  def sign_up
    user = User.new(user_params)
    user.errors.add(:role, "can't create admin")
    if user.role == 'admin'
      render json: { errors: user.errors }, status: :unprocessable_entity
    elsif user.save
      render json: token_json_hash(user)
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def token_json_hash(user)
    {
      jwt: "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}",
      payload: user.as_json
    }
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :phone, :email, :password, :role
    )
  end
end
