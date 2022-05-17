require 'rails_helper'

feature 'User can give an answer', %q{
  In order to share my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer'do
      fill_in 'New answer', with: 'My answer'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
        expect(page).to have_content 'My answer'
      end
    end

    scenario 'creates answer with errors' do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates answer with attached files' do
      fill_in 'New answer', with: 'My answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'Multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'New answer', with: 'Test answer'

        click_on 'Add link'
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: 'https://google.com'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Create'

        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'Google', href: 'https://google.com'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'Google', href: 'https://google.com'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
