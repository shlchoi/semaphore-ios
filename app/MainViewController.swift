//
//  MainViewController.swift
//  Semaphore
//
//  Created by Samson on 2017-02-15.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import UserNotifications
import BRYXBanner

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var currentMailboxLabel: UILabel!
    @IBOutlet weak var currentMailboxView: MailboxStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mailboxSelectorText: UITextField!

    var pickerView: UIPickerView!
    var databaseRef: FIRDatabaseReference!
    var auth: FIRAuth!
    var currentMailbox: Int = 0
    var mailboxes: [Mailbox] = []
    var deliveries: [Delivery] = []
    var isExpanded: [Bool] = []

    let cellReuseIdentifier = "delivery_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = FIRAuth.auth()

        if auth.currentUser == nil {
            self.logout()
            return
        }

        guard let userId = auth.currentUser?.uid else {
            self.logout()
            return
        }

        let lastMailboxId = SemaphoreUserDefaults.getLastMailbox()

        // Do any additional setup after loading the view, typically from a nib.
        databaseRef = FIRDatabase.database().reference()

        // Register the table view cell class and its reuse id
        let nib = UINib(nibName: "DeliveryTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)

        // This view controller itself will provide the delegate methods and row data for the table view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44

        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        self.mailboxSelectorText.inputView = pickerView

        databaseRef.child("users")
            .child(userId)
            .observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                if let userDictionary = snapshot.value as? NSDictionary {
                    let user = User(userDictionary)
                    self.mailboxes.removeAll()
                    let date = Calendar.current.date(byAdding: .day, value: -31, to: Date())

                    if let mailboxList = user.mailboxes {
                        for (_, mailboxDictionary) in mailboxList {
                            let mailbox = Mailbox(mailboxDictionary as! NSDictionary)
                            SemaphoreDatabase.insertMailbox(mailbox)
                            self.mailboxes.append(mailbox)

                            self.databaseRef.child("deliveries")
                                .child(mailbox.mailboxId)
                                .queryOrderedByKey()
                                .queryStarting(atValue: date?.timestamp)
                                .observe(.childAdded, with: { (snapshot) -> Void in
                                    if let deliveryDictionary = snapshot.value as? NSDictionary {
                                        let delivery = Delivery(deliveryDictionary)
                                        SemaphoreDatabase.insertDelivery(mailboxId: mailbox.mailboxId, delivery: delivery)
                                        self.loadDeliveries()
                                        if delivery.timestamp > SemaphoreUserDefaults.getLastDeliveryTime(mailbox.mailboxId) {
                                            SemaphoreUserDefaults.saveLastDeliveryTime(mailbox.mailboxId, timestamp: delivery.timestamp)
                                            self.notify(delivery, mailbox: mailbox)
                                        }
                                    }
                                })

                            self.databaseRef.child("deliveries")
                                .child(mailbox.mailboxId)
                                .queryOrderedByKey()
                                .queryStarting(atValue: date?.timestamp)
                                .observe(.childChanged, with: { (snapshot) -> Void in
                                    if let deliveryDictionary = snapshot.value as? NSDictionary {
                                        let delivery = Delivery(deliveryDictionary)
                                        SemaphoreDatabase.insertDelivery(mailboxId: mailbox.mailboxId, delivery: delivery)
                                        self.loadDeliveries()
                                        if delivery.timestamp > SemaphoreUserDefaults.getLastDeliveryTime(mailbox.mailboxId) {
                                            SemaphoreUserDefaults.saveLastDeliveryTime(mailbox.mailboxId, timestamp: delivery.timestamp)
                                            self.notify(delivery, mailbox: mailbox)
                                        }
                                    }
                                })


                            self.databaseRef.child("snapshots")
                                .child(mailbox.mailboxId)
                                .queryLimited(toLast: 1)
                                .observe(.childAdded, with: { (snapshot) -> Void in
                                    if let deliveryDictionary = snapshot.value as? NSDictionary {
                                        let delivery = Delivery(deliveryDictionary)
                                        SemaphoreUserDefaults.saveSnapshot(mailbox.mailboxId, snapshot: delivery)
                                        if mailbox.mailboxId == self.mailboxes[self.currentMailbox].mailboxId {
                                            self.updateCurrentView(delivery)
                                        }
                                    }
                                })

                            self.databaseRef.child("snapshots")
                                .child(mailbox.mailboxId)
                                .queryLimited(toLast: 1)
                                .observe(.childChanged, with: { (snapshot) -> Void in
                                    if let deliveryDictionary = snapshot.value as? NSDictionary {
                                        let delivery = Delivery(deliveryDictionary)
                                        SemaphoreUserDefaults.saveSnapshot(mailbox.mailboxId, snapshot: delivery)
                                        if mailbox.mailboxId == self.mailboxes[self.currentMailbox].mailboxId {
                                            self.updateCurrentView(delivery)
                                        }
                                    }
                                })

                            if mailbox.mailboxId == lastMailboxId {
                                self.currentMailbox = self.mailboxes.count - 1
                            }
                        }
                        self.pickerView.reloadComponent(0)
                    }

                    SemaphoreUserDefaults.saveMailboxList(self.mailboxes)
                    self.loadDeliveries()
                }
            })
    }

    func loadDeliveries() {
        let mailbox = self.mailboxes[self.currentMailbox]
        SemaphoreUserDefaults.saveLastMailbox(mailbox.mailboxId)
        self.clearNotifications(mailbox.mailboxId)
        self.currentMailboxLabel.text = String.init(format: NSLocalizedString("main_current_header", comment: ""), mailbox.name)
        self.deliveries = SemaphoreDatabase.queryDeliveries(mailbox.mailboxId)
        self.isExpanded = [Bool](repeating: false, count: self.deliveries.count)
        self.tableView.reloadData()
        self.updateCurrentView(SemaphoreUserDefaults.getSnapshot(mailbox.mailboxId))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DeliveryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DeliveryTableViewCell
        cell.reset()

        let viewModel = DeliveryTransformer.toViewModel(self.deliveries[indexPath.row], position: indexPath.row)
        viewModel.bind(cell)

        if self.isExpanded[indexPath.row] {
            cell.expand()
        } else {
            cell.collapse()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isExpanded[indexPath.row] = !self.isExpanded[indexPath.row]
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isExpanded[indexPath.row] {
            let delivery = self.deliveries[indexPath.row]
            let visibleRows = (delivery.letters > 0 ? 1 : 0)
                + (delivery.magazines > 0 ? 1 : 0)
                + (delivery.newspapers > 0 ? 1 : 0)
                + (delivery.parcels > 0 ? 1 : 0)

            return CGFloat(44 + (visibleRows * 28) + 4)
        } else {
            return 44
        }
    }

    private func updateCurrentView(_ delivery: Delivery?) {
        let viewModel = DeliveryTransformer.toViewModel(delivery, position: 0)
        viewModel.bind(currentView: currentMailboxView)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mailboxes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mailboxes[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mailboxSelectorText.resignFirstResponder()
        if self.mailboxes[self.currentMailbox].mailboxId != self.mailboxes[row].mailboxId {
            self.currentMailbox = row
            self.loadDeliveries()
        }
    }

    @IBAction func onMenuClick() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        }))

        if mailboxes.count > 1 {
            actionSheet.addAction(UIAlertAction(title: "Change Mailbox", style: .default, handler: { (action) -> Void in
                //TODO: dialog to change mailbox
                self.mailboxSelectorText.becomeFirstResponder()
                self.pickerView.selectRow(self.currentMailbox, inComponent: 0, animated: false)
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) -> Void in
            self.logout()
            actionSheet.dismiss(animated: true, completion: nil)
        }))

        present(actionSheet, animated: true, completion: nil)
    }

    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "LogoutSegue", sender: self)
    }

    func notify(_ delivery: Delivery, mailbox: Mailbox) {
        var message = String()
        if (delivery.categorising) {
            message = String.localizedStringWithFormat(NSLocalizedString("notification_categorising", comment: ""), SemaphoreUserDefaults.getMailboxName(mailbox.mailboxId)!)
        } else if (delivery.total == 0) {
            return
        } else {
            message = String.localizedStringWithFormat(NSLocalizedString("notification_text", comment: ""), delivery.total, SemaphoreUserDefaults.getMailboxName(mailbox.mailboxId)!)
        }
        let subtitle = mailbox.mailboxId == self.mailboxes[self.currentMailbox].mailboxId ? nil : "Click here to view mailbox"

        let banner = Banner(title: message, subtitle: subtitle, image: #imageLiteral(resourceName: "ic_logo"), backgroundColor: UIColor.SemaphoreBlue)

        if mailbox.mailboxId != self.mailboxes[self.currentMailbox].mailboxId {
            banner.didTapBlock = { (Void) in
                self.currentMailbox = self.mailboxes.index(of: mailbox) ?? self.currentMailbox
                self.loadDeliveries()
                banner.dismiss()
                }
        }

        banner.didDismissBlock = { (Void) in
            self.clearNotifications(mailbox.mailboxId)
        }
        banner.dismissesOnTap = true
        banner.dismissesOnSwipe = true
        banner.show(duration: 5.0)
    }

    func clearNotifications(_ mailboxId: String) {
        if UIApplication.shared.applicationState == .background {
            return
        }
        let badge: Int = UIApplication.shared.applicationIconBadgeNumber - 1
        if #available(iOS 10.0, *) {
            // remove badge
            let content = UNMutableNotificationContent()
            content.badge = max(badge, 0) as NSNumber
            let request = UNNotificationRequest(identifier: mailboxId, content: content, trigger: nil)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = max(badge, 0)
        }
    }
}
