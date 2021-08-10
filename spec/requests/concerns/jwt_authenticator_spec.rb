require 'rails_helper'

RSpec.describe 'Concerns::JwtAuthenticator', type: :controller do
  include JwtAuthenticator

  describe '#sign_me_in' do
    controller do
      include JwtAuthenticator

      def index
        sign_me_in(User.last)
        head :ok
      end
    end

    before do
      create(:user)
    end

    it 'sends authentication tokens via headers and cookies' do
      get :index

      expect(response.headers['X-Authentication-Token']).to be_truthy
      expect(cookies.encrypted[:authentication_token]).to be_truthy
      expect(cookies.encrypted[:authentication_token]).to eq response.headers['X-Authentication-Token']
    end

    it 'sends refresh_auth_token via headers and cookies' do
      get :index

      expect(response.headers['X-Refresh-Auth-Token']).to be_truthy
      expect(cookies.encrypted[:refresh_auth_token]).to be_truthy
      expect(cookies.encrypted[:refresh_auth_token]).to eq response.headers['X-Refresh-Auth-Token']
    end
  end

  describe '#authenticate_indentical!' do
    controller do
      include JwtAuthenticator
      before_action :authenticate_identical!

      def index
        head :ok
      end
    end

    let(:user) { create(:user) }

    context 'without authorization' do
      specify do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authorization' do
      before do
        sign_me_in(user)
      end

      specify do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with blacklisted authorization' do
      before do
        sign_me_in(user)
      end

      specify do
        allow(BlacklistedAuthToken).to receive(:exists?).and_return(true)
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired jwt token but right refresh auth token' do
      before do
        stub_const('JwtAuthenticator::TOKEN_EXPIRY_PERIOD', -10)
        sign_me_in(user)
      end

      specify do
        stub_const('JwtAuthenticator::TOKEN_EXPIRY_PERIOD', 5)
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#sign_me_out' do
    controller do
      include JwtAuthenticator

      def clear_cookie
        sign_me_out
        head :ok
      end
    end

    let(:user) { create(:user) }

    before do
      routes.draw { get 'clear_cookie' => 'anonymous#clear_cookie' }
      sign_me_in(user)
    end

    specify do
      get :clear_cookie

      expect(response.headers['X-Authentication-Token']).to be_nil
      expect(cookies.encrypted[:authentication_token]).to be_nil
    end
  end
end
