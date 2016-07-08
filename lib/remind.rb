require 'chronic'
require 'config'
require 'file_helper'

REMIND_USAGE = 'change me'

class Action
  LIST = 'list'
  ME = 'me'
  ADD = 'add'
  CLEAR = 'clear'
end

class RemindException < Exception
end

class RemindTimer

  def initialize(time_phrase)
    @time_phrase = time_phrase
  end

  def to_time

    if not @time_phrase[/^on\s/]
      fail RemindException, ::REMIND_USAGE
    end

    time = nil
    time_phrase_arr = @time_phrase.split
    phrase = time_phrase_arr[0..-1].join(' ')
    time = Chronic.parse(phrase)

    if time.nil?
      phrase = time_phrase_arr[1..-1].join(' ')
      time = Chronic.parse(phrase)
    end

    return time
  end

end

class Remind

  def initialize(action, time_phrase = nil)
    @action = action.downcase
    @time_phrase = time_phrase
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
      content << "#{index}. #{File.read(file)}\n"
    end

    return content
  end

  def add

    time = find_time()

    body = prompt_body()
    file_name = FileHelper.make_file_name(@time_phrase + body)
    file_path = FileHelper.find_file_path(file_name)
    File.open(file_path, 'w+') { |f| f.write(body) }

    return file_name
  end

  def clear_all
    FileHelper.data_files do |file|
      File.delete(file)
    end
  end

  private
  def find_time
    time = RemindTimer.new(@time_phrase).to_time
    if time.nil?
      fail RemindException, ::REMIND_USAGE
    end

    return time
  end

  private
  def prompt_body
    body = ""
    loop do
      content = gets
      break if content.chomp.eql?(":done")
      body << content
    end

    return body.chomp
  end
end
