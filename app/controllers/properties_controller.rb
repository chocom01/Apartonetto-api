# frozen_string_literal: true

class PropertiesController < ApplicationController
  before_action :authenticate_user, only: %i[create update destroy]
  before_action :find_property, only: %i[show update destroy]

  has_scope :min_price, :max_price, :min_capacity, :max_capacity, :by_address,
            :min_rooms, :max_rooms
  has_scope :vacant_properties_in_dates,
            using: %i[initial_date finale_date], type: :hash

  def index
    properties = apply_scopes(Property.all)
    results = Kaminari.paginate_array(properties).page(params[:page]).per(10)
    render json: [results.total_count, results]
  end

  def show
    render json: @property
  end

  def create
    authorize property = Property.new(provider: current_user, **property_params)
    return render_errors(property.errors.full_messages) unless property.save

    property.photos.create(photo_params_create) if params[:photo]
    render json: property
  end

  def update
    result_array = []
    update_property = @property.update(property_params) if params[:property]
    unless update_property || update_property.nil?
      return render_errors(@property.errors.full_messages)
    end

    result_array += [@property]
    if params[:photo]
      new_photo = @property.photos.create(photo_params_create)
      result_array += [new_photo] unless new_photo.nil?
    elsif params[:photo_delete]
      delete_photo = Photo.delete(photo_params_delete[:id])
      result_array += [delete_photo]
    end
    render json: result_array
  end

  def destroy
    @property.destroy
  end

  private

  def property_params
    params.require(:property).permit(:name, :description, :price,
                                     :address, :guests_capacity,
                                     :rooms_count, :minimum_days)
  end

  def photo_params_create
    params.require(:photo).permit(:image)
  end

  def photo_params_delete
    params.require(:photo_delete).permit(:id)
  end

  def find_property
    authorize @property = Property.find(params[:id])
  end
end
