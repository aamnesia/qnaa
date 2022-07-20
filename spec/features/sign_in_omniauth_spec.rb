require 'rails_helper'

feature 'Authorization using oauth', %q{
  In order to make registration easier
  As user
  I want to be able to sign up with my social media accounts
} do

  background { visit new_user_session_path }

  describe 'Sign in with Github' do
    scenario 'using email' do
      mock_auth_hash(:github, 'email@email.com')
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end

    scenario "using email confirmation" do
      mock_auth_hash(:github, email: nil)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Confirm Email'
      fill_in 'Email', with: 'email@email.com'
      click_on 'Confirm'

      open_email 'email@email.com'
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario 'using email' do
      mock_auth_hash(:vkontakte, 'email@email.com')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from VK account.'
    end

    scenario "using email confirmation" do
      mock_auth_hash(:vkontakte, email: nil)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Confirm Email'
      fill_in 'Email', with: 'email@email.com'
      click_on 'Confirm'

      open_email 'email@email.com'
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'using invalid email' do
      mock_auth_hash(:vkontakte, email: nil)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Confirm Email'
      fill_in 'Email', with: 'invalid email'
      click_on 'Confirm'

      expect(page).to have_content 'Confirm Email'
      expect(page).to have_content 'Confirm'
    end
  end
end
