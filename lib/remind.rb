require 'config'
require 'fileutils'
require 'digest'

class Remind
  def self.main(entry)
    ensure_data_folder()
    file_name = Digest::SHA1.hexdigest(entry)
    file_path = File.join(::DATA_FOLDER, file_name)

    File.open(file_path, 'w+') { |f| f.write(entry) }

    return file_name
  end

  def self.ensure_data_folder
    if not Dir.exists?(::DATA_FOLDER)
      FileUtils.mkdir_p(::DATA_FOLDER)
    end
  end
end
