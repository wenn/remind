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
      content << "#{index}. #{data.fetch("title")}\n"
    end

    return content
  end

  def add
    time, marker = find_time()
    body = prompt_body()

    note = RemindNote.new(
      action: @action,
      time_phrase: @time_phrase,
      time_marker: marker.val,
      title: body.split("\n")[0],
      body: body,
      time: time,
    )

    file_name = FileHelper.make_file_name()
    file_path = FileHelper.find_file_path(file_name)
    File.open(file_path, 'w+') { |f| f.write(note.to_json()) }

    return file_name
  end

  def clear_all
    FileHelper.data_files do |file|
      File.delete(file)
    end
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
end
