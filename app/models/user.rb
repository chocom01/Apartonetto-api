# frozen_string_literal: true

class User < ApplicationRecord
  paginates_per 10
  enum role: %i[tenant provider admin]
  has_secure_password

  has_many :properties, foreign_key: :provider_id
  has_many :bookings, foreign_key: :tenant_id
  has_many :messages
  has_many :sent_payments, class_name: 'Payment', foreign_key: :payer_id
  has_many :received_payments, class_name: 'Payment', foreign_key: :recipient_id
  has_many :own_reviews, class_name: 'Review', foreign_key: :reviewer_id
  has_many :reviews, as: :reviewable

  validates :first_name, :last_name,
            length: { in: 3..11 }, if: :role_validate
  validates :password, length: { in: 5..15 }
  validates :phone, numericality: true, length: { in: 10..12 },
                    uniqueness: true, if: :role_validate
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                      uniqueness: true

  private

  def role_validate
    role == 'tenant' || role == 'provider'
  end
end
