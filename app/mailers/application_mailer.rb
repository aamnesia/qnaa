class ApplicationMailer < ActionMailer::Base
  default from: %{"qna" <unistudy.anna@gmail.com>}
  layout 'mailer'
end
