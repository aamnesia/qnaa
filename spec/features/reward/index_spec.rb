require 'rails_helper'

feature 'User can see his rewards', %q{
    To see rewards
    As a user
    I would like to see each of them
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:rewards) { create_list(:reward, 3, question: question, user: user) }

  scenario 'User sees all his rewards for answers ' do
    sign_in(user)
    visit rewards_path

    rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
    end
  end
end
