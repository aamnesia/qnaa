require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user) { create(:user) }

    it 'return false if user is not author' do
      question = create(:question)

      expect(user).not_to be_author(question)
    end

    it 'return true if user is author' do
      question = create(:question, user: user)

      expect(user).to be_author(question)
    end
  end
end
