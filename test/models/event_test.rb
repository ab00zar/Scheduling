require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  test "more complex test example" do
    
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-07-28 08:30"), ends_at: DateTime.parse("2014-07-28 09:30"), weekly_recurring: true
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-11 15:30"), ends_at: DateTime.parse("2014-08-11 16:00")  
    
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-12 12:30"), ends_at: DateTime.parse("2014-08-12 14:00")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-05 09:00"), ends_at: DateTime.parse("2014-08-05 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-05 10:30"), ends_at: DateTime.parse("2014-08-05 11:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-12 11:30"), ends_at: DateTime.parse("2014-08-12 12:30")
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-05 12:30"), ends_at: DateTime.parse("2014-08-05 13:30")
      
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-13 12:30"), ends_at: DateTime.parse("2014-08-13 14:00")  
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-06 08:30"), ends_at: DateTime.parse("2014-08-06 09:30"), weekly_recurring: true
    
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-14 12:30"), ends_at: DateTime.parse("2014-08-14 13:30")
      
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-08 12:30"), ends_at: DateTime.parse("2014-08-08 13:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-15 12:30"), ends_at: DateTime.parse("2014-08-15 13:30")  
      
    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["08:30", "09:00", "09:30", "10:00", "11:30", "12:00", "15:30"], availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 12), availabilities[2][:date]
    assert_equal ["09:00", "09:30", "10:00", "12:30", "13:00", "13:30"], availabilities[2][:slots]
    assert_equal Date.new(2014, 8, 13), availabilities[3][:date]
    assert_equal ["08:30", "09:00", "12:30", "13:00", "13:30"], availabilities[3][:slots]
    assert_equal Date.new(2014, 8, 14), availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]
    assert_equal Date.new(2014, 8, 15), availabilities[5][:date]
    assert_equal [], availabilities[5][:slots]       
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end
  
    
end
