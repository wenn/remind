require 'minitest/autorun'
require 'fakefs'
require 'fakefs/safe'
require 'config'
require 'remind'

def debug(expected, actual)
  return "Expected: #{expected}, Actual: #{actual}"
end

def clean_up(*files)
  files.each do |file|
    file_path = File.join(::DATA_FOLDER, file)
    File.delete(file_path)
  end
end

class RemindTest < Minitest::Test
  def test_remind_adds_entry
    FakeFS do
      entry = 'goodbye world...'
      file_name = Remind.new('add', entry).main()

      file_path = File.join(::DATA_FOLDER, file_name)
      content = File.read(file_path)

      assert entry == content, debug(entry, content)
      clean_up(file_name)
    end
  end

  def test_remind_list_notes
    FakeFS do
      f1 = Remind.new('add', 'goodbye').main()
      f2 = Remind.new('add', 'world').main()

      content = (Remind.new('list').main())
      expected = "1. goodbye\n2. world\n"

      assert expected == content, debug(expected, content)
      clean_up(f1, f2)
    end
  end
end
