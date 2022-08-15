require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answers) { create_list(:answer, 4, question: question, user: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Set best'
  end

  describe 'Author', js: true  do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'set best answer' do
      within "#answer_#{answer.id}" do
        expect(page).not_to have_content 'The Best!'

        click_on 'Set best'

        expect(page).to have_content 'The Best!'
      end
    end

    scenario 'changes best answer' do
      within "div#answer_#{answers[-1].id}" do
        click_on 'Set best'
      end

      within "div#answer_#{answers[0].id}" do
        click_on 'Set best'
        expect(page).to_not have_content 'Set best'
      end

      answers[1, answers.size].each do |answer|
        within "div#answer_#{answer.id}" do
          expect(page).to have_content 'Set best'
        end
      end

      expect(page.all('.answers').first).to have_content answers[0].body
    end
  end

  scenario "User tries to edit other user's question", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Set best'
  end
end
