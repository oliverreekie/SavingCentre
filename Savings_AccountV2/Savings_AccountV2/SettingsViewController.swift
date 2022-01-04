//
//  SettingsViewController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 13/07/2021.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    var colors = ["Teal","Purple","Gray", "Orange", "Indigo", "Sunset"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        picker.delegate = self
        picker.dataSource = self
        setBackground()
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func updateButton(_ sender: Any) {
        if(nameTextField.text != ""){
            if(nameTextField.text!.count <= 10){
                let defaults = UserDefaults.standard
                defaults.set(nameTextField.text, forKey: "Name")
                let alert = UIAlertController(title: "Name Updated", message: "The account name has been updated", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else{
                let alert = UIAlertController(title: "Name is too long", message: "The account name must not be longer than 10 characters", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else{
            let alert = UIAlertController(title: "Name is Empty", message: "The field 'Name' has been left empty, please enter a name before continuing", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        nameTextField.text = ""
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func themeButton(_ sender: Any) {
        let selectedValue = colors[picker.selectedRow(inComponent: 0)]
        if (selectedValue == "Teal"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemTeal
        }
        else if (selectedValue == "Purple"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemPurple
        }
        else if (selectedValue == "Gray"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemGray
        }
        else if (selectedValue == "Orange"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemOrange
        }
        else if (selectedValue == "Indigo"){
            backgroundImage.isHidden = true
            self.view.backgroundColor = .systemIndigo
        }
        else if(selectedValue == "Sunset"){
            backgroundImage.isHidden = false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(selectedValue, forKey: "Colour")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
