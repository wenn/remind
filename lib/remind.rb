require 'config'
require 'file_helper'

class Action
  LIST = 'list'
  ADD = 'add'
end

class Remind
  def self.main(entry)
    FileHelper.ensure_data_folder()

    action = find_action(entry)

    return action[entry]
  end

  def self.find_action(entry)
    methods = {
      ::Action::LIST => method(:list),
      ::Action::ADD => method(:add),
    }

    action = methods[entry]

    return action || methods[::Action::ADD]
  end

  def self.list(entry)
    content = ""
    Dir.glob("#{::DATA_FOLDER}/*") do |file|
      content << "#{File.read(file)}\n"
    end

    return content
  end

  def self.add(entry)
    file_path = FileHelper.find_file_path(entry)
    File.open(file_path, 'w+') { |f| f.write(entry) }

    return FileHelper.find_file_name(entry)
  end
end
