require 'minitest/autorun'

require 'helper'
require 'remind_note'

class RemindNoteTest < Minitest::Test

  def test_to_hash
    note = RemindNote.new(
      action: "add",
      time_phrase: "on monday",
      time_marker: "on",
      title: "goodbye",
      body: "world..",
      time: "<stub>",
    )

    hash = note.to_hash()
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

  def test_to_json
    note = RemindNote.new(
      action: "add",
      time_phrase: "on monday",
      time_marker: "on",
      title: "goodbye",
      body: "world..",
      time: "<stub>",
    )

    hash = note.to_json()
    expected = JSON.pretty_generate({
      "action" => "add",
      "time_phrase" => "on monday",
      "time_marker" => "on",
      "title" => "goodbye",
      "body" => "world..",
      "time" => "<stub>",
    })

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

    assert data == hash, TestHelper.debug(data, hash)
  end
end
