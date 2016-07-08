require "minitest/autorun"
require "fakefs"
require "fakefs/safe"
require "config"
require "remind"

def debug(expected, actual)
  return "Expected: #{expected}, Actual: #{actual}"
end

def clean_up(*files)
  files.each do |file|
    file_path = File.join(::DATA_FOLDER, file)
    File.delete(file_path)
  end
end

def with_writer
  stdin = $stdin
  $stdin, writer = IO.pipe
  yield writer
rescue
  writer.close()
  $stdin = stdin
end

class RemindTest < Minitest::Test
  def test_remind_adds_entry
    FakeFS do
      with_writer do |writer|
        entry = "goodbye world..."
        writer.puts entry, ":done"
        file_name = Remind.new("add", "on monday").main()

        file_path = File.join(::DATA_FOLDER, file_name)
        content = File.read(file_path)

        assert entry == content, debug(entry, content)
        clean_up(file_name)
      end
    end
  end

  def test_remind_list_notes
    FakeFS do
      with_writer do |writer|
        writer.puts "goodbye", ":done"
        f1 = Remind.new("add", "on monday").main()

        writer.puts "world", ":done"
        f2 = Remind.new("add", "on monday").main()

        content = (Remind.new("list").main())
        expected = "1. goodbye\n2. world\n"

        assert expected == content, debug(expected, content)
        clean_up(f1, f2)
      end
    end
  end

  def test_remind_clear_all
    FakeFS do
      with_writer do |writer|

        writer.puts "goodbye", ":done"
        Remind.new("add", "on monday").main()

        writer.puts "world", ":done"
        Remind.new("add", "on monday").main()

        Remind.new("clear").main()
        content = (Remind.new("list").main())
        assert content.empty?, debug("<empty string>", content)
      end
    end
  end

  def test_remind_error_with_no_time_phrase
    FakeFS do
      err = assert_raises(RemindException) { Remind.new("add", "goodbye").main() }
      assert err.message == ::REMIND_USAGE, debug(::REMIND_USAGE, err.message)
    end
  end

end

class RemindTimerTest < Minitest::Test

  def test_remind_on_a_day
    time = RemindTimer.new("on tuesday").to_time
    assert time.tuesday?, debug("tuesday", time)
  end

  def test_remind_on_a_date
    time = RemindTimer.new("on may 27th").to_time
    assert time.month == 5, debug("may", time)
    assert time.day == 27, debug("27th", time)
  end

  def test_remind_on_with_nil
    time = RemindTimer.new("on blah").to_time
    assert time.nil?, debug(nil.class, time)
  end
end
