require "json"

require "remind_helper"

class RemindNote
  attr_reader :action, :time_phrase, :time_marker, :title, :body, :time

  def initialize(action:, time_phrase:, time_marker:, title:, body:, time:)
    @action = action
    @time_phrase = time_phrase
    @time_marker = time_marker
    @title = title
    @body = body
    @time = time
  end

  def to_hash
    return {
      "action" => @action,
      "time_phrase" => @time_phrase,
      "time_marker" => @time_marker,
      "title" => @title,
      "body" => @body,
      "time" => @time,
    }
  end

  def to_json
    data = to_hash()
    return JSON.pretty_generate(data)
  end

  def self.make(json)
    args = json.map do |key, val|
      [key.to_sym, val]
    end

    return self.new(Hash[args])
  end

end

class RemindNotes

  def self.with_notes
    FileHelper.data_files do |file|
      data = JSON.parse(File.read(file))
      yield RemindNote.make(data)
    end
  end

  def self.with_due_notes
    FileHelper.data_files do |file|
      data = JSON.parse(File.read(file))
      note = RemindNote.make(data)

      if is_note_due(note)
        yield note
      end
    end
  end

  private
  def self.is_note_due(note)
    time = Time.parse(note.time)
    now = now()

    duration = (ALERT_POLLING_IN_MINUTES/60.0).round(2)
    start_hour = now - duration
    end_hour = now

    return (time >= start_hour and time <= end_hour)
  end

  private
  def self.now
    return Time.now
  end
end
