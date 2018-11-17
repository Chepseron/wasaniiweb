require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  test "test" do
    mail = AdminMailer.test
    assert_equal "Test", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
