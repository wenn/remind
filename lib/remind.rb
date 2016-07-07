require 'config'
require 'file_helper'

class Action
  LIST = 'list'
  ME = 'me'
  ADD = 'add'
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
    }

    method = methods[@action]

    return method || methods[::Action::ADD]
  end

  def list
    content = ""
    Dir.glob("#{::DATA_FOLDER}/*") do |file|
      content << "#{File.read(file)}\n"
    end

    return content
  end

  def add
    file_path = FileHelper.find_file_path(@entry)
    File.open(file_path, 'w+') { |f| f.write(@entry) }

    return FileHelper.find_file_name(@entry)
  end
end
