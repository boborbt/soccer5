require 'test_helper'

class CommunicationsMailerTest < ActionMailer::TestCase
  test "freeform_mail" do
    @expected.subject = 'CommunicationsMailer#freeform_mail'
    @expected.body    = read_fixture('freeform_mail')
    @expected.date    = Time.now

    assert_equal @expected.encoded, CommunicationsMailer.create_freeform_mail(@expected.date).encoded
  end

end
