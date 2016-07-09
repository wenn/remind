require "remind_config"

module TestHelper
  def self.debug(expected, actual)
    return "Expected: #{expected}, Actual: #{actual}"
  end

  def self.clean_up(*files)
    files.each do |file|
      file_path = File.join(::DATA_FOLDER, file)
      File.delete(file_path)
    end
  end

  def self.with_writer
    stdin = $stdin
    $stdin, writer = IO.pipe
    yield writer
  rescue
    writer.close()
    $stdin = stdin
  end
end
