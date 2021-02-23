require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe '#validate' do
    let(:tenant) { create(:user, role: 0) }
    let(:provider) { create(:user, role: 1) }
    let(:property) { create(:property, provider: provider, guests_capacity: 9) }
    let!(:booking_new) do
      create(
        :booking, property: property, number_of_guests: 5,
                  start_rent_at: '2020.04.01', end_rent_at: '2020.05.01'
      )
    end
    let(:booking) do
      build(
        :booking,
        tenant: tenant,
        property: property,
        start_rent_at: start_rent_at,
        end_rent_at: end_rent_at,
        number_of_guests: number_of_guests
      )
    end
    let(:start_rent_at) { '2020.01.01' }
    let(:end_rent_at) { '2020.01.03' }
    let(:number_of_guests) { 5 }

    context 'when all parameters valid' do
      let(:start_rent_at) { '2020.01.01' }
      let(:end_rent_at) { '2020.01.03' }
      let(:number_of_guests) { 7 }
      it 'is valid' do
        expect(booking).to be_valid
      end
    end

    context 'when number of guests more than guests capacity property' do
      let(:number_of_guests) { 12 }
      it 'is invalid' do
        expect(booking).not_to be_valid
        expect(booking.errors.keys).to include(:number_of_guests)
      end
    end

    context 'when number of guests is 0' do
      let(:number_of_guests) { 0 }
      it 'is invalid' do
        expect(booking).not_to be_valid
        expect(booking.errors.keys).to include(:number_of_guests)
      end
    end

    context 'end date is after start date' do
      let(:start_rent_at) { '2020.03.01' }
      let(:end_rent_at) { '2020.02.04' }
      it 'is invalid' do
        expect(booking).not_to be_valid
        expect(booking.errors.keys).to include(:end_rent_at)
      end
    end

    context 'finale date is in existing period' do
      let(:start_rent_at) { '2020.03.01' }
      let(:end_rent_at) { '2020.04.04' }
      it 'is invalid' do
        expect(booking).not_to be_valid
        expect(booking.errors.keys).to include(:booking)
      end
    end

    context 'the booking period is part of the existing period' do
      let(:start_rent_at) { '2020.04.04' }
      let(:end_rent_at) { '2020.04.10' }
      it 'is invalid' do
        expect(booking).not_to be_valid
        expect(booking.errors.keys).to include(:booking)
      end
    end

    context 'initial date is in existing period' do
      let(:start_rent_at) { '2020.04.04' }
      let(:end_rent_at) { '2020.06.04' }
      it 'is invalid' do
        expect(booking).not_to be_valid
        expect(booking.errors.keys).to include(:booking)
      end
    end

    context 'the booking period include existing period' do
      let(:start_rent_at) { '2020.03.04' }
      let(:end_rent_at) { '2020.06.04' }
      it 'is invalid' do
        expect(booking).not_to be_valid
        expect(booking.errors.keys).to include(:booking)
      end
    end
  end
end
