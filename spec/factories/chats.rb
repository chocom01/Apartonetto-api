FactoryBot.define do
  factory :chat do
    booking { "MyString" }
    tenant_unread_messages_count { 1 }
    provider_unread_messages_count { 1 }
  end
end
