//
//  NotificationView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    @State var notificationAllowed = true
    
    func updateNotificationStatus() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                notificationAllowed = true
            }
        }
    }
    var body: some View {
        VStack {
            HStack {
                Text("Notification")
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
                Button("test") {
                    notificationAllowed.toggle()
                }
            }
            .onAppear {
                print("notification")
                updateNotificationStatus()
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    notificationAllowed = success
                }
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
            if notificationAllowed == true {
                Button("Settings") {
                    let content = UNMutableNotificationContent()
                    content.title = "test"
                    content.subtitle = "testtest"
                    content.sound = UNNotificationSound.default
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(), repeats: true)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request)
                }
            } else {
                Text("You choose not to use notifications. You won't be notified if you haven't recorded a saving. If you decide to enable notification at a later time, you can always change it in system settings. ")
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
