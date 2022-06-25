//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Anna Stavro on 2.04.22.
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
        // Do any additional setup after loading the view.
        birthdatePicker.maximumDate = Date()
    }
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
     
   // print("The save button was tapped.")
        
       let firstName = firstNameTextField.text ?? ""
       let lastName = lastNameTextField.text ?? ""
//        print("My name is \(firstName) \(lastName).")
       let birthdate = birthdatePicker.date
//        print("My birthday is \(birthdate).")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as Date?
        newBirthday.birthdayId = UUID().uuidString
        if let uniqueId = newBirthday.birthdayId {
            
            print("The birthdayId is: \(uniqueId)")
        }
        do{
            try context.save()
            
            let message = "Wish \(firstName) \(lastName) a Happy Birthday today!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            
            var dateComponents = Calendar.current.dateComponents([.month,.day], from: birthdate)
            dateComponents.hour = 8
          //  dateComponents.minute = 45
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            
            if let identifier = newBirthday.birthdayId {
                let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
            
            
        } catch let error {
            
            print("Could not save because of \(error).")
            
        }
            
        
        dismiss(animated: true, completion: nil)
        
        print("Created a Birthday!")
        print("First Name: \(newBirthday.firstName)")
        print("Last Name: \(newBirthday.lastName)")
        print("Birthdate: \(newBirthday.birthdate)")
        
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
    }


}

