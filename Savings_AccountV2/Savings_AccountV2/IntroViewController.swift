//
//  IntroViewController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 14/07/2021.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func continueButton(_ sender: Any) {
        if(nameTextField.text != ""){
        let defaults = UserDefaults.standard
        defaults.set(nameTextField.text, forKey: "Name")
        defaults.set(true, forKey: "FirstTime")
        self.dismiss(animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Name is empty", message: "The field 'Name' is empty, please enter a name before continuing", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
