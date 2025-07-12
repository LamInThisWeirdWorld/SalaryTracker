//
//  ContentView.swift
//  SalaryTracking
//
//  Created by Nguyen Ngoc Thanh Lam on 11/7/2025.
//

import SwiftUI

// 1) create a model for a week
//WeekDay conforms to the Identifiable protocol. Identifiable requires a unique id property for each item so SwiftUI can efficiently manage and update views.
struct WeekDay: Identifiable {
    let id = UUID() //This generates a Universally Unique Identifier, Each `WeekDay` will have a different `id` value.
    let date: Date
    var hasShift: Bool
    var isToday: Bool { //Check if the day is today base on the user current calendar setting
        Calendar.current.isDateInToday(date)
    }
}

func getCurrentWeek() -> [WeekDay] {
    var calendar = Calendar.current // A var that holds the user's current calendar
    calendar.firstWeekday = 2 // Set the first day of the week to monday (sunday = 1)
    
    let today = Date() // Get the current day and time
    // 'guard let': a safe unwrapping. If it fails (return 'nil'), it exist early with 'return []'
    // Calculates the start and end of the current week that includes 'today', based on the calendar
    // Return a dayInterval with start and end
    // of: tell what time unit you want (.day, .weekOfYear, .month, .year, ect)
    // for: tell which day to look at
    guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
        return []
    }
    
    // create and return an array of 7 WeekDay objects, one for each day in a current week, starting from weekInterval.start
    // .compactMap: transform each offset into a weekDay, skip the nil values in the result. “For each number from 0 to 6, run the block inside, and collect the non-nil results into an array.”
    return(0..<7).compactMap { offset in
        // byAdding: add time to day (.day, .month, .year, .hour,...)
        // Adds the number of days (offset) to the start of the week.
        guard let day = calendar.date(byAdding: .day, value: offset, to: weekInterval.start) else {
            return nil
        }
        return WeekDay(date: day, hasShift: false)
    }
}

struct ContentView: View {
    
    @State private var selectedDate: Date?
    @State private var weekDays = getCurrentWeek()
    @State private var today = Date()

    var body: some View {
        Spacer()
        NavigationStack() {
            VStack(alignment: .leading) {
                Text(fullDayString(from: today))
                    .foregroundColor(.black)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                //            Form {
                HStack(spacing: 8) {
                    Spacer()
                    ForEach(weekDays) { day in
                        VStack {
                            Text(shortDayString(from: day.date))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(dayNumberString(from: day.date))
                                .font(.title2)
                                .fontWeight(day.isToday ? .bold : .regular)
                                .frame(width: 40, height: 40)
                                .background(day.date == selectedDate ? Color.blue : Color.clear)
                                .clipShape(Circle())
                                .foregroundColor(day.isToday ? .red : .primary)
                                .onTapGesture {
                                    selectedDate = day.date
                                    // check the array weekDays to find the index of the day that has the same date as the day i select
                                    if let index = weekDays.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: day.date)}) {
                                        weekDays[index].hasShift.toggle()
                                    }
                                }
                        }
                        .padding(.vertical, 15)
                        .background(day.hasShift ? Color.gray.opacity(0.8) : Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.yellow.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                Form {
                    Section(header: Text("Shift Details")) {
                        Text("")
                    }
                }
            }
            
            Spacer()
                
//                .padding()
                
//            }
            
            
        }
        
//        Spacer()
//        Spacer()
    }
    
    func shortDayString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return formatter.string(from: date)
        }

    func dayNumberString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    func fullDayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
