# frozen_string_literal: true

class PropertiesController < ApplicationController
  before_action :authenticate_user, only: %i[create update destroy]
  before_action :find_property, only: %i[show update destroy]

  # has_scope :price_period
  has_scope :min_price
  has_scope :max_price
  has_scope :min_capacity
  has_scope :max_capacity
  has_scope :min_rooms
  has_scope :max_rooms
  has_scope :by_address

  def index
    properties = apply_scopes(Property).all
    render json: properties.page(params[:page])
  end

  def show
    render json: @property
  end

  def create
    authorize property = Property.new(provider: current_user, **property_params)
    return render_errors(property.errors.full_messages) unless property.save

    render json: property
  end

  def update
    unless @property.update(property_params)
      return render_errors(@property.errors.full_messages)
    end

    render json: @property
  end

  def destroy
    @property.destroy
  end

  private

  def property_params
    params.require(:property).permit(:name, :location, :description, :price,
                                     :address, :guests_capacity,
                                     :rooms_count, :minimum_days)
  end

  def find_property
    authorize @property = Property.find(params[:id])
  end
end
