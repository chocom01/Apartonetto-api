# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Knock::Authenticable
  include Pundit

  private

  def render_errors(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end

  rescue_from Pundit::NotAuthorizedError do |e|
    render_errors(e.message, :forbidden)
  end
end
