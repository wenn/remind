require "fileutils"
require "remind/remind_config"
require "securerandom"

module TestHelper
  TEST_DATA_FOLDER = "/tmp/.remind/data"
  DATA_FOLDER = Config.data_folder

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
      return TestHelper::DATA_FOLDER
    end

    FileUtils.mkdir_p(Config.data_folder)
    yield
  ensure
    `rm -rf #{Config.data_folder}`

    def Config.data_folder
      return TestHelper::DATA_FOLDER
    end
  end
end
