  # frozen_string_literal: true

class UsersController < ApplicationController

  def update
    return render_errors(current_user.errors) unless
      current_user.update(user_params)

    render json: current_user
  end

  private

  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :phone, :email, :password)
  end
end
