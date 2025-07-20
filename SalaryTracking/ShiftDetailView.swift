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
    var totalPaidHours: Double {
        return totalHours <= 5 ? totalHours : totalHours - 0.5
    }
    var payPerHour: Double
    var totalSalary: Double {
        return totalPaidHours * payPerHour
    }
    
    mutating func setSalary(_ salary: Double) {
        self.payPerHour = salary
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
    
    @Environment(\.dismiss) private var dismiss
    
    let day: Date
    
    @Binding var onSave: Bool
    @Binding var shiftInfo: ShiftInfo
    
    @State private var shiftStart: Date = .now
    @State private var shiftEnd: Date = .now
    @State private var showingAlert = false
    @State private var gotPaid: Double = 22.2
    
    
    let isDelete: () -> Void
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Shift for \(formattedDate(day))")
                        .font(.headline)
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
            
            Section("pay per hour") {
                TextField("Amount", value: $gotPaid, format: .currency(code: Locale.current.currency?.identifier ?? "AUD"))
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button("Delete shift") {
                    showingAlert = true
                }
            }
        }
        .onAppear {
            shiftStart = shiftInfo.startTime
            shiftEnd = shiftInfo.endTime
            gotPaid = shiftInfo.payPerHour
        }
        .navigationTitle("Edit shift details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    onSave = true
                    shiftInfo = ShiftInfo(startTime: shiftStart, endTime: shiftEnd, payPerHour: gotPaid)
                    dismiss()
                }
            }
        }
        .alert("Delete?", isPresented: $showingAlert) {
            Button("Cancle", role: .cancel) {}
            Button("OK", role: .destructive) {
                isDelete()
                dismiss()
            }
        } message: {
            Text("Do you want to delete this shift?")
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
