class PaymentBlueprint < Blueprinter::Base
  identifier :id

  association :payer, blueprint: UserBlueprint, view: :full_name
  association :recipient, blueprint: UserBlueprint, view: :full_name
  association :booking, blueprint: BookingBlueprint
  fields :status, :amount, :service, :info, :from_date, :to_date
end
