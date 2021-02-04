# frozen_string_literal: true

class PropertiesController < ApplicationController
  before_action :load_property, only: %i[update destroy]
  # before_action :authenticate_user, only: %i[create]

  def index
    properties = Property.all
    render json: properties.page(params[:page])
  end

  def show
    property = Property.find_by(id: params[:id])
    return head(:not_found) unless property

    render json: property
  end

  def create
    property = Property.new(provider: current_user, **property_params)
    return render_errors(property.errors) unless property.save

    render json: property
  end

  def update
    return render_errors(property.errors) unless property.update(property_params)

    render json: property
  end

  def destroy
    property.destroy
  end

  private

  attr_reader :property

  def property_params
    params.require(:property).permit(:name, :location, :description, :price)
  end

  def load_property
    @property = Property.find_by(provider: current_user, id: params[:id]) || head(:not_found)
  end

  # def filtering_params
  #   params.permit(
  #     :by_city, :by_name, :by_category, :by_user, :price_min, :price_max,
  #     :by_options
  #   )
  # end
end
