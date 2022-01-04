//
//  WithdrawViewController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 28/04/2021.
//

import UIKit
import CoreData

class WithdrawViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
        //UserDefaults.standard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        picker.delegate = self
        picker.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func WithdrawButtonPressed(_ sender: Any) {
        if(insertBox.text != ""){
        print ("Button Pressed")
            checkBalance()
            insertBox.text = ""
        }
        else{
            let alert = UIAlertController(title: "Amount is empty", message: "The amount to withdraw has been left blank, please enter an amount before continuing", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func addToTotal(){
        if let amount = Foundation.UserDefaults.standard.string(forKey: "amount") {
            if let getAmount = insertBox.text{
                let oldAmount = Int(amount)
                var newAmount = oldAmount! - Int(getAmount)!
                if newAmount <= 0{
                    newAmount = 0;
                }
                Foundation.UserDefaults.standard.set(newAmount, forKey: "amount")
            }
        }
    }
    
    func checkBalance(){
        let selectedValue = colors[picker.selectedRow(inComponent: 0)]
        
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
                        if(goalOfUser < Int(insertBox.text!)!){
                            let alert = UIAlertController(title: "Not enough funds", message: "The account specified does not have the funds to withdraw. Please transfer the required funds before continuing", preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        else{
                            withdrawFromCurrentAmount()
                            addToTotal()
                        }
                    }
              }
            } catch {
                print("Failed")
            }
    }
    
    func withdrawFromCurrentAmount(){
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
                    var goalOfUser = data.value(forKey: "currentAmount") as! Int
                    if (nameOfUser == selectedValue){
                        goalOfUser = goalOfUser - Int(insertBox.text!)!
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
    
    override func viewWillAppear(_ animated: Bool) {
        fillArray()
        self.picker.reloadAllComponents()
        setBackground()
    }
    
    func textFieldShouldReturn(_textField: UITextField) -> Bool {
        _textField.resignFirstResponder()
        return true;
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
    
    @IBOutlet weak var insertBox: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
