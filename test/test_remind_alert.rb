require "minitest/autorun"
require "time"

require "helper"
require "remind/remind_note"
require "remind/remind_alert"


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
      time: (Time.now - (30 * 60)).to_s,
    )

    @late_note = RemindNote.new(
      action: "add",
      time_phrase: "on monday",
      time_marker: "on",
      title: "goodbye",
      body: "world..",
      time: (Time.now + (60 * 60 * 2)).to_s,
    )
  end

  def test_due_notes_are_sent
    TestHelper.fs do
      @due_note.save()
      @late_note.save()

      def TextAlert.call_service(message)
      end

      RemindAlert.send_all()

      due_note = RemindNote.find(@due_note.id)
      late_note = RemindNote.find(@late_note.id)

      assert due_note.sent, "Due note should have been sent"
      assert !late_note.sent, "Late note should not have been sent"
    end
  end

end
