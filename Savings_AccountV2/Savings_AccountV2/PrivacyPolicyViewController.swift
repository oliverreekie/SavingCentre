//
//  PrivacyPolicyViewController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 23/08/2021.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func searchLinkButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://github.com/oliverreekie/SavingCentre/blob/main/Privacy%20Policy")! as URL , options: [:], completionHandler: nil)
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
