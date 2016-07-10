require 'digest'

require 'remind_config'
require 'remind_helper'
require 'remind_timer'
require 'remind_note'
require 'remind_error'

REMIND_USAGE = 'change me'
QUIT_MARKER = ':q'

class Action
  LIST = 'list'
  ME = 'me'
  ADD = 'add'
  CLEAR = 'clear'
end

class Remind

  def initialize(action, time_phrase = nil)
    @action = action.downcase
    @time_phrase = time_phrase
    @timer_marker = nil
  end

  def main
    FileHelper.ensure_data_folder()

    return find_action()[]
  end

  def find_action
    methods = {
      ::Action::LIST => method(:list),
      ::Action::ADD => method(:add),
      ::Action::ME => method(:add),
      ::Action::CLEAR => method(:clear_all),
    }

    method = methods[@action]

    return method || methods[::Action::ADD]
  end

  def list
    content = ""
    index = 0

    FileHelper.data_files do |file|
      index += 1
      data = JSON.parse(File.read(file))
      note = RemindNote.make(data)
      content << "#{index}. #{note.title}\n"
    end

    return content
  end

  def add
    time, marker = find_time()
    body = prompt_body()
    id = make_id(@action + body + time.to_s)

    note = RemindNote.new(
      id: id,
      action: @action,
      time_phrase: @time_phrase,
      time_marker: marker.val,
      title: body.split("\n")[0],
      body: body,
      time: time,
    )

    return self.class.write_note(id, note)
  end

  def clear_all
    FileHelper.data_files do |file|
      File.delete(file)
    end
  end

  private
  def self.write_note(file_name, note)
    file_path = FileHelper.find_file_path(file_name)
    File.open(file_path, 'w+') { |f| f.write(note.to_json()) }

    return file_name
  end

  private
  def find_time
    time, marker = RemindTimer.new(@time_phrase).parse()

    if time.nil?
      fail RemindException, ::REMIND_USAGE
    end

    return time, marker
  end

  private
  def prompt_body
    body = ""
    loop do
      content = gets
      break if content.chomp.eql?(":q")
      body << content
    end

    return body.chomp
  end

  private
  def make_id(note)
    return (Digest::MD5.new).hexdigest(note.to_json)[0..Config.file_name_size]
  end

end
