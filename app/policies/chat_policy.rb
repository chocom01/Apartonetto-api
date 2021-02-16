# frozen_string_literal: true

class ChatPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.tenant? && user.tenant_chats || user.provider? && user.provider_chats
    end
  end

  def show?
    record.tenant == user || record.provider == user
  end

  def messages?
    record.tenant == user || record.provider == user
  end
end
