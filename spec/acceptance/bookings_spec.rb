# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Bookings' do
  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: booking.tenant.id }).token}"
  end

  let!(:booking) { create(:booking) }
  let(:id) { booking.id }

  get '/bookings' do
    let!(:booking1) { create(:booking, tenant: booking.tenant) }
    let!(:payment) { create(:payment, booking: booking1, status: 'paid') }

    example_request 'Getting all bookings of current user' do
      bookings_hash = JSON.parse(response_body, symbolize_names: true)
      expect(bookings_hash[0][:id]).to eq(booking.id)
      expect(bookings_hash[0][:tenant_id]).to eq(booking.tenant_id)
      expect(bookings_hash[0][:property_id]).to eq(booking.property_id)
      expect(bookings_hash[0][:start_rent_at]).to eq(booking.start_rent_at.to_s)
      expect(bookings_hash[0][:end_rent_at]).to eq(booking.end_rent_at.to_s)
      expect(bookings_hash[0][:amount_for_period])
        .to eq(booking.amount_for_period)
      expect(bookings_hash[0][:number_of_guests])
        .to eq(booking.number_of_guests)
      expect(status).to eq 200
    end
  end

  get 'bookings/:id' do
    example_request 'Getting the booking of current user by id' do
      booking_hash = JSON.parse(response_body, symbolize_names: true)
      expect(booking_hash[:id]).to eq(booking.id)
      expect(booking_hash[:tenant_id]).to eq(booking.tenant_id)
      expect(booking_hash[:property_id]).to eq(booking.property_id)
      expect(booking_hash[:start_rent_at]).to eq(booking.start_rent_at.to_s)
      expect(booking_hash[:end_rent_at]).to eq(booking.end_rent_at.to_s)
      expect(booking_hash[:amount_for_period]).to eq(booking.amount_for_period)
      expect(booking_hash[:number_of_guests]).to eq(booking.number_of_guests)
      expect(status).to eq 200
    end
  end

  post '/bookings' do
    with_options scope: :booking do
      parameter :property_id, 'Booking property'
      parameter :start_rent_at, 'Booking start_rent_at'
      parameter :end_rent_at, 'Booking end_rent_at'
      parameter :number_of_guests, 'Number of guests booking'
    end

    let!(:tenant) { create(:user) }
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: tenant.id }).token}"
    end

    let(:property) { create(:property) }
    let(:property_id) { property.id }
    let(:start_rent_at) { '2020.04.01' }
    let(:end_rent_at) { '2020.04.02' }
    let(:number_of_guests) { 4 }

    example 'Creating booking, by current user' do
      expect { do_request }.to change { Booking.count }
        .by(1).and change { Chat.count }
        .by(1).and change { Payment.count }.by(1)
      booking = Booking.last
      expect(booking.id).to eq(booking.chat.booking_id)
      expect(booking.tenant).to eq(booking.chat.tenant)
      expect(booking.property.provider).to eq(booking.chat.provider)
      expect(booking.id).to eq(booking.payments.last.booking_id)
      expect(booking.tenant).to eq(booking.payments.last.payer)
      expect(booking.property.provider).to eq(booking.payments.last.recipient)
      expect(booking.tenant.id).to eq(tenant.id)
      expect(booking.property_id).to eq(property_id)
      expect(booking.start_rent_at).to eq(start_rent_at.to_date)
      expect(booking.end_rent_at).to eq(end_rent_at.to_date)
      expect(booking.amount_for_period).to eq(booking.payments.sum(:amount))
      expect(booking.number_of_guests).to eq(number_of_guests)
      expect(status).to eq 200
    end
  end

  patch '/bookings/:id/cancel' do
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload:
      { sub: booking.tenant.id }).token}"
    end

    example 'Updating status booking to canceled, by current user' do
      expect(booking.reload.status).to eq('payment_waiting')
      do_request
      expect(booking.reload.id).to eq(id)
      expect(booking.status).to eq('canceled')
      expect(status).to eq 200
    end
  end

  patch '/bookings/:id/confirm' do
    let!(:booking) { create(:booking, status: 'waiting_for_confirm') }
    let!(:payment) { create(:payment, status: 'money_reservation', booking: booking) }
    let(:id) { booking.id }

    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload:
      { sub: booking.property.provider.id }).token}"
    end

    example 'Updating status booking to confirmed, by current user' do
      expect(booking.reload.status).to eq('waiting_for_confirm')
      do_request
      expect(booking.reload.id).to eq(id)
      expect(booking.status).to eq('confirmed')
      expect(status).to eq 200
    end
  end

  patch '/bookings/:id/decline' do
    let!(:booking) { create(:booking, status: 'waiting_for_confirm') }
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload:
      { sub: booking.property.provider.id }).token}"
    end

    example 'Updating status booking to declined, by current user' do
      expect(booking.reload.status).to eq('waiting_for_confirm')
      do_request
      expect(booking.reload.id).to eq(id)
      expect(booking.status).to eq('declined')
      expect(status).to eq 200
    end
  end

  post '/bookings' do
    with_options scope: :booking do
      parameter :property_id, 'Booking property'
      parameter :start_rent_at, 'Booking start_rent_at'
      parameter :end_rent_at, 'Booking end_rent_at'
      parameter :number_of_guests, 'Number of guests booking'
    end

    let!(:tenant) { create(:user) }
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: tenant.id }).token}"
    end
    let(:property) { create(:property) }
    let(:property_id) { property.id }
    let(:number_of_guests) { 4 }

    shared_examples :count_payments do |count|
      example 'check count payments and sum amount' do
        expect { do_request }.to change { Booking.count }
          .by(1).and change { Payment.count }.by(count)
        booking = Booking.last
        expect(booking.payments.sum(:amount)).to eq(booking.amount_for_period)
        expect(status).to eq 200
      end
    end

    context 'Small period (less than 2 month)' do
      context 1 do
        let(:start_rent_at) { '2020.04.01' }
        let(:end_rent_at) { '2021.05.07' }
        it_behaves_like :count_payments, 13
      end

      context 2 do
        let(:start_rent_at) { '2020.04.02' }
        let(:end_rent_at) { '2021.04.27' }
        it_behaves_like :count_payments, 13
      end

      context 3 do
        let(:start_rent_at) { '2020.04.27' }
        let(:end_rent_at) { '2021.06.05' }
        it_behaves_like :count_payments, 13
      end
    end

    context 'Large period (more than 2 month)' do
      context 4 do
        let(:start_rent_at) { '2020.04.01' }
        let(:end_rent_at) { '2021.07.07' }
        it_behaves_like :count_payments, 15
      end

      context 5 do
        let(:start_rent_at) { '2020.04.30' }
        let(:end_rent_at) { '2021.07.15' }
        it_behaves_like :count_payments, 15
      end

      context 6 do
        let(:start_rent_at) { '2020.04.11' }
        let(:end_rent_at) { '2021.07.15' }
        it_behaves_like :count_payments, 16
      end

      context 7 do
        let(:start_rent_at) { '2020.04.25' }
        let(:end_rent_at) { '2021.09.15' }
        it_behaves_like :count_payments, 17
      end
    end

    context 'Year difference' do

      context 1 do
        let(:start_rent_at) { '2020.04.01' }
        let(:end_rent_at) { '2021.05.07' }
        it_behaves_like :count_payments, 13
      end

      context 2 do
        let(:start_rent_at) { '2020.04.02' }
        let(:end_rent_at) { '2021.04.27' }
        it_behaves_like :count_payments, 13
      end

      context 3 do
        let(:start_rent_at) { '2020.04.27' }
        let(:end_rent_at) { '2021.06.05' }
        it_behaves_like :count_payments, 13
      end

      context 4 do
        let(:start_rent_at) { '2020.04.01' }
        let(:end_rent_at) { '2021.07.07' }
        it_behaves_like :count_payments, 15
      end

      context 5 do
        let(:start_rent_at) { '2020.04.30' }
        let(:end_rent_at) { '2021.07.15' }
        it_behaves_like :count_payments, 15
      end

      context 6 do
        let(:start_rent_at) { '2020.04.11' }
        let(:end_rent_at) { '2021.07.15' }
        it_behaves_like :count_payments, 16
      end

      context 7 do
        let(:start_rent_at) { '2020.04.25' }
        let(:end_rent_at) { '2021.09.15' }
        it_behaves_like :count_payments, 17
      end

      context 8 do
        let(:start_rent_at) { '2020.12.27' }
        let(:end_rent_at) { '2021.01.05' }
        it_behaves_like :count_payments, 1
      end

      context 9 do
        let(:start_rent_at) { '2020.11.27' }
        let(:end_rent_at) { '2021.01.05' }
        it_behaves_like :count_payments, 1
      end
    end
  end
end
