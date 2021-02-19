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
      expect(properties_hash[0][:location]).to eq(property.location)
      expect(properties_hash[0][:description]).to eq(property.description)
      expect(status).to eq 200
    end
  end

  get 'properties/:id' do
    example_request 'Getting the property of current_user by id' do
      property_hash = JSON.parse(response_body, symbolize_names: true)
      expect(property_hash[:id]).to eq(property.id)
      expect(property_hash[:location]).to eq(property.location)
      expect(property_hash[:name]).to eq(property.name)
      expect(property_hash[:description]).to eq(property.description)
      expect(status).to eq 200
    end
  end

  post '/properties' do
    with_options scope: :property do
      parameter :name, 'Property name'
      parameter :location, 'Property location'
      parameter :price, 'Property price'
      parameter :description, 'Description property'
    end

    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: provider.id }).token}"
    end
    let(:provider) { create(:user, role: :provider) }

    let(:name) { 'Property' }
    let(:location) { 'Kyiv' }
    let(:price) { 110 }
    let(:description) { 'Cool property' }

    example 'Creating property by current_user' do
      expect { do_request }.to change { Property.count }.by(1)
      property = Property.last
      expect(property.name).to eq(name)
      expect(property.location).to eq(location)
      expect(property.price).to eq(price)
      expect(property.description).to eq(description)
      expect(status).to eq 200
    end
  end

  patch 'properties/:id' do
    with_options scope: :property do
      parameter :name, 'Property name'
      parameter :location, 'Property location'
      parameter :price, 'Property price'
      parameter :description, 'Description property'
    end

    let(:name) { 'another property' }
    let(:location) { 'Kambozha' }
    let(:price) { 121 }
    let(:description) { 'Great property' }

    example_request 'Updating property by provider' do
      expect(property.reload.id).to eq(id)
      expect(property.name).to eq(name)
      expect(property.location).to eq(location)
      expect(property.price).to eq(price)
      expect(property.description).to eq(description)
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
