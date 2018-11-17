class TestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.test_mailer.test.subject
  #
  default :from => 'kelvinchege@gmail.com'
  def test
    @greeting = "Hi"

    mail to: "info@wasanii.com", subject: "Test user"
  end
end
