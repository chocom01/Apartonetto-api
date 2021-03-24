class BookingBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    association :tenant, blueprint: UserBlueprint, view: :extended
    association :property, blueprint: PropertyBlueprint
    fields :status, :amount_for_period, :number_of_guests,
           :start_rent_at, :end_rent_at, :created_at
    association :chat, blueprint: ChatBlueprint
  end
end
