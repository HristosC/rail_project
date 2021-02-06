# spec/requests/authentication_spec.rb
require 'rails_helper'

RSpec.describe 'Logout' do
  # Authentication test suite
  describe 'POST /auth/logout' do
    # create test user
    let!(:user) { create(:user) }
    # set headers for authorization
    let(:headers) { valid_headers.except('Authorization') }
    # set test valid and invalid credentials
    let(:valid_token) do
      {
        token: (0...50).map { ('a'..'z').to_a[rand(26)] }.join

      }.to_json
    end
    let(:invalid_token) do
      {
        token: 0
      }.to_json
    end
    let(:valid_credentials) do
      { name: user.name,
        email: user.email,
        password: user.password
      }.to_json
    end
    let(:invalid_credentials) do
      {
       name: 'random',
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }.to_json
    end

    let(:valid_params) do
      {
       name: user.name,
        email: user.email,
        password: user.password
      }.to_json
    end
    # returns auth token when request is valid
    context 'When request is valid' do

      before { 

       # salt_record = Salt.where(user_id: user.id).take
        #p salt_record

        post '/signup',params: valid_params, headers: headers 
        salt_record =  Salt.where(user_id: user.id).take
        msg2 = post '/auth/logout', params: {Authorization: salt_record.token}.to_json, headers: headers

      }

      it 'returns status code 200' do

        expect(json['message']).not_to be_nil
        expect(json['message']).to match("You have succesfully logged out...")  
      end
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      before { 

        msg3 = post '/auth/logout', params: {Authorization: nil}.to_json, headers: headers 
        }
      it 'returns a failure message' do

        expect(json['message']).to match("Invalid token")
      end
    end
  end
end 