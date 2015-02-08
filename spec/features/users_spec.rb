require 'rails_helper'

describe 'User' do
  before :each do
    FactoryGirl.create :user
  end

  describe 'who has signed up' do
    it 'can signin with right credentials' do
      sign_in(username: 'test_user', password: 'Passw0rd')
      expect(page).to have_content 'Welcome back, test_user!'
    end

    it 'is redirected back to signin form if wrong credentials given' do
      sign_in(username: 'test_user', password: 'wrong')
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch!'
    end

    it 'when signed up with good credentials, is added to the system' do
      visit signup_path
      fill_in('user_username', with: 'test_user2')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')

      expect { click_button('Create User') }.to change { User.count }.by(1)
    end
  end
end
