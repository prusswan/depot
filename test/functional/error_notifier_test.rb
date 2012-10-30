require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "occurred" do
    mail = ErrorNotifier.occurred('Hi')
    assert_equal "Pragmatic Store Error Occurred", mail.subject
    assert_equal mail.from, mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
