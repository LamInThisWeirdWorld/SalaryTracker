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
    
    @State private var selectedDate: Date? = nil
    @State private var showDetails: Bool = false
    @State private var weekDays = getCurrentWeek()
    @State private var today = Date()
    @State private var goToEdit: Bool = false
    

    var body: some View {
        NavigationStack() {
            ZStack(alignment: .top) {
                Color(hex: "F8F7F5")
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 10) {
                    Text(fullDayString(from: today))
                        .foregroundColor(Color(hex: "2D2848"))
                        .font(.largeTitle.bold())
                        .padding(.horizontal)
                    //            Form {
                    HStack(spacing: 8) {
                        //                    Spacer()
                        ForEach(weekDays) { day in
                            VStack {
                                Text(shortDayString(from: day.date))
                                    .font(.footnote)
                                    .foregroundColor(Color(hex: "2D2848"))
                                
                                Text(dayNumberString(from: day.date))
                                    .font(.title2)
                                    .fontWeight(day.isToday ? .bold : .regular)
                                    .frame(width: 40, height: 40)
                                    .background(Color.clear)
                                //                                .background(day.date == selectedDate ? Color.blue : Color.clear)
                                    .clipShape(Circle())
                                    .foregroundColor(day.isToday ? .red : .primary)
                                    .onTapGesture {
                                        withAnimation {
                                            if selectedDate == day.date {
                                                selectedDate = nil
                                                showDetails = false
                                            } else {
                                                selectedDate = day.date
                                                showDetails = true
                                            }
                                        }
                                        // check the array weekDays to find the index of the day that has the same date as the day i select
                                        //                                    if let index = weekDays.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: day.date)}) {
                                        //                                        weekDays[index].hasShift.toggle()
                                        //                                    }
                                    }
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedDate == day.date ? Color(hex: "F2D88F") : Color(hex: "EBF0FF").opacity(0.7))
                            //                        .background(day.hasShift ? Color.yellow.opacity(0.8) : Color.gray.opacity(0.1))
                            .clipShape(Capsule())
                        }
                        
                        //                    Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "A68CEE"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    
                    //                Form {
                    //                    Section(header: Text("Shift Details")) {
                    //                        Text("")
                    //                    }
                    //                }
                    
                    if showDetails, let selected = selectedDate {
                        VStack(alignment: .leading, spacing: 8) {
                            Button("+") {
                                goToEdit = true
                            }
                            .font(.title3.bold())
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(Color(hex: "2D2848"))
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            // viet tiep o day
                            // them navigationLink, se move to cai space do khi cai button dc an
                            // trong do se dung de cap nhat shift info
                            
                            
                            Text("Details for \(formattedDate(selected))")
                                .font(.headline)
                            Text("Shift Start: —")
                            Text("Shift End: —")
                            Text("Total Hours: —")
                            Text("Salary: —")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                Spacer()
            }
        }
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
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func adjustDetail() {
        
    }

}

#Preview {
    ContentView()
}
