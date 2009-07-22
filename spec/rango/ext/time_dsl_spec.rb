# encoding: utf-8

# Author: Martin Hrdlička

require_relative "../../../lib/rango/ext/time_dsl"

SECOND = 1
MINUTE = 60  * SECOND
HOUR   = 60  * MINUTE
DAY    = 24  * HOUR
WEEK   = 7   * DAY
MONTH  = 30  * DAY
YEAR   = 365 * DAY + 6 * HOUR

describe TimeDSL do
  it "should return correct count of seconds for 1.second" do
    1.second.should eql SECOND
  end

  it "should return correct count of seconds for 2.seconds" do
    2.seconds.should eql 2 * SECOND
  end

  it "should return correct count of seconds for 1.minute" do
    1.minute.should eql MINUTE
  end

  it "should return correct count of seconds for 2.minutes" do
    2.minutes.should eql 2 * MINUTE
  end

  it "should return correct count of seconds for 1.hour" do
    1.hour.should eql HOUR
  end

  it "should return correct count of seconds for 2.hours" do
    2.hours.should eql 2 * HOUR
  end

  it "should return correct count of seconds for 1.day" do
    1.day.should eql DAY
  end

  it "should return correct count of seconds for 2.day" do
    2.day.should eql 2 * DAY
  end

  it "should return correct count of seconds for 1.week" do
    1.week.should eql WEEK
  end

  it "should return correct count of seconds for 2.weeks" do
    2.weeks.should eql 2 * WEEK
  end

  it "should return correct count of seconds for 1.month" do
    1.month.should eql MONTH
  end

  it "should return correct count of seconds for 2.months" do
    2.months.should eql 2 * MONTH
  end

  it "should return correct count of seconds for 1.year" do
    1.year.should eql YEAR
  end

  it "should return correct count of seconds for 2.years" do
    2.years.should eql 2 * YEAR
  end

  it "should return correct since time for any time" do
    actual_time = ::Time.now
    1.day.since(actual_time).should eql actual_time + DAY
  end

  it "should return correct time from now for any time" do
    actual_time = ::Time.now
    1.day.from_now(actual_time).should eql actual_time + DAY
  end

  it "should return correct time ago time for any time" do
    actual_time = ::Time.now
    1.day.ago(actual_time).should eql actual_time - DAY
  end
end
