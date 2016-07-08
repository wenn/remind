require 'chronic'
require 'config'
require 'file_helper'

class Action
  LIST = 'list'
  ME = 'me'
  ADD = 'add'
  CLEAR = 'clear'
end

class RemindWithOn

  def initialize(entry)
    @entry = entry
    @phrase = nil
  end

  def to_time
    entry_arr = @entry.split
    index = entry_arr.reverse.index('on')

    phrase = entry_arr[-index..-1].join(' ')
    time = Chronic.parse(phrase)

    if time.nil?
      phrase = entry_arr[(-index + 1)..-1].join(' ')
      time = Chronic.parse(phrase)
    end

    return time
  end

end

class Remind

  def initialize(action, entry = nil)
    @action = action.downcase
    @entry = entry
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

    file_path = FileHelper.find_file_path(@entry)
    File.open(file_path, 'w+') { |f| f.write(@entry) }

    return FileHelper.find_file_name(@entry)
  end

  def clear_all
    FileHelper.data_files do |file|
      File.delete(file)
    end
  end
end
