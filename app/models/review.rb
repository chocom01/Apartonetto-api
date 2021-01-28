# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewable, polymorphic: true

  validate :rights_to_live_review
  validates :rate, numericality: {
    only_integer: true, greater_than: 0, less_than: 6
  }
  validates :text, length: { in: 5..30 }

  private

  def rights_to_live_review
    case reviewable_type
    when 'Property'
      tenant_booked_property? ||
        errors.add(:reviewer, "tenant didn't book property")
    when 'User'
      tenant_booked_property_of_provider? ||
        errors.add(:reviewer, "tenant didn't book property in the provider")
    else
      errors.add(:reviewable_type, :invalid)
    end
  end

  def tenant_booked_property?
    Booking.where(tenant_id: reviewer_id, property_id: reviewable_id).exists?
  end

  def tenant_booked_property_of_provider?
    Booking.joins(:property)
           .where(tenant_id: reviewer_id,
                  properties: { provider_id: reviewable_id }).exists?
  end
end
