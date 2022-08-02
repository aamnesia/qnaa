require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it_behaves_like 'votable'

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe '#subscribe_to_author!' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: author) }

    it 'author has subscription' do
      expect(author.subscriptions.last).to eq question.subscriptions.last
    end

    it 'not author has no subscription' do
      expect(user.subscriptions).to eq []
    end
  end
end
