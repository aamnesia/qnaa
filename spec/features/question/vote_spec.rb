require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to show that question is good
  As an authenticated user
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:voter) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User is not an author of question', js: true do

    background do
      sign_in voter
      visit question_path(question)
    end

    scenario 'votes up for question' do
      click_on '+'

      within '.rating' do
        expect(page).to have_content '1'
      end
    end

    scenario 'tries to vote up for question twice' do
      click_on '+'
      click_on '+'

      within '.rating' do
        expect(page).to have_content '1'
      end
    end

    scenario 'cancels his vote' do
      click_on '+'
      click_on 'Cancel vote'

      within '.rating' do
        expect(page).to have_content '0'
      end
    end

    scenario 'votes down for question' do
      click_on '-'

      within '.rating' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'tries to vote down for question twice' do
      click_on '-'
      click_on '-'

      within '.rating' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'can re-votes' do
      click_on "+"
      click_on 'Cancel vote'
      click_on '-'

      within '.rating' do
        expect(page).to have_content '-1'
      end
    end
  end

  describe 'User is author of question tries to', js: true do

    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'vote' do
      expect(page).to_not have_selector '.vote'
    end
  end

  describe 'Unauthorized user tries to' do

    background { visit question_path(question) }

    scenario 'vote' do
      expect(page).to_not have_selector '.vote'
    end
  end
end
