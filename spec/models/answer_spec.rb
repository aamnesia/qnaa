require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe '#set_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:best_answer) { create(:answer, question: question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    before { best_answer.set_best! }

    it 'return true if answer is the best' do
      best_answer.reload
      expect(best_answer).to be_best
    end

    it 'return false if answer is not the best' do
      expect(answer).to_not be_best
    end

    it "changes best answer" do
      answer.set_best!
      best_answer.reload
      answer.reload

      expect(answer).to be_best
      expect(best_answer).to_not be_best
    end
  end
end
