# frozen_string_literal: true

class Property < ApplicationRecord
  belongs_to :provider, class_name: 'User'
  has_many :reviews, as: :reviewable
  has_many :bookings

  validates :name, length: { in: 4..20 }
  validates_presence_of :description
  validates :price, numericality: { greater_than: 0, less_than: 10_000 }

  # scope :by_name, ->(name) { where('name like ?', "#{name}%") }
  # scope :by_user, ->(user_id) { where(user_id: user_id) }
  # scope :by_category, ->(category_id) { where(category_id: category_id) }
  # scope :by_options, lambda { |option_ids|
  #   joins(:options).where(options: { id: option_ids })
  #                  .having("count(option_id) = #{option_ids.size}")
  #                  .group(:id)
  # }
  # scope :price_min, ->(number) { where(arel_table[:price].gt(number)) }
  # scope :price_max, ->(number) { where(arel_table[:price].lt(number)) }
end
