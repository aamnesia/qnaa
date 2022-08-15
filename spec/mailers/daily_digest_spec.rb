require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user)}
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:yesterday_questions) { create_list(:question, 2, :created_at_yesterday) }
    let(:earlier_questions) { create_list(:question, 2, :created_at_more_yesterday) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["unistudy.anna@gmail.com"])
    end

    it "renders yesterday questions" do
      yesterday_questions.each do |question|
       expect(mail.body.encoded).to match question.title
      end
    end

    it "doesnt render earlier questions" do
      earlier_questions.each do |question|
       expect(mail.body.encoded).to_not match question.title
      end
    end
  end
end
