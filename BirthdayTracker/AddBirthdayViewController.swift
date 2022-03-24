//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by MacBook on 23.03.2022.
//

import UIKit
import CoreData
import UserNotifications


class AddBirthdayViewController: UIViewController {
    
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdatePicker.maximumDate = Date()
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstNameTextField.text ?? ""
        newBirthday.lastName = lastNameTextField.text ?? ""
        newBirthday.birthdate = birthdatePicker.date as Date?
        newBirthday.birthdayId = UUID().uuidString
        do {
            try context.save()
            let message = "Сегодня \(firstNameTextField) \(lastNameTextField) празднует день рождения!"
            let content = UNMutableNotificationContent()
                content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdatePicker.date)
            dateComponents.hour = 8
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayId {
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                   let center = UNUserNotificationCenter.current()
                   center.add(request, withCompletionHandler: nil)
            }
        }
        catch let error {
            print("Не удалось сохранить из-за ошибки \(error).")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

