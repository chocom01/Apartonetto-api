# frozen_string_literal: true

class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.tenant?
        user.sent_payments.where.not(status: 'draft')
      elsif user.provider?
        user.received_payments.where.not(
          status: %w[draft waiting_for_payment rejected]
        )
      end
    end
  end

  def show?
    !record.draft? && (record.payer == user ||
      (
        record.recipient == user && !record.waiting_for_payment? &&
        !record.rejected?
      ))
  end

  def pay?
    !record.draft? && record.payer == user &&
      !record.paid? && !record.money_reservation?
  end

  def reject?
    !record.draft? && record.payer == user && !record.paid? &&
      !record.overdue?
  end
end
