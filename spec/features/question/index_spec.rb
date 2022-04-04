require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to search for question needed
  As user
  I'd like to be able to see list of questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'User sees list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
