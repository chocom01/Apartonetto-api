# frozen_string_literal: true

class User < ApplicationRecord
  paginates_per 10

  enum role: {
    tenant: 0,
    provider: 1
  }

  has_secure_password

  has_many :properties, foreign_key: :provider_id, dependent: :destroy
  has_many :bookings, foreign_key: :tenant_id, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :sent_payments, class_name: 'Payment', foreign_key: :payer_id
  has_many :received_payments, class_name: 'Payment', foreign_key: :recipient_id
  has_many :tenant_chats, class_name: 'Chat', foreign_key: :tenant_id
  has_many :provider_chats, class_name: 'Chat', foreign_key: :provider_id
  has_many :own_reviews, class_name: 'Review', foreign_key: :reviewer_id
  has_many :reviews, as: :reviewable
  has_many :provider_bookings, through: :properties, source: :bookings

  validates :first_name, :last_name, length: { in: 3..11 }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :phone, numericality: true, length: { in: 10..12 },
                    uniqueness: true
  validates :email,
            uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
