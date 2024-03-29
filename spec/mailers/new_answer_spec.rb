require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "new_notification" do
    let(:user) { create(:user)}
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, question: question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { NewAnswerMailer.new_notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["unistudy.anna@gmail.com"])
    end

    it "renders answer body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
