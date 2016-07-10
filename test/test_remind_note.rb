require "minitest/autorun"
require "time"

require "helper"
require "remind_note"

class RemindNoteTest < Minitest::Test

  def setup
    @note = RemindNote.new(
      action: "add",
      time_phrase: "on monday",
      time_marker: "on",
      title: "goodbye",
      body: "world..",
      time: "<stub>",
    )
  end

  def test_to_hash
    hash = @note.to_hash()
    expected = {
      "action" => "add",
      "time_phrase" => "on monday",
      "time_marker" => "on",
      "title" => "goodbye",
      "body" => "world..",
      "time" => "<stub>",
    }

    hash.delete("id")
    assert expected == hash, TestHelper.debug(expected, hash)
  end

  def test_to_json
    json = @note.to_json()
    hash = JSON.parse(json)
    hash.delete("id")

    expected = {
      "action" => "add",
      "time_phrase" => "on monday",
      "time_marker" => "on",
      "title" => "goodbye",
      "body" => "world..",
      "time" => "<stub>",
    }

    assert expected == hash, TestHelper.debug(expected, hash)
  end

  def test_make_note_from_json
    data = {
      "action" => "add",
      "time_phrase" => "on monday",
      "time_marker" => "on",
      "title" => "goodbye",
      "body" => "world..",
      "time" => "<stub>",
    }

    note = RemindNote.make(data)
    hash = note.to_hash()

    hash.delete("id")
    assert data == hash, TestHelper.debug(data, hash)
  end
end

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

      MockNotes.with_notes do |note|
        assert [@due_note.id, @late_note.id].include? note.id
      end
    end
  end

  def test_return_only_due_notes
    TestHelper.fs do
      @due_note.save()
      @late_note.save()

      MockNotes.with_due_notes do |note|
        assert [@due_note.id].include?(note.id), \
          TestHelper.debug(@due_note.id, note.id)
        assert !([@late_note.id].include?(note.id)), \
          TestHelper.debug(@late_note.id, note.id)
      end
    end
  end

end
