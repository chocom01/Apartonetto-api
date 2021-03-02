# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Properties' do
  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload:
    { sub: property.provider.id }).token}"
  end

  let!(:property) { create(:property) }
  let(:id) { property.id }

  get '/properties' do
    example_request 'Getting all properties of current_user' do
      properties_hash = JSON.parse(response_body, symbolize_names: true)
      expect(properties_hash[0][:id]).to eq(property.id)
      expect(properties_hash[0][:name]).to eq(property.name)
      expect(properties_hash[0][:price]).to eq(property.price)
      expect(properties_hash[0][:address]).to eq(property.address)
      expect(properties_hash[0][:location]).to eq(property.location)
      expect(properties_hash[0][:description]).to eq(property.description)
      expect(properties_hash[0][:rooms_count]).to eq(property.rooms_count)
      expect(properties_hash[0][:guests_capacity])
        .to eq(property.guests_capacity)
      expect(status).to eq 200
    end
  end

  get 'properties/:id' do
    example_request 'Getting the property of current_user by id' do
      property_hash = JSON.parse(response_body, symbolize_names: true)
      expect(property_hash[:id]).to eq(property.id)
      expect(property_hash[:name]).to eq(property.name)
      expect(property_hash[:price]).to eq(property.price)
      expect(property_hash[:address]).to eq(property.address)
      expect(property_hash[:location]).to eq(property.location)
      expect(property_hash[:description]).to eq(property.description)
      expect(property_hash[:rooms_count]).to eq(property.rooms_count)
      expect(property_hash[:guests_capacity]).to eq(property.guests_capacity)
      expect(status).to eq 200
    end
  end

  post '/properties' do
    with_options scope: :property do
      parameter :name, 'Property name'
      parameter :location, 'Property location'
      parameter :price, 'Property price'
      parameter :address, 'Property address'
      parameter :description, 'Description property'
      parameter :rooms_count, 'Property rooms count'
      parameter :guests_capacity, 'Guests capacity property'
      parameter :minimum_days, 'Minimum days for book property'
    end

    let(:provider) { create(:user, role: :provider) }
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: provider.id }).token}"
    end

    let(:name) { 'Property' }
    let(:location) { 'Kyiv' }
    let(:price) { 1110 }
    let(:address) { 'Syhivska 8' }
    let(:description) { 'Cool property' }
    let(:rooms_count) { 4 }
    let(:guests_capacity) { 4 }
    let(:minimum_days) { 1 }

    example 'Creating property by current_user' do
      expect { do_request }.to change { Property.count }.by(1)
      property = Property.last
      expect(property.name).to eq(name)
      expect(property.location).to eq(location)
      expect(property.price).to eq(price)
      expect(property.address).to eq(address)
      expect(property.description).to eq(description)
      expect(property.rooms_count).to eq(rooms_count)
      expect(property.guests_capacity).to eq(guests_capacity)
      expect(property.minimum_days).to eq(minimum_days)
      expect(status).to eq 200
    end
  end

  patch 'properties/:id' do
    with_options scope: :property do
      parameter :name, 'Property name'
      parameter :location, 'Property location'
      parameter :price, 'Property price'
      parameter :address, 'Property address'
      parameter :description, 'Description property'
      parameter :rooms_count, 'Property rooms count'
      parameter :guests_capacity, 'Guests capacity property'
      parameter :minimum_days, 'Minimum days for book property'
    end

    let(:name) { 'another property' }
    let(:location) { 'Kambozha' }
    let(:price) { 121 }
    let(:address) { 'Syhivska 4' }
    let(:description) { 'Great property' }
    let(:rooms_count) { 4 }
    let(:guests_capacity) { 5 }
    let(:minimum_days) { 1 }

    example_request 'Updating property by provider' do
      expect(property.reload.id).to eq(id)
      expect(property.name).to eq(name)
      expect(property.location).to eq(location)
      expect(property.price).to eq(price)
      expect(property.address).to eq(address)
      expect(property.description).to eq(description)
      expect(property.rooms_count).to eq(rooms_count)
      expect(property.guests_capacity).to eq(guests_capacity)
      expect(property.minimum_days).to eq(minimum_days)
      expect(status).to eq 200
    end
  end

  delete '/properties/:id' do
    example 'Deleting property by provider' do
      expect { do_request }.to change { Property.count }.by(-1)
      expect(status).to eq 204
    end
  end
end
