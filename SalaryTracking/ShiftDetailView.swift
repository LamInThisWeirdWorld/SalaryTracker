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
        return (totalHours - 0.5) * payPerHour
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
    @Binding var shiftInfo: ShiftInfo
    
//    @Binding var day: Date?
    
    @State private var shiftStart = defaultStartTime
    @State private var shiftEnd = defaultEndTime
    @State var doneEdit = false
    
    @State private var change: Date? = nil
    
    var body: some View {
        Form {
            VStack {
                Text("Shift for \(formattedDate(day))")
//                DatePicker("Please select shift start time", selection: $change, displayedComponents: .date)
//                    .labelsHidden()
                HStack {
                    Text("Shift starts at:")
                    Spacer()
//                    DatePicker("Please select shift start time", selection: $shiftStart, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                    DatePicker("Please select shift start time", selection: $shiftInfo.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                HStack {
                    Text("Shift ends at:")
                    Spacer()
//                    DatePicker("Please select shift start time", selection: $shiftEnd, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                    DatePicker("Please select shift start time", selection: $shiftInfo.endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
        }
        .navigationTitle("Edit shift details")
        .toolbar {
            Button("Save") {
                doneEdit = true
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func saveData() {
        
    }
    
//    func initShiftInfo() -> ShiftInfo {
//        var component = DateComponents()
//        component.hour = 10
//        component.minute = 30
//        let startTime = Calendar.current.date(from: component) ?? .now
//        component.hour = 17
//        let endTime = Calendar.current.date(from: component) ?? .now
//    }
}

//#Preview {
//    ShiftDetailView()
//}
