//
//  TransferController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 21/06/2021.
//

//import Foundation
import UIKit
import CoreData


class TransferController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    var colors = ["Red","Yellow","Green","Blue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    
        fromPicker.delegate = self
        fromPicker.dataSource = self
        toTextField.delegate = self
        toTextField.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillArray()
        self.fromPicker.reloadAllComponents()
        self.toTextField.reloadAllComponents()
        setBackground()
    }
    
    func fillArray(){
        colors.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                var number = 0
                for data in result as! [NSManagedObject] {
                    colors.append(data.value(forKey: "name") as! String)
                    number = number + 1;
              }
            } catch {
                print("Failed")
            }
    }
    
    @IBOutlet weak var insertTextField: UITextField!
    
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toTextField: UIPickerView!
    
    @IBAction func transferButton(_ sender: Any) {
        if (insertTextField.text != ""){
            print ("Button Pressed")
            checkBalance()
            insertTextField.text = ""
        }
        else{
            let alert = UIAlertController(title: "Amount is empty", message: "The amount to transfer has been left blank, please enter an amount before continuing", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func checkBalance(){
        let selectedValue = colors[fromPicker.selectedRow(inComponent: 0)]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
                request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                   let nameOfUser = data.value(forKey: "name") as! String
                    let goalOfUser = data.value(forKey: "currentAmount") as! Int
                    if (nameOfUser == selectedValue){
                        if(goalOfUser < Int(insertTextField.text!)!){
                            let alert = UIAlertController(title: "Not enough funds", message: "The account specified does not have the funds to transfer. Please choose another account before continuing", preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        else{
                            minusAmount()
                            addAmount()
                        }
                    }
              }
            } catch {
                print("Failed")
            }
    }
    
    func minusAmount(){
        let selectedValue = colors[fromPicker.selectedRow(inComponent: 0)]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
                request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                var number = 0
                for data in result as! [NSManagedObject] {
                   let nameOfUser = data.value(forKey: "name") as! String
                    var goalOfUser = data.value(forKey: "currentAmount") as! Int
                    if (nameOfUser == selectedValue){
                        goalOfUser = goalOfUser - Int(insertTextField.text!)!
                        if(goalOfUser <= 0){
                            goalOfUser = 0
                        }
                        data.setValue(goalOfUser, forKey: "currentAmount")
                        do {
                           try context.save()
                          } catch {
                           print("Failed saving")
                        }
                    }
                    print(data.value(forKey: "goal") as! Int)
                    number = number + 1;
              }
            } catch {
                print("Failed")
            }
    }
    
    func addAmount(){
        let selectedValue = colors[toTextField.selectedRow(inComponent: 0)]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
                request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                var number = 0
                for data in result as! [NSManagedObject] {
                   let nameOfUser = data.value(forKey: "name") as! String
                    var goalOfUser = data.value(forKey: "currentAmount") as! Int
                    if (nameOfUser == selectedValue){
                        goalOfUser = goalOfUser + Int(insertTextField.text!)!
                        data.setValue(goalOfUser, forKey: "currentAmount")
                        do {
                           try context.save()
                          } catch {
                           print("Failed saving")
                        }
                    }
                    print(data.value(forKey: "goal") as! Int)
                    number = number + 1;
              }
            } catch {
                print("Failed")
            }
    }
    
    func setBackground(){
        let defaults = UserDefaults.standard
        let background = defaults.string(forKey: "Colour")
        
        if(background == "Pink"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemPink
        }
        else if (background == "Teal"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemTeal
        }
        else if (background == "Purple"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemPurple
        }
        else if (background == "Gray"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemGray
        }
        else if (background == "Orange"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemOrange
        }
        else if (background == "Indigo"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemIndigo
        }
        else if(background == "Sunset"){
            backgroundImage.isHidden = false
        }
        
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
}
