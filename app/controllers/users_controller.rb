# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[update]

  def create
    user = User.new(user_params_for_create)
    return render_errors(user.errors.full_messages) unless user.save

    token_json_hash(user)
    render json: UserBlueprint.render(user, view: :for_current_user)
  end

  def update
    unless current_user.update(user_params_for_update)
      return render_errors(current_user.errors.full_messages)
    end

    render json: UserBlueprint.render(current_user, view: :for_current_user)
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
