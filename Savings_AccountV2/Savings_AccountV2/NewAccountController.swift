//
//  NewAccountController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 28/05/2021.
//

import UIKit
import CoreData

class NewAccountController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
        picker.delegate = self
        picker.dataSource = self
        title = "Add/Delete Account"
        setBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillArray()
        self.picker.reloadAllComponents()
    }
    
    @IBAction func saveNewAccountButton(_ sender: Any) {
        if(nameTextField.text != ""){
                if(goalTextField.text!.count <= 6){
                    if(nameTextField.text!.count <= 18){
                            checkExistingAccountName()
                    }
                    else{
                        let alert = UIAlertController(title: "Name character maximum reached", message: "The account name cannot be greater than 18 characters", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                else{
                    let alert = UIAlertController(title: "Goal maximum reached", message: "The goal value cannot be more than £999,999 please enter a lower value", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
        }
        else{
        let alert = UIAlertController(title: "Account name is empty", message: "The account 'Name' has been left blank, please enter an account name before continuing", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
        }
    }
    
    
    func checkExistingAccountName(){
        if(!colors.contains(nameTextField.text!)){
            addAccount()
        }
        else{
            let alert = UIAlertController(title: "Account name already exists", message: "An account with this name already exists, please cancel and use another name", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func addAccount(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(nameTextField.text, forKey: "name")
        
        if(goalTextField.text == ""){
            newUser.setValue(0, forKey: "goal")
        }
        else{
            let goalInt: Int? = Int(goalTextField.text!)
            newUser.setValue(goalInt, forKey: "goal")
        }
        newUser.setValue(0, forKey: "currentAmount")
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
        self.dismiss(animated: true, completion: nil)
        fillArray()
        self.picker.reloadAllComponents()
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
                    if(data.value(forKey: "name") as! String == "General"){

                    }
                    else{
                        colors.append(data.value(forKey: "name") as! String)
                        number = number + 1;
                    }
              }
            } catch {
                print("Failed")
            }
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func deleteButton(_ sender: Any) {
        let selectedValue = colors[picker.selectedRow(inComponent: 0)]
        
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
                    if (nameOfUser == selectedValue){
                        let amountOfUser = data.value(forKey: "currentAmount") as! Int
                        if (amountOfUser > 0) {
                            transferToGeneral(Amount: amountOfUser)
                        }
                        do {
                           context.delete(data)
                          }
                        try context.save()
                    }
                    number = number + 1;
              }
            } catch {
                print("Failed")
            }
        let alert = UIAlertController(title: "Account sucessfully deleted", message: "The account specified has been successfully deleted", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true)
        
        fillArray()
        self.picker.reloadAllComponents()
    }
    
    func transferToGeneral(Amount: Int){
        let alert = UIAlertController(title: "Account has remaining funds", message: "The account specified has funds remaining in it, these will be transferred to General", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
                request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                   let nameOfUser = data.value(forKey: "name") as! String
                    var goalOfUser = data.value(forKey: "currentAmount") as! Int
                    if (nameOfUser == "General"){
                        goalOfUser = goalOfUser + Amount
                        data.setValue(goalOfUser, forKey: "currentAmount")
                        do {
                           try context.save()
                          } catch {
                           print("Failed saving")
                        }
                    }
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
