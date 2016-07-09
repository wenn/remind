require "minitest/autorun"
require "remind_config"
require "remind"
require "helper"

class RemindTimerTest < Minitest::Test

  def test_remind_with_nil
    time, _ = RemindTimer.new("on blah").parse()
    assert time.nil?, TestHelper.debug(nil.class, time)
  end

end

class RemindTimerAsOnTest < Minitest::Test

  def test_remind_on_a_day
    time, _ = RemindTimer.new("on tuesday").parse()
    assert time.tuesday?, TestHelper.debug("tuesday", time)
  end

  def test_remind_on_a_date
    time, _ = RemindTimer.new("on may 27th").parse()
    assert time.month == 5, TestHelper.debug("may", time)
    assert time.day == 27, TestHelper.debug("27th", time)
  end

end

class ReminderTimerAsAtTest < Minitest::Test

  def test_remind_at_time_with_suffix
    time, _ = RemindTimer.new("at 10pm").parse()
    assert 22 == time.hour, TestHelper.debug(22, time.hour)
  end

  def test_remind_at_time_with_military_time
    time, _ = RemindTimer.new("at 10").parse()
    assert 10 == time.hour, TestHelper.debug(10, time.hour)
  end

end
