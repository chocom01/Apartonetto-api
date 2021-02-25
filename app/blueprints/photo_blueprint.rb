class PhotoBlueprint < Blueprinter::Base
  identifier :id

  field :image_url
  field :property_id, name: :property
end
