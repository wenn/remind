require "minitest/autorun"
require "time"

require "remind"
require "remind_config"
require "remind_error"
require "helper"

class RemindTest < Minitest::Test

  def test_remind_adds_entry
    TestHelper.fs do
      TestHelper.with_writer do |writer|
        entry = "goodbye world..."

        writer.puts entry, ":q"
        id = Remind.new("add", "on monday").main()
        file_path = File.join(Config.data_folder, id)
        content = File.read(file_path)

        expected = {
          "id" => id,
          "action" => "add",
          "time_phrase" => "on monday",
          "time_marker" => "on",
          "body" => "goodbye world...",
          "title" => "goodbye world...",
          "sent" => false,
        }

        data = JSON.parse(content)
        time = Time.parse(data.fetch("time"))
        data.delete("time")

        assert expected == data, TestHelper.debug(expected, data)
        assert time.monday?, "Should be Monday"
      end
    end
  end

  def test_remind_list_notes
    TestHelper.fs do
      TestHelper.with_writer do |writer|
        writer.puts "goodbye", ":q"
        f1 = Remind.new("add", "on monday").main()

        writer.puts "world", ":q"
        f2 = Remind.new("add", "on monday").main()

        content = (Remind.new("list").main())
        expected = "1. world\n2. goodbye\n"

        assert expected == content, TestHelper.debug(expected, content)
      end
    end
  end

  def test_remind_clear_all
    TestHelper.fs do
      TestHelper.with_writer do |writer|

        writer.puts "goodbye", ":q"
        Remind.new("add", "on monday").main()

        writer.puts "world", ":q"
        Remind.new("add", "on monday").main()

        Remind.new("clear").main()
        content = (Remind.new("list").main())
        assert content.empty?, TestHelper.debug("<empty string>", content)
      end
    end
  end

  def test_remind_error_with_no_time_phrase
    TestHelper.fs do
      err = assert_raises(RemindException) { Remind.new("add", "goodbye").main() }
      assert err.message == ::REMIND_USAGE, TestHelper.debug(::REMIND_USAGE, err.message)
    end
  end

end
