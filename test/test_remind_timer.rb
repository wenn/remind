require "minitest/autorun"
require "remind/remind_config"
require "remind"
require "helper"

class RemindTimeParserTest < Minitest::Test

  def test_remind_with_nil
    time, _ = RemindTimeParser.new("on blah").parse()
    assert time.nil?, TestHelper.debug(nil.class, time)
  end

end

class RemindTimeParserAsOnTest < Minitest::Test

  def test_remind_on_a_day
    time, _ = RemindTimeParser.new("on tuesday").parse()
    assert time.tuesday?, TestHelper.debug("tuesday", time)
  end

  def test_remind_on_a_date
    time, _ = RemindTimeParser.new("on may 27th").parse()
    assert time.month == 5, TestHelper.debug("may", time)
    assert time.day == 27, TestHelper.debug("27th", time)
  end

end

class ReminderTimerAsAtTest < Minitest::Test

  def test_remind_at_time_with_suffix
    time, _ = RemindTimeParser.new("at 10pm").parse()
    assert 22 == time.hour, TestHelper.debug(22, time.hour)
  end

  def test_remind_at_time_with_military_time
    time, _ = RemindTimeParser.new("at 10").parse()
    assert 10 == time.hour, TestHelper.debug(10, time.hour)
  end

end
