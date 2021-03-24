class MessageBlueprint < Blueprinter::Base
  identifier :id

  field :text
  association :user, blueprint: UserBlueprint, view: :full_name
end
