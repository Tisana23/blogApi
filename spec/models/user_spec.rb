require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it 'validate presence of required fields' do
      should validate_presence_of(:email)
      should validate_presence_of(:name)
      should validate_presence_of(:auth_token)
    end
    
    it 'validate realtions' do
      should have_many(:posts)  
    end

  end

  describe 'generate auth token' do
    let!(:user) {create(:user)}
    let!(:user_with_auth_token) {create(:user, auth_token: "token")}

    context 'user without auth_token' do
      it ' is generated auth_token' do
        expect(user.auth_token).to_not be_nil
      end
    end

    context 'user with auth_token' do
      it ' is preserved auth_token' do
        expect(user_with_auth_token.auth_token).to eq("token")
      end
    end

  end

end
