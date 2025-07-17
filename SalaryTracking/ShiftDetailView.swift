//
//  ShiftDetailView.swift
//  SalaryTracking
//
//  Created by Nguyen Ngoc Thanh Lam on 12/7/2025.
//

import SwiftUI

struct ShiftInfo: Equatable {
    var startTime: Date
    var endTime: Date
    var totalHours: Double {
        return endTime.timeIntervalSince(startTime) / 3600
    }
    var payPerHour: Double
    var totalSalary: Double {
        return totalHours <= 5 ?
        totalHours * payPerHour
        : (totalHours - 0.5) * payPerHour
    }
}

struct ShiftDetailView: View {
    static var defaultStartTime: Date {
        var component = DateComponents()
        component.hour = 10
        component.minute = 30
        return Calendar.current.date(from: component) ?? .now
    }
    
    static var defaultEndTime: Date {
        var component = DateComponents()
        component.hour = 17
        component.minute = 0
        return Calendar.current.date(from: component) ?? .now
    }
    
    let day: Date
    
    @Binding var onSave: Bool
    @Binding var shiftInfo: ShiftInfo
    
    //    @State private var shiftStart = defaultStartTime
    //    @State private var shiftEnd = defaultEndTime
    
    @State private var shiftStart: Date = .now
    @State private var shiftEnd: Date = .now
    
    
    @State var change: Date? = nil
    
    var body: some View {
        Form {
            VStack {
                Text("Shift for \(formattedDate(day))")
                HStack {
                    Text("Shift starts at:")
                    Spacer()
                    DatePicker("Please select shift start time", selection: $shiftStart, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                HStack {
                    Text("Shift ends at:")
                    Spacer()
                    DatePicker("Please select shift end time", selection: $shiftEnd, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
        }
        .onAppear {
            shiftStart = shiftInfo.startTime
            shiftEnd = shiftInfo.endTime
        }
        .navigationTitle("Edit shift details")
        .toolbar {
            Button("Save") {
                onSave = true
                shiftInfo = ShiftInfo(startTime: shiftStart, endTime: shiftEnd, payPerHour: 22.2)
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
    

//#Preview {
//    ShiftDetailView()
//}
