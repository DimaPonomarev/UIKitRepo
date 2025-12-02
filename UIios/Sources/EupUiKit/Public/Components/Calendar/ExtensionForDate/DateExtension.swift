//
//  DateExtension.swift
//  EupUiKit
//
//  Created by Артём  on 10.04.2025.
//

import Foundation

public extension Date {
    static var firstDayOfWeek = Calendar.current.firstWeekday
    
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        // Adjusted for the different weekday starts
        var weekdays = calendar.shortWeekdaySymbols
        if firstDayOfWeek > 1 {
            for _ in 1..<firstDayOfWeek {
                if let first = weekdays.first {
                    weekdays.append(first)
                    weekdays.removeFirst()
                }
            }
        }
        return weekdays.map { $0.capitalized }
    }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var nameOfMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL"
        let stringDate = dateFormatter.string(from: self)
        return stringDate.capitalized
    }
    
    var firstWeekDayBeforeStart: Date {
       let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
       var numberFromPreviousMonth = startOfMonthWeekday - Self.firstDayOfWeek
       if numberFromPreviousMonth < 0 {
           numberFromPreviousMonth += 7 // Adjust to a 0-6 range if negative
       }
       return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays: [Date] {
       var days: [Date] = []
       // Start with days from the previous month to fill the grid
       let firstDisplayDay = firstWeekDayBeforeStart
       var day = firstDisplayDay
       while day < startOfMonth {
           days.append(day)
           day = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: day
           )!
       }
       // Add days of the current month
       for dayOffset in 0..<numberOfDaysInMonth {
           if let newDay = Calendar.current.date(
            byAdding: .day,
            value: dayOffset,
            to: startOfMonth
           ) {
               days.append(newDay)
           }
       }
       return days
    }
    
    var mondayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let daysFromPreviousMonth = (startOfMonthWeekday + 5) % 7
        return Calendar.current.date(byAdding: .day, value: -daysFromPreviousMonth, to: startOfMonth)!
    }
    
    var sundayAfterEnd: Date {
         let endOfMonthWeekday = Calendar.current.component(.weekday, from: endOfMonth)
         let daysToSunday = (7 - endOfMonthWeekday + 1) % 7
         return Calendar.current.date(byAdding: .day, value: daysToSunday, to: endOfMonth)!
     }
    
    var displayFullDays: [Date] {
        var days: [DateComponents] = []
        var returnedDays: [Date] = []
        
        // Previous month days
        var date = firstWeekDayBeforeStart
        while date < startOfMonth {
            days.append(Calendar.current.dateComponents([.calendar, .year, .month, .day, .hour], from: date))
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        // Current month days
        date = Calendar.current.date(byAdding: .hour, value: 2, to: startOfMonth)!
        while date <= endOfMonth {
            days.append(Calendar.current.dateComponents([.calendar, .year, .month, .day, .hour, .minute, .second], from: date))
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        // Next month days
        date = Calendar.current.date(byAdding: .day, value: 1, to: endOfMonth)!
        date = Calendar.current.date(byAdding: .hour, value: 3, to: endOfMonth)!
        while date <= sundayAfterEnd {
            days.append(Calendar.current.dateComponents([.calendar, .year, .month, .day, .hour], from: date))
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        returnedDays = days.map { $0.date ?? Date() }
        
        return returnedDays
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var yearInt: Int {
        Calendar.current.component(.year, from: self)
    }
    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var hourInt: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minuteInt: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    var formattedDateHourCombined: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
    
    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }
    
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }
    
    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}

public extension Date {
    func getMockStart() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2000-10-20")!
    }
    
    func getMockEnd() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2040-07-30")!
    }
}
