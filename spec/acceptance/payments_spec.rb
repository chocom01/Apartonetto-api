# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Payments' do
  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload:
    { sub: payment.payer.id }).token}"
  end

  let!(:payment) { create(:payment, status: 'waiting_for_payment') }
  let(:id) { payment.id }

  get '/payments' do
    example_request 'Getting all payments of current user' do
      payments_hash = JSON.parse(response_body, symbolize_names: true)
      expect(payments_hash[0][:id]).to eq(payment.id)
      expect(payments_hash[0][:booking_id]).to eq(payment.booking_id)
      expect(payments_hash[0][:payer_id]).to eq(payment.payer_id)
      expect(payments_hash[0][:recipient_id]).to eq(payment.recipient_id)
      expect(payments_hash[0][:service]).to eq(payment.service)
      expect(payments_hash[0][:info]).to eq(payment.info)
      expect(payments_hash[0][:amount]).to eq(payment.amount)
      expect(payments_hash[0][:amount]).to eq(payment.booking.amount_for_period)
      expect(status).to eq 200
    end
  end

  get '/payments/:id' do
    example_request 'Getting the payment of current user by id' do
      payment_hash = JSON.parse(response_body, symbolize_names: true)
      expect(payment_hash[:id]).to eq(payment.id)
      expect(payment_hash[:booking_id]).to eq(payment.booking_id)
      expect(payment_hash[:payer_id]).to eq(payment.payer_id)
      expect(payment_hash[:recipient_id]).to eq(payment.recipient_id)
      expect(payment_hash[:service]).to eq(payment.service)
      expect(payment_hash[:info]).to eq(payment.info)
      expect(payment_hash[:amount]).to eq(payment.amount)
      expect(payment_hash[:amount]).to eq(payment.booking.amount_for_period)
      expect(status).to eq 200
    end
  end

  patch '/payments/:id/pay' do
    example 'Updating status payment to paid by current user' do
      expect(payment.reload.status).to eq('waiting_for_payment')
      do_request
      expect(payment.reload.id).to eq(id)
      expect(payment.status).to eq('paid')
      expect(status).to eq 200
    end
  end

  patch '/payments/:id/reject' do
    example 'Updating status payment to rejected by current user' do
      expect(payment.reload.status).to eq('waiting_for_payment')
      do_request
      expect(payment.reload.id).to eq(id)
      expect(payment.status).to eq('rejected')
      expect(status).to eq 200
    end
  end
end
