require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'New title'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'New body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
