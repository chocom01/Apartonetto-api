class ChatBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :tenant_unread_messages_count, :provider_unread_messages_count
    association :tenant, blueprint: UserBlueprint, view: :full_name
    association :provider, blueprint: UserBlueprint, view: :full_name
    association :booking, blueprint: BookingBlueprint
  end
end
