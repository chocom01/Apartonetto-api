class PropertyBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :price, :address
  association :provider, blueprint: UserBlueprint, view: :extended
  association :photos, blueprint: PhotoBlueprint
  view :normal do
    fields :description, :guests_capacity,
           :rooms_count, :minimum_days, :longitude, :latitude
  end
end
