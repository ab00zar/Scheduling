class Event < ApplicationRecord
    scope :opening, ->(date) {(where kind: 'opening').where("DATE(starts_at) = ?", date.to_date).order('starts_at ASC')}
    scope :weekly_opening, ->(date) {(where kind: 'opening').where(weekly_recurring: true).where("cast(strftime('%w', starts_at) as int) = ?", date.wday)}
    
    scope :appointment, ->(date) {(where kind: 'appointment').where("DATE(starts_at) = ?", date.to_date)}
    scope :weekly_appointment, ->(date) {(where kind: 'appointment').where(weekly_recurring: true).where("cast(strftime('%w', starts_at) as int) = ?", date.wday)}

    @@result = []
    @@openings = []
    @@appointments = []
    
    class << self
        
        def availabilities(date)
            check_next_seven_days(date)
        end

        
        def check_next_seven_days(first_day)
            (first_day -1 .. first_day + 6).inject { |init, date|  day_availabilities(date) } 
        end
        
        
        def day_availabilities(date)
            #if there's not any opening for this day, return empty slots, else check for available slots 
            if Event.opening(date).blank? && Event.weekly_opening(date).blank?
                @@result.push({"date":date,"slots":[]})
            else
                find_openings(date)
                find_appointments(date)
                @@result.push({"date":date,"slots": (@@openings - @@appointments).sort })
                @@openings.clear
                @@appointments.clear
            end
        end
        
        
        def find_openings(date) #multiple openings (normal and/or weekly) per day are possible
            #Add all daily openings 
            Event.opening(date).each do |opening|
                last_slot = opening.ends_at - 30*60
                while opening.starts_at.strftime("%H:%M") <= last_slot.strftime("%H:%M") do
                    if !@@openings.include? opening.starts_at.strftime("%H:%M")
                        @@openings.push(opening.starts_at.strftime("%H:%M"))
                    end
                    opening.starts_at += 30 * 60
                end
            end
            
            #Add all weekly openings
            Event.weekly_opening(date).each do |opening|
                last_slot = opening.ends_at - 30*60
                while opening.starts_at.strftime("%H:%M") <= last_slot.strftime("%H:%M") do
                    if !@@openings.include? opening.starts_at.strftime("%H:%M")
                        @@openings.push(opening.starts_at.strftime("%H:%M"))
                    end
                    opening.starts_at += 30 * 60
                end
            end
        end

        
        def find_appointments(date) #multiple appointments (normal and/or weekly) per day are possible
            #Add all daily appointments
            Event.appointment(date).each do |appointment|
                last_slot = appointment.ends_at - 30*60
                while appointment.starts_at.strftime("%H:%M") <= last_slot.strftime("%H:%M") do
                    if !@@appointments.include? appointment.starts_at.strftime("%H:%M")
                        @@appointments.push(appointment.starts_at.strftime("%H:%M"))
                    end
                    appointment.starts_at += 30 * 60
                end
            end
            
            #Add all weekly appointments
            Event.weekly_appointment(date).each do |appointment|
                last_slot = appointment.ends_at - 30*60
                while appointment.starts_at.strftime("%H:%M") <= last_slot.strftime("%H:%M") do
                    if !@@appointments.include? appointment.starts_at.strftime("%H:%M")
                        @@appointments.push(appointment.starts_at.strftime("%H:%M"))
                    end
                    appointment.starts_at += 30 * 60
                end
            end
        end               
        
    end
end