require 'minitest/autorun'
require 'fakefs'
require 'config'
require 'remind'


class RemindTest < Minitest::Test
  def test_remind_adds_entry
    FakeFS do
      entry = 'goodbye world...'
      file_name = Remind.main(entry)

      file_path = File.join(::DATA_FOLDER, file_name)
      content = File.read(file_path)

      assert entry == content, "expected: #{entry}"
    end
  end
end
