# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Knock::Authenticable

  private

  def render_errors(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
