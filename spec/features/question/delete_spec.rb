require 'rails_helper'

feature 'User can delete question', %q{
  In order to get rid of unneeded question
  As an authenticated user
  I'd like to be able to delete the question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author deletes his question' do
    sign_in(author)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).not_to have_content question.body
  end

  scenario 'Not Author tries to delete question' do
    sign_in(user)

    visit question_path(question)

    expect(page).not_to have_link question_path(question)
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).not_to have_link question_path(question)
  end
end
