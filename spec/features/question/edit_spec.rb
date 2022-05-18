require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:url) { 'https://google.com' }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Author', js: true  do
    background do
      sign_in author
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'edits his question' do
      within ".question" do
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

    scenario 'edits his question with errors' do
      within ".question" do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits a question with attached files' do
      within ".question" do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'adds links while editing' do
      within ".question" do
        click_on 'Add link'
        fill_in 'Link name', with: 'New link'
        fill_in 'Url', with: url
        click_on 'Save'

        expect(page).to have_link 'New link', href: url
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
