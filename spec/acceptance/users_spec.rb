# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Users' do
  post '/create' do
    with_options scope: :user do
      parameter :first_name, 'User first_name'
      parameter :last_name, 'User last_name'
      parameter :phone, 'User phone'
      parameter :email, 'User email'
      parameter :password, 'User password'
      parameter :role, 'User role'
    end

    let(:first_name) { 'Andriy' }
    let(:last_name) { 'Sabotazh' }
    let(:phone) { '14345671912' }
    let(:email) { 'andriy@gmail.com' }
    let(:password) { 'qweasdzxc' }
    let(:role) { 'tenant' }

    example 'Creating user' do
      expect { do_request }.to change { User.count }.by(1)
      user = User.last
      expect(user.first_name).to eq(first_name)
      expect(user.last_name).to eq(last_name)
      expect(user.phone).to eq(phone)
      expect(user.email).to eq(email)
      expect(user.role).to eq(role)
      expect(status).to eq 200
    end
  end

  patch 'update/' do
    with_options scope: :user do
      parameter :first_name, 'User first_name'
      parameter :last_name, 'User last_name'
      parameter :phone, 'User phone'
      parameter :email, 'User email'
      parameter :password, 'User password'
    end

    let!(:user) { create(:user) }
    let(:id) { user.id }
    let(:first_name) { 'ASgsdgdsg' }
    let(:last_name) { 'Sabotsazh' }
    let(:phone) { '12745672912' }
    let(:email) { 'andriy@gmail.com' }
    let(:password) { 'qweasdsdzxc' }
    header 'Authorization', :auth_token
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: user.id })
                                .token}"
    end

    example_request 'Updating profile' do
      expect(user.reload.id).to eq(id)
      expect(user.first_name).to eq(first_name)
      expect(user.last_name).to eq(last_name)
      expect(user.phone).to eq(phone)
      expect(user.email).to eq(email)
      expect(status).to eq 200
    end
  end
end
