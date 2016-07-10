require 'fileutils'
require 'remind/remind_config'

class FileHelper
  def self.find_file_path(file_name)
    file_path = File.join(Config.data_folder, file_name)

    return file_path
  end

  def self.data_files
    Dir.foreach(Config.data_folder) do |item|
      next if item == '.' or item == '..'
      yield File.join(Config.data_folder, item)
    end
  end

  def self.ensure_data_folder
    if not Dir.exists?(Config.data_folder)
      FileUtils.mkdir_p(Config.data_folder)
    end
  end
end
