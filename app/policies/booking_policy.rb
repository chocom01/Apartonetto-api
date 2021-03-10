# frozen_string_literal: true

class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.tenant?
        user.bookings
      elsif user.provider?
        user.provider_bookings
      end
    end
  end

  def show?
    record.tenant == user || record.property.provider == user
  end

  def create?
    user.tenant? && !user.sent_payments.where(status: 'overdue').exists?
  end

  def cancel?
    record.tenant == user && record.waiting_for_confirm?
  end

  def confirm?
    record.property.provider == user && record.waiting_for_confirm? &&
      !record.payments.where(status: 'waiting_for_payment').exists?
  end

  def decline?
    record.property.provider == user && record.waiting_for_confirm?
  end
end
