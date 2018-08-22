require 'rails_helper'

describe UserAuthorization do
  describe '.call' do
    context 'when header have token' do
      context 'when user matched to given token' do
        it 'returns user' do
          user = create(:user, token: 'ABCD')
          headers = { 'HTTP_API_TOKEN' => 'ABCD' }

          user_authorization = UserAuthorization.call(headers)

          expect(user_authorization.result).to eq(user)
        end
      end

      context 'when token not match to any user' do
        it 'returns nil and error with message' do
          create(:user, token: 'CDAB')
          headers = { 'HTTP_API_TOKEN' => 'ABCD' }

          user_authorization = UserAuthorization.call(headers)

          expect(user_authorization.result).to eq(nil)
          expect(user_authorization.errors).to include('Not Authorized')
        end
      end
    end

    context 'when header not have a token' do
      it 'returns nil and error with message' do
          headers = {  }

          user_authorization = UserAuthorization.call(headers)

          expect(user_authorization.result).to eq(nil)
          expect(user_authorization.errors).to include('Missing token')
      end
    end
  end
end
