require 'fileutils'
require 'digest'
require 'config'
require 'securerandom'

class FileHelper
  def self.find_file_path(file_name)
    file_path = File.join(::DATA_FOLDER, file_name)

    return file_path
  end

  def self.make_file_name
    return SecureRandom.hex
  end

  def self.data_files
    Dir.foreach(::DATA_FOLDER) do |item|
      next if item == '.' or item == '..'
      yield File.join(::DATA_FOLDER, item)
    end
  end

  def self.ensure_data_folder
    if not Dir.exists?(::DATA_FOLDER)
      FileUtils.mkdir_p(::DATA_FOLDER)
    end
  end
end
