# frozen_string_literal: true

class PropertiesController < ApplicationController
  before_action :load_own_property, only: %i[update destroy]

  def index
    render json: Property.all.page(params[:page])
  end

  def show
    render json: Property.find(params[:id])
  end

  def create
    property = Property.new(provider: current_user, **property_params)
    return render_errors(property.errors) unless property.save

    render json: property
  end

  def update
    return render_errors(@property.errors) unless
    @property.update(property_params)

    render json: @property
  end

  def destroy
    @property.destroy
  end

  private

  def property_params
    params.require(:property).permit(:name, :location, :description, :price)
  end

  def load_own_property
    @property = Property.find_by(provider: current_user, id: params[:id]) ||
                head(:not_found)
  end
end
