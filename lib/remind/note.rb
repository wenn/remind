require "digest"
require "json"

require "remind/helper"

class RemindNote
  attr_reader :id, :sent
  attr_reader :action, :time_phrase, :time_marker, :title, :body, :time

  def initialize(action:, time_phrase:, time_marker:, \
                 title:, body:, time:, sent: false)
    @id = make_id(title + body + time.to_s)
    @action = action
    @time_phrase = time_phrase
    @time_marker = time_marker
    @title = title
    @body = body
    @time = time
    @sent = sent
  end

  def to_hash
    return {
      "id" => @id,
      "action" => @action,
      "time_phrase" => @time_phrase,
      "time_marker" => @time_marker,
      "title" => @title,
      "body" => @body,
      "time" => @time,
      "sent" => @sent,
    }
  end

  def to_json
    data = to_hash()
    return JSON.pretty_generate(data)
  end

  def set_sent(sent)
    @sent = sent
  end

  def save
    file_path = FileHelper.find_file_path(@id)
    File.open(file_path, 'w+') { |f| f.write(to_json()) }

    return id
  end

  def self.find(id)
    file_path = FileHelper.find_file_path(id)
    data = JSON.parse(File.read(file_path))

    return self.make(data)
  end

  def self.make(note_hash)
    args_arr = note_hash.map do |key, val|
      [key.to_sym, val]
    end

    args = Hash[args_arr]
    args.delete(:id)

    return self.new(args)
  end

  private
  def make_id(note)
    return (Digest::MD5.new).hexdigest(note.to_json)[0..Config.file_name_size]
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
    time_hour = time.hour + ((time.min/60.0).round(2))
    now = now()

    # TODO: need to account for midnight transitioning
    duration = (Config.alert_polling_in_minutes/60.0).round(2)
    start_hour = now.hour - duration
    end_hour = now.hour

    return (time_hour >= start_hour and time_hour <= end_hour)
  end

  private
  def self.now
    return Time.now
  end
end
