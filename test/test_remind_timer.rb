require "minitest/autorun"
require "config"
require "remind"
require "helper"

class RemindTimerTest < Minitest::Test

  def test_remind_with_nil
    time = RemindTimer.new("on blah").as_on()
    assert time.nil?, TestHelper.debug(nil.class, time)
  end

end

class RemindTimerAsOnTest < Minitest::Test

  def test_remind_on_a_day
    time = RemindTimer.new("on tuesday").as_on()
    assert time.tuesday?, TestHelper.debug("tuesday", time)
  end

  def test_remind_on_a_date
    time = RemindTimer.new("on may 27th").as_on()
    assert time.month == 5, TestHelper.debug("may", time)
    assert time.day == 27, TestHelper.debug("27th", time)
  end

end

class ReminderTimerAsAtTest < Minitest::Test

  def test_remind_at_time_with_suffix
    time = RemindTimer.new("at 10pm").as_at()
    assert 22 == time.hour, TestHelper.debug(22, time.hour)
  end

  def test_remind_at_time_with_military_time
    time = RemindTimer.new("at 10").as_at()
    assert 10 == time.hour, TestHelper.debug(10, time.hour)
  end

end
