require "minitest/autorun"
require "config"
require "remind"
require "helper"

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

  def test_remind_on_with_nil
    time = RemindTimer.new("on blah").as_on()
    assert time.nil?, TestHelper.debug(nil.class, time)
  end

end
