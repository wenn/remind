require 'fileutils'
require 'digest'
require 'config'

class FileHelper
  def self.find_file_path(entry)
    file_name = find_file_name(entry)
    file_path = File.join(::DATA_FOLDER, file_name)

    return file_path
  end

  def self.make_file_name(entry)
    return Digest::SHA1.hexdigest(entry)[0,::FILE_NAME_SIZE]
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
