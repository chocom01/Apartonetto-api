# frozen_string_literal: true

class Booking < ApplicationRecord
  paginates_per 10
  enum status: %i[waiting_for_confirm confirmed declined canceled]

  belongs_to :tenant, class_name: 'User'
  belongs_to :property
  has_one :payment, dependent: :destroy
  has_one :chat, dependent: :destroy

  validate :end_date_is_after_start_date
  validate :true_role

  def property_price
    property.price * (end_rent_at - start_rent_at).to_i
  end

  private

  def true_role
    tenant.role == 'tenant' ||
      errors.add(:role, 'must be tenant')
  end

  def end_date_is_after_start_date
    end_rent_at < start_rent_at &&
      errors.add(:end_rent_at, 'cannot be before the start date')
    return if end_rent_at.blank? || start_rent_at.blank?
  end
end
