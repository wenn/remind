require "minitest/autorun"
require "time"

require "helper"
require "remind_note"


class RemindNotesTest < Minitest::Test

  class MockNotes < RemindNotes
    def now
      return Time.parse("2015-01-01 10am")
    end
  end

  def setup
    @due_note = RemindNote.new(
      action: "add",
      time_phrase: "on monday",
      time_marker: "on",
      title: "hello",
      body: "world..",
      time: "2015-01-01 9:45am",
    )

    @late_note = RemindNote.new(
      action: "add",
      time_phrase: "on monday",
      time_marker: "on",
      title: "goodbye",
      body: "world..",
      time: "2015-01-01 12pm",
    )
  end

  def test_return_all_notes
    TestHelper.fs do
      @due_note.save()
      @late_note.save()

      def TextAlert.call_service
      end

      RemindAlert.send_all()

      assert @due_note.sent, "Due note should have been sent"
      assert @late_note.sent, "Late note should not have been sent"
    end
  end

end
