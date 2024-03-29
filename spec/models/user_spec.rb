require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#create_authorization!' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    it { expect(user.create_authorization!(auth)).to be_instance_of(Authorization) }
    it 'change authorizations count by 1' do
      expect{ (user.create_authorization!(auth)) }.to change(Authorization, :count).by(1)
    end

    it do
      expect(user.create_authorization!(auth))
        .to have_attributes(auth)
    end
  end

  describe '#subscribed?' do
    let(:user) { create(:user) }
    let(:unsubscribed_user) { create(:user) }
    let(:question) { create(:question) }

    it 'return false if user is unsubscribed' do
      expect(unsubscribed_user).not_to be_subscribed(question)
    end

    it 'return true if user is subscribed' do
      expect(user).not_to be_subscribed(question)
    end
  end
end
