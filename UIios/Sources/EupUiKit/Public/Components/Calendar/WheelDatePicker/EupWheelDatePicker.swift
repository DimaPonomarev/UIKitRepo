//
//  EupWheelDatePicker.swift
//  EupUiKit
//
//  Created by Артём  on 11.04.2025.
//

import SwiftUI

public struct EupWheelDatePicker: View {

    @State private var dateStart: Date
    @State private var dateEnd: Date
    @State private var currentSelectedDate: Date = Date.now
    
    @State private var selectedDateMonthFromPicker: String = ""
    @State private var selectedDateYearFromPicker: Int = 0
    @State private var dates: [Date] = []
    
    @State private var years: [Int] = []
    @State private var months: [String] = []
    
    private var selectedDate: (Date) -> Void
    
    public init(
        dateStart: Date,
        dateEnd: Date,
        currentSelectedDate: Date,
        selectedDate: @escaping (Date) -> Void
    ) {
        self._dateStart = State(initialValue: dateStart)
        self._dateEnd = State(initialValue: dateEnd)
        self._currentSelectedDate = State(initialValue: currentSelectedDate)
        self.selectedDate = selectedDate
    }
    
    public var body: some View {
        HStack(spacing: -15) {
            Picker(
                "",
                selection: $selectedDateMonthFromPicker,
                content: {
                    ForEach(
                        months,
                        id: \.self
                    ) { month in
                        EupText(
                            fontType: .semibold(20),
                            text: month
                        )
                    }
                }
            )
            .pickerStyle(.wheel)
            .onChange(of: selectedDateMonthFromPicker) { _ in
                selectDate(
                    selectedYear: selectedDateYearFromPicker,
                    selectedMonth: selectedDateMonthFromPicker
                )
            }
            
            Picker(
                "",
                selection: $selectedDateYearFromPicker,
                content: {
                    ForEach(
                        years.sorted { $0 < $1 },
                        id: \.self
                    ) { year in
                        EupText(
                            fontType: .semibold(20),
                            text: "\(year)"
                        )
                    }
                }
            )
            .pickerStyle(.wheel)
            .onChange(of: selectedDateYearFromPicker) { _ in
                selectDate(
                    selectedYear: selectedDateYearFromPicker,
                    selectedMonth: selectedDateMonthFromPicker
                )
            }
        }
        .onAppear {
            initialazedValues()
        }
    }
    
    private func initialazedValues() {
        dates = getDates(
            start: dateStart,
            end: dateEnd
        )
        selectedDateYearFromPicker = years.first { $0 == currentSelectedDate.yearInt } ?? 0
        selectedDateMonthFromPicker = self.months.first { $0 == currentSelectedDate.nameOfMonth } ?? ""
    }
    
    private func calculateRangeDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if dateStart.yearInt == selectedDateYearFromPicker {
            let end = formatter.date(from: "\(dateStart.yearInt)-12-30") ?? Date()
            dates = getDates(
                start: dateStart,
                end: end
            )
        } else if dateEnd.yearInt == selectedDateYearFromPicker {
            let start = formatter.date(from: "\(dateEnd.yearInt)-01-30") ?? Date()
            dates = getDates(
                start: start,
                end: dateEnd
            )
        } else {
            dates = getDates(
                start: dateStart,
                end: dateEnd
            )
        }
    }
    
    private func getDates(
        start: Date,
        end: Date
    ) -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var months: [Date] = []
        self.months = []
        
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: start)),
              let endOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: end)) else {
            return []
        }
        
        var currentDate = startOfMonth
        
        while currentDate <= endOfMonth {
            months.append(currentDate)
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        months.forEach { date in
            if !years.contains(date.yearInt) {
                years.append(date.yearInt)
            }
        }
        
        months.forEach { date in
            if !self.months.contains(date.nameOfMonth) {
                self.months.append(date.nameOfMonth)
            }
        }
        
        return months
    }
    
    private func selectDate(
        selectedYear: Int,
        selectedMonth: String
    ) {
        let date = dates.first { $0.yearInt == selectedYear && $0.nameOfMonth == selectedMonth } ?? Date.now
        selectedDate(date)
        calculateRangeDate()
    }
    
    private func updateDataSource() {
       
    }
}

#Preview {
    struct WheelDatePickerWraper: View {
        
        @State private var start = Date.now
        @State private var end = Date.now
        
        var body: some View {
            EupWheelDatePicker(
                dateStart: Date().getMockStart(),
                dateEnd: Date().getMockEnd(),
                currentSelectedDate: .now,
                selectedDate: { date in
                    print("SELECTEDDATE \(date)")
                }
            )
        }
    }
    return WheelDatePickerWraper()
}
