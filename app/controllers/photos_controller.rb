# frozen_string_literal: true

class PhotosController < ApplicationController

  def index
    photos = PhotoBlueprint.render Photo.all
    render json: photos
  end

  def create
    photo = PhotoBlueprint.render Photo.create(photo_params)
    render json: photo
  end

  private

  def photo_params
    params.require(:photo).permit(:image, :property_id)
  end
end
