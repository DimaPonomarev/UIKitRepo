//
//  EupCalendar.swift
//  EupUiKit
//
//  Created by Артём  on 10.04.2025.
//

import SwiftUI

public struct EupCalendar: View {
    
    enum TypeOfMonth {
        case next
        case previous
    }
    
    @Environment(\.theme) private var theme
    
    private var dateStart: Date = Date().getMockStart()
    private var dateEnd: Date = Date().getMockEnd()
    private var isCanSelectWeekends: Bool = false
    private var selectedDateFromRange: (Date, Date) -> Void = { _, _ in }
    
    @State private var currentMonth = Date.now
    @State private var days: [Date] = []
    @State private var dateRange: [Date] = []
    @State private var selectedDateFromPicker: Date = Date.now
    
    @State private var isPickerSelect: Bool = false
    
    @State private var firstSelectedDate: Date?
    @State private var secondSelectedDate: Date?
    
    private var titleOfActionButton: String {
        isPickerSelect ? "Выбрать" : "Применить"
    }
    
    @State private var dateForFirstTextField: String = ""
    @State private var dateForSecondTextField: String = ""
    
    private let columns = Array(
        repeating: GridItem(spacing: 0),
        count: 7
    )
    
    public init(
        dateStart: Date,
        dateEnd: Date,
        isCanSelectWeekends: Bool,
        preselectedDateRange: [Date] = [],
        selectedDateFromRange: @escaping (Date, Date) -> Void
    ) {
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.isCanSelectWeekends = isCanSelectWeekends
        self.selectedDateFromRange = selectedDateFromRange
        self._dateRange = State(wrappedValue: preselectedDateRange)
        
        if !preselectedDateRange.isEmpty {
            self._dateForFirstTextField = State(wrappedValue: preselectedDateRange.first?.formattedDate ?? "")
            self._dateForSecondTextField = State(wrappedValue: preselectedDateRange.last?.formattedDate ?? "")
        }
        
        updateDays()
    }
    
    private var title: some View {
        HStack {
            EupText(
                fontType: .semibold(18),
                text: "Дата"
            )
            Spacer()
        }
        .padding(.leading, 15)
    }
    
    private var dateTextFields: some View {
        HStack(spacing: 10) {
            EupFloatingDateTextfield(
                text: $dateForFirstTextField,
                placeholder: "дд.мм.гггг",
                isFieldDisable: isPickerSelect,
                onClearButtonTap: {
                    dateRange.removeAll { $0 == firstSelectedDate }
                    updateSelectedDateValues()
                },
                returnApplyedDate: { date in
                    if !dateRange.contains(date) {
                        selectDate(date: date)
                    }
                }
            )
            EupFloatingDateTextfield(
                text: $dateForSecondTextField,
                placeholder: "дд.мм.гггг",
                isFieldDisable: isPickerSelect,
                onClearButtonTap: {
                    dateRange.removeAll { $0 == secondSelectedDate }
                    updateSelectedDateValues()
                },
                returnApplyedDate: { date in
                    if !dateRange.contains(date) {
                        selectDate(date: date)
                    }
                }
            )
        }
        .padding(.top, 16)
        .padding(.horizontal, 12)
    }
    
