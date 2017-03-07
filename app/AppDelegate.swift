//
//  AppDelegate.swift
//  Semaphore
//
//  Created by Samson on 2017-02-14.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure();

        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        SemaphoreDatabase.create()

        if #available(iOS 10.0, *) {
            // request or register for user notifications
            // todo: save if user agreed/disagreed
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    NSLog("Request authorization succeeded!")
                }
            }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        return true
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        let auth = FIRAuth.auth()!

        if auth.currentUser == nil {
            return completionHandler(.noData)
        }

        let databaseRef = FIRDatabase.database().reference()
        let mailboxes = SemaphoreUserDefaults.getMailboxList()
        if mailboxes.count == 0 {
            return completionHandler(.noData)
        }

        var complete = [String]()

        mailboxes.forEach( { (mailboxId) -> Void in
            let lastTime = SemaphoreUserDefaults.getLastDeliveryTime(mailboxId)
            databaseRef.child("deliveries")
                .child(mailboxId)
                .queryLimited(toLast: 1)
                .observeSingleEvent(of: .childAdded, with: { (snapshot) -> Void in
                    if let deliveryDictionary = snapshot.value as? NSDictionary {
                        let delivery = Delivery(deliveryDictionary)
                        if (delivery.timestamp > lastTime) {
                            var message = String()
                            if (delivery.categorising) {
                                message = String.localizedStringWithFormat(NSLocalizedString("notification_categorising", comment: ""), SemaphoreUserDefaults.getMailboxName(mailboxId)!)
                            } else if (delivery.total == 0) {
                                return
                            } else {
                                message = String.localizedStringWithFormat(NSLocalizedString("notification_text",comment: ""), delivery.total, SemaphoreUserDefaults.getMailboxName(mailboxId)!)
                            }
                            let title = NSLocalizedString("notification_title", comment: "")

                            if #available(iOS 10.0, *) {
                                let content = UNMutableNotificationContent()
                                content.title = title
                                content.body = message
                                content.badge = 1
                                content.sound = UNNotificationSound.default()

                                let request = UNNotificationRequest(identifier: mailboxId, content: content, trigger: nil)
                            
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                UNUserNotificationCenter.current().add(request)
                            } else {
                                let localNotification = UILocalNotification()
                                localNotification.alertTitle = title
                                localNotification.alertBody = message

                                UIApplication.shared.scheduleLocalNotification(localNotification)
                            }
                        }
                    }
                    complete.append(mailboxId)
                    if complete.count == mailboxes.count {
                        return completionHandler(.newData)
                    }
                })
        })
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // todo: listen and make alerts here
    }
}

