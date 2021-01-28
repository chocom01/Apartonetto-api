# frozen_string_literal: true

class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token
  before_action :authenticate, only: :sign_in
  def sign_in
    render json: token_json_hash(entity)
    # render json: auth_params
  end

  def sign_up
    user = User.new(user_params)
    if user.save
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
      :first_name, :last_name, :age, :email, :password,
      :role, :description
    )
  end

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
