class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.tenant? && user.tenant_chats
      user.provider? && user.provider_chats
    end
  end
end
