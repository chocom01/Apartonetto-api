class UserBlueprint < Blueprinter::Base
  identifier :id

  view :full_name do
    field :full_name do |user|
      "#{user.first_name} #{user.last_name}"
    end
  end

  view :extended do
    include_view :full_name
    field :phone
  end

  view :for_current_user do
    fields :first_name, :last_name, :phone, :email
  end
end
