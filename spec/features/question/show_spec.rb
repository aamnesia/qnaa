require 'rails_helper'

feature 'User can inspect question and its answers', %q{
  In order to find solution
  As user
  I'd like to be able to see more info as question's body and answers
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, :with_attachment, user: author) }
  given!(:answer) { create(:answer, :with_attachment, question: question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: author) }

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

  describe "Unauthenticated user tries to delete" do
    background { visit question_path(question) }

    scenario "question's file" do
      within ".question_files > .file_#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario "answer's file" do
      within ".answer_files > .file_#{answer.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end
 end

 describe 'Author tries to delete', js: true do
   background do
     sign_in(author)

     visit question_path(question)
   end

   scenario "question's file" do
     within ".question_files > .file_#{question.files.first.id}" do
       page.accept_confirm do
         click_link 'Delete file'
       end

       expect(page).to_not have_content question.files
     end
   end

   scenario "answer's file" do
     within ".answer_files > .file_#{answer.files.first.id}" do
       page.accept_confirm do
         click_link 'Delete file'
       end
       expect(page).to_not have_content answer.files
     end
   end
 end

 describe "Not author tries to delete" do
   background do
     sign_in(user)

     visit question_path(question)
   end

   scenario "question's file" do
     within ".question_files > .file_#{question.files.first.id}" do
       expect(page).to_not have_link 'Delete file'
     end
   end

   scenario "answer's file" do
     within ".answer_files > .file_#{answer.files.first.id}" do
       expect(page).to_not have_link 'Delete file'
     end
   end
 end
end
