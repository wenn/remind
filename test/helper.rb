require "fileutils"
require "remind_config"

TEST_DATA_FOLDER = "/tmp/.remind/data"
DATA_FOLDER = Config.data_folder

module TestHelper
  def self.debug(expected, actual)
    return "Expected: #{expected}, Actual: #{actual}"
  end

  def self.with_writer
    stdin = $stdin
    $stdin, writer = IO.pipe
    yield writer
  ensure
    writer.close()
    $stdin.close()
    $stdin = stdin
  end

  def self.fs
    def Config.data_folder
      return ::TEST_DATA_FOLDER
    end

    FileUtils.mkdir_p(::TEST_DATA_FOLDER)
    yield
  ensure
    `rm -rf #{::TEST_DATA_FOLDER}`

    def Config.data_folder
      return DATA_FOLDER
    end
  end
end
