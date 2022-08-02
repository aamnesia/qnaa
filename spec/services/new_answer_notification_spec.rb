require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:users) { create_list(:user, 2) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question) }
  let(:first_subscription) { create(:subscription, question: question, user: users.first) }
  let(:another_subscription) { create(:subscription, question: question, user: users.last) }

  it 'sends new answer notification to subscribed users' do
    Subscription.find_each do |subscription|
      expect(NewAnswerMailer).to receive(:new_notification).with(subscription.user, answer).and_call_original
    end

    subject.send_email(answer)
  end

  it 'doesnt send new answer notification to unsubscribed users' do
    Services::NewAnswerNotification.new.send_email(answer)
    expect(NewAnswerMailer).to_not receive(:new_notification).with(user, answer).and_call_original
  end
end
