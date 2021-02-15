# frozen_string_literal: true

class PropertyPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.provider?
  end

  def update?
    record.provider == user
  end

  def destroy?
    record.provider == user
  end
end
