require 'rails_helper'

describe 'Authentication' do
  after :each do
    User.all.each do |user|
      user.destroy
    end
  end

  context 'User exists' do
    before :each do
      email = 'test@test.com'
      password = 'test-test'
      @user = User.create(email: email, password: password)
      @login_payload = payload_for_login({
        email: email,
        password: password
      })
    end

    describe 'POST /api/session' do
      it 'authenticates a user' do
        post session_path, params: @login_payload, headers: headers
        expect(response).to have_http_status(:created)
        token = JSON.parse(response.body)['jwt']
        expect(Knock::AuthToken.new(token: token).entity_for(User)).to eq @user
      end
    end
  end

  context 'User does not exist' do
    describe 'POST /api/session' do
      it 'is not found' do
        post session_path, params: payload_for_login, headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

def payload_for_login opts = {}
  payload = {
    auth: {
      email: "placeholder",
      password: "placeholder"
    }
  }

  payload[:auth].merge!(opts)
  payload.to_json
end

def headers
  { 'CONTENT_TYPE' => 'application/json' }
end
