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

struct ShiftPreset: Identifiable {
    let id = UUID()
    let time: String
    let startHour: Int
    let startMinute: Int
    let endHour: Int
    let endMinute: Int
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
    
    let shiftPresets = [
        ShiftPreset(time: "3:30 pm - 10:00 pm", startHour: 15, startMinute: 30, endHour: 22, endMinute: 0),
        ShiftPreset(time: "5:00 pm - 10:00 pm", startHour: 17, startMinute: 0, endHour: 22, endMinute: 0),
        ShiftPreset(time: "2:30 pm - 11:30 pm", startHour: 14, startMinute: 30, endHour: 23, endMinute: 30),
        ShiftPreset(time: "3:30 pm - 11:30 pm", startHour: 15, startMinute: 30, endHour: 23, endMinute: 30),
        ShiftPreset(time: "5:30 pm - 11:30 pm", startHour: 17, startMinute: 30, endHour: 23, endMinute: 30),
        ShiftPreset(time: "2:30 pm - 10:30 pm", startHour: 14, startMinute: 30, endHour: 22, endMinute: 30),
        ShiftPreset(time: "5:30 pm - 10:30 pm", startHour: 17, startMinute: 30, endHour: 22, endMinute: 30)
    ]
    
    
    let isDelete: () -> Void
    
    var body: some View {
        Form {
            Section("Shift for \(formattedDate(day))") {
                VStack(alignment: .leading, spacing: 5) {                    HStack {
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
            
            Section("Quick selections") {
                ForEach(shiftPresets) { preset in
                    Button(preset.time) {
                        let calendar = Calendar.current
                        let today = Date()
                        var components = calendar.dateComponents([.year, .month, .day], from: today)
                        
                        components.hour = preset.startHour
                        components.minute = preset.startMinute
                        shiftStart = calendar.date(from: components) ?? today
                        
                        components.hour = preset.endHour
                        components.minute = preset.endMinute
                        shiftEnd = calendar.date(from: components) ?? today
                    }
                }
            }
            
            
            Section {
                HStack(alignment: .center) {
                    Spacer()
                    Button("Delete shift", role: .destructive) {
                        showingAlert = true
                    }
                    Spacer()
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
