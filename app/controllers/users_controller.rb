  # frozen_string_literal: true

class UsersController < ApplicationController
  # before_action :authenticate_user
  # before_action :authenticate

  def update
    return render_errors(current_user.errors) unless
      current_user.update(user_params)

    render json: current_user
  end

  private

  # attr_reader :item

  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :phone, :email, :password)
  end

  # def load_item
  #   (@item = Item.find_by(id: params[:id])) || head(:not_found)
  # end

  # def current_user
  #   @current_user ||= User.first
  # end

  # def filtering_params
  #   params.permit(
  #     :by_city, :by_name, :by_category, :by_user, :price_min, :price_max,
  #     :by_options
    # )
end