    private var controlButtons: some View {
        HStack {
            if !isPickerSelect {
                Button(
                    action: {
                        changeMonth(type: .previous)
                    },
                    label:  {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(theme.primaryColor)
                    }
                )
            }
            Spacer()
            
            Button(
                action: {
                    isPickerSelect.toggle()
                },
                label: {
                    HStack {
                        EupText(
                            fontType: .semibold(14),
                            text: currentMonth.nameOfMonth
                        )
                        EupText(
                            fontType: .semibold(14),
                            text: "\(currentMonth.yearInt)"
                        )
                        Image(systemName: "chevron.up")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(theme.primaryColor)
                            .rotationEffect(.degrees(!isPickerSelect ? 180 : 0))
                    }
                }
            )
            
            Spacer()
            
            if !isPickerSelect {
                Button(
                    action: {
                        changeMonth(type: .next)
                    },
                    label:  {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(theme.primaryColor)
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
    }
    
    private var selectedDayCircleView: some View {
        Circle()
            .inset(by: 0.5)
            .stroke(
                theme.primaryColor,
                lineWidth: 1
            )
            .padding(4)
    }
    
    private var weekDays: some View {
        LazyHStack(spacing: 17) {
            ForEach(
                WeekDaysEnum.allCases,
                id: \.title
            ) { weekDay in
                EupText(
                    fontType: .regular(16),
                    text: weekDay.title,
                    foregroundColor: weekDay == .sunday
                    || weekDay == .saturday
                    ? theme.onSurfaceLightGray
                    : theme.onSurfaceDarkGray
                )
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
            }
        }
        .frame(height: 44)
    }
    
    private var currentMonthView: some View {
        LazyVGrid(
            columns: columns,
            spacing: 0
        ) {
            ForEach(
                days,
                id: \.self
            ) { day in
                Button(
                    action: {
                        if !isMonthInUnAvailableRage() {
                            if isCanSelectWeekends {
                                selectDate(date: day)
                            } else if !Calendar.current.isDateInWeekend(day) {
                                selectDate(date: day)
                            }
                        }
                    },
                    label:  {
                        EupText(
                            fontType: .regular(16),
                            text: day.formatted(.dateTime.day()),
                            foregroundColor: getColorForDate(date: day)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                    }
                )
                .buttonStyle(PinButtonStyle())
                .overlay {
                    if day.formattedDate == Date().formattedDate {
                        selectedDayCircleView
                    }
                }
                .setRangeLineSelection(
                    dateRange: dateRange,
                    currentDate: day.startOfDay
                )
            }
        }
    }
    
    private var calendar: some View {
        VStack(
            spacing: 0
        ) {
            title
            dateTextFields
            controlButtons
            if isPickerSelect {
                EupWheelDatePicker(
                    dateStart: dateStart,
                    dateEnd: dateEnd,
                    currentSelectedDate: currentMonth,
                    selectedDate: { selectedDate in
                        currentMonth = selectedDate
                        updateDays()
                    }
                )
            } else {
                weekDays
                currentMonthView
            }
        }
        .animation(
            .linear(duration: 0.10),
            value: isPickerSelect
        )
    }
    
    private var calendarBody: some View {
        VStack(spacing: 16) {
            calendar
        }
        .safeAreaInset(edge: .bottom) {
            EupButton(
                buttonType: .containedPrimaryColor,
                title: titleOfActionButton,
                action: {
                    currentAction()
                }
            )
            .padding(20)
        }
    }
    
    public var body: some View {
        calendarBody
            .animation(
                .linear(duration: 0.1),
                value: days
            )
            .onAppear {
                updateDays()
            }
    }
    
    private func currentAction() {
        if isPickerSelect {
            isPickerSelect = false
        } else {
            guard let first = firstSelectedDate else { return }
            guard let second = secondSelectedDate else { return }
            selectedDateFromRange(first, second)
        }
    }
    
    private func updateDays() {
        days = currentMonth.displayFullDays
    }
    
    private func getColorForDate(date: Date) -> Color {
        let firstDate = dateRange.first ?? Date()
        let lastDate = dateRange.last ?? Date()
        
        if isMonthInUnAvailableRage() {
            return theme.onBackgroundLightGray
        } else {
            return Calendar.current.isDateInWeekend(date.startOfDay) || !date.startOfDay.isInSameMonth(as: currentMonth)
            ? date.startOfDay == firstDate || date.startOfDay == lastDate
            ? Color.white
            : theme.onBackgroundLightGray
            : date.startOfDay == firstDate || date.startOfDay == lastDate
            ? Color.white
            : theme.onSurfaceDarkGray
        }
    }
    
    private func changeMonth(type: TypeOfMonth) {
        currentMonth = Calendar.current.date(
            byAdding: .month,
            value: type == .next ? 1 : -1,
            to: currentMonth
        )!
        updateDays()
    }
    
    private func selectDate(date: Date) {
        if dateRange.count != 2 {
            dateRange.append(date.startOfDay)
            dateRange = dateRange.sorted { $0 < $1 }
        } else {
            dateRange = []
            dateRange.append(date.startOfDay)
        }
        updateSelectedDateValues()
    }
    
    private func updateSelectedDateValues() {
        firstSelectedDate = dateRange.first
        secondSelectedDate = dateRange.last
        dateForFirstTextField = firstSelectedDate?.formattedDate ?? ""
        dateForSecondTextField = secondSelectedDate?.formattedDate ?? ""
    }
    
    private func isMonthInUnAvailableRage() -> Bool {
        let range = dateStart...dateEnd
        return !range.contains(currentMonth)
    }
}

#Preview {
    EupCalendar(
        dateStart: Date().getMockStart(),
        dateEnd: Date().getMockEnd(),
        isCanSelectWeekends: false,
        selectedDateFromRange: { _, _ in }
    )
}
