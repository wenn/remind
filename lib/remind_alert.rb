require "file_helper"

class RemindAlert

  def main()
    FileHelper.data_files do |file|
      data = JSON.parse(File.read(file))
      time = data["time"]
    end
  end

end
