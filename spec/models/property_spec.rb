require 'rails_helper'

RSpec.describe Property, type: :model do
  describe '.min_price' do
    subject { described_class.min_price(property_price) }

    let(:property_price) { price }
    let(:price) { 100 }
    let(:property) { create(:property, price: price) }

    context 'when search by minimum price successful' do
      let(:property_price) { 99 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by equal price successful' do
      let(:property_price) { 100 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by minimum price failed' do
      let(:property_price) { 101 }
      it { expect(subject).to eq([]) }
    end
  end

  describe '.max_price' do
    subject { described_class.max_price(property_price) }

    let(:property_price) { price }
    let(:price) { 100 }
    let(:property) { create(:property, price: price) }

    context 'when search by maximum price successful' do
      let(:property_price) { 101 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by equal price successful' do
      let(:property_price) { 100 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by maximum price failed' do
      let(:property_price) { 99 }
      it { expect(subject).to eq([]) }
    end
  end

  describe '.min_capacity' do
    subject { described_class.min_capacity(property_guests_capacity) }

    let(:property_guests_capacity) { guests_capacity }
    let(:guests_capacity) { 8 }
    let(:property) { create(:property, guests_capacity: guests_capacity) }

    context 'when search by minimum guests capacity successful' do
      let(:property_guests_capacity) { 7 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by equal guests capacity successful' do
      let(:property_guests_capacity) { 8 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by minimum guests capacity failed' do
      let(:property_guests_capacity) { 9 }
      it { expect(subject).to eq([]) }
    end
  end

  describe '.max_capacity' do
    subject { described_class.max_capacity(property_guests_capacity) }

    let(:property_guests_capacity) { guests_capacity }
    let(:guests_capacity) { 8 }
    let(:property) { create(:property, guests_capacity: guests_capacity) }

    context 'when search by maximum guests capacity successful' do
      let(:property_guests_capacity) { 9 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by equal guests capacity successful' do
      let(:property_guests_capacity) { 8 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by maximum guests capacity failed' do
      let(:property_guests_capacity) { 7 }
      it { expect(subject).to eq([]) }
    end
  end

  describe '.min_rooms' do
    subject { described_class.min_rooms(property_rooms_count) }

    let(:property_rooms_count) { rooms_count }
    let(:rooms_count) { 4 }
    let(:property) { create(:property, rooms_count: rooms_count) }

    context 'when search by minimum guests capacity successful' do
      let(:property_rooms_count) { 3 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by equal guests capacity successful' do
      let(:property_rooms_count) { 4 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by minimum guests capacity failed' do
      let(:property_rooms_count) { 5 }
      it { expect(subject).to eq([]) }
    end
  end

  describe '.max_rooms' do
    subject { described_class.max_rooms(property_rooms_count) }

    let(:property_rooms_count) { rooms_count }
    let(:rooms_count) { 4 }
    let(:property) { create(:property, rooms_count: rooms_count) }

    context 'when search by maximum guests capacity successful' do
      let(:property_rooms_count) { 5 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by equal guests capacity successful' do
      let(:property_rooms_count) { 4 }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by maximum guests capacity failed' do
      let(:property_rooms_count) { 4 }
      it { expect(subject).to eq([]) }
    end
  end

  describe '.by_address' do
    subject { described_class.by_address(property_address) }

    let(:property_address) { address }
    let(:address) { 'Syhovska 8' }
    let(:property) { create(:property, address: address) }

    context 'when search by address successful' do
      let(:property_address) { 'sy' }
      it { expect(subject).to match_array(property) }
    end

    context 'when the search for the same address is successful' do
      let(:property_address) { 'syhovska 8' }
      it { expect(subject).to match_array(property) }
    end

    context 'when search by maximum guests capacity failed' do
      let(:property_address) { 'syhav' }
      it { expect(subject).to eq([]) }
    end
  end
end
