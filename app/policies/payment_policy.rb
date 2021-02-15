# frozen_string_literal: true

class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.tenant?
        user.sent_payments
      elsif user.provider?
        user.received_payments
      end
    end
  end

  def show?
    record.payer == user || record.recipient == user
  end

  def pay?
    record.payer == user && record.status != 'paid'
  end

  def reject?
    record.payer == user && record.status != 'paid'
  end
end
