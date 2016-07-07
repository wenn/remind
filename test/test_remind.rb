require 'minitest/autorun'
require 'fakefs'
require 'fakefs/safe'
require 'config'
require 'remind'

def debug(expected, actual)
  return "Expected: #{expected}, Actual: #{actual}"
end

class RemindTest < Minitest::Test
  def test_remind_adds_entry
    FakeFS do
      entry = 'goodbye world...'
      file_name = Remind.new('add', entry).main()

      file_path = File.join(::DATA_FOLDER, file_name)
      content = File.read(file_path)

      assert entry == content, debug(entry, content)
    end
  end

  def test_remind_list_notes
    FakeFS do
      Remind.new('add', '1').main()
      Remind.new('add', '2').main()

      content = (Remind.new('list').main())
      expected = "1\n2\n"

      assert expected == content, debug(expected, content)
    end
  end
end
