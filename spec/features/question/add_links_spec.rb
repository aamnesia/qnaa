require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:url) { 'https://google.com' }
  given(:gist_url) {'https://gist.github.com/aamnesia/3c5a1bd3e61cd6513087082d802eb0ea'}

  describe 'User on question create adds ', js: true do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Add link'
    end

    scenario 'gist_url' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_content 'qna'
    end

    scenario 'plain url' do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_link 'My link', href: url
    end
  end
end
