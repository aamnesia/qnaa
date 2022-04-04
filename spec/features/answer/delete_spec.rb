require 'rails_helper'

feature 'User can delete answer', %q{
  In order to get rid of unneeded answer
  As an authenticated user
  I'd like to be able to delete the answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author deletes his answer', js: true do
    sign_in(author)

    visit question_path(question)

    expect(page).to have_content answer.body
    click_on 'Delete answer'
    expect(page).not_to have_content answer.body
  end

  scenario 'Not Author tries to delete answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).not_to have_link answer_path(answer)
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_link answer_path(answer)
  end
end
