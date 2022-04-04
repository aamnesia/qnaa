require 'rails_helper'

feature 'User can inspect question and its answers', %q{
  In order to find solution
  As user
  I'd like to be able to see more info as question's body and answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'User' do
    background { visit question_path(question) }

    scenario 'sees questions title and body' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'sees questions answers' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end

end
