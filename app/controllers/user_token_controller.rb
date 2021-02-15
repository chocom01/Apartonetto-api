# frozen_string_literal: true

class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def sign_in
    render json: token_json_hash(entity)
  end

  private

  def token_json_hash(user)
    {
      jwt: "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}",
      payload: user.as_json
    }
  end
end
