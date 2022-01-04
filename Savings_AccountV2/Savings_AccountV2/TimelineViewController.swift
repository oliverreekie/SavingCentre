//
//  TimelineViewController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 28/07/2021.
//

import UIKit

class TimelineViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Open")
        weekLabel.text = ""
        monthLabel.text = ""
        defaults.data(forKey: "timelineName")
        accountNameLabel.text = defaults.string(forKey: "timelineName")
        currentLabel.text = defaults.string(forKey: "timelineAmount")
        goalLabel.text = defaults.string(forKey: "timelineGoal")
        calculateMonthly(date2: datePicker.date)
        calculateWeekly(date2: datePicker.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackground()
    }
    
    @IBAction func calculateButton(_ sender: Any) {
    }
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func pickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        //dateFormatter.timeStyle = DateFormatter.Style.short

        //let strDate = dateFormatter.string(from: datePicker.date)
        calculateMonthly(date2: datePicker.date)
        calculateWeekly(date2: datePicker.date)
    }
    
    func calculateWeekly(date2: Date){
        let goalString = defaults.string(forKey: "timelineGoal")!
        let goalText = goalString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        if (goalText == "∞"){
            weekLabel.text = "Set goal is infinite"
        }
        else{
            let goalNumber = Int(goalText)!
            let amountString = defaults.string(forKey: "timelineAmount")!
            let amountText = amountString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let amountNumber = Int(amountText)!
            let requiredNumber = (goalNumber - amountNumber)
            
            let date1 = Date()
            let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
            
            let intDiffs = Int(diffs.day!)
            let weekNumber = intDiffs / 7
            
            var weeklyValue = 0
            
            if(weekNumber == 0){
                weeklyValue = requiredNumber
            }
            else{
                weeklyValue = requiredNumber / weekNumber
            }
            
            weekLabel.text = String(weeklyValue)
            
            if(date1 == datePicker.date){
                weekLabel.text = "Choose a future date"
            }
            else if (Int(diffs.day!) <= 0){
                weekLabel.text = "Choose a future date"
            }
        
            if(amountNumber > goalNumber){
                weekLabel.text = "Goal already met"
            }
        }
    }
    func calculateMonthly(date2: Date){
        let goalString = defaults.string(forKey: "timelineGoal")!
        let goalText = goalString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        if (goalText == "∞"){
            monthLabel.text = "Set goal is infinite"
        }
        else{
            let goalNumber = Int(goalText)!
            
            let amountString = defaults.string(forKey: "timelineAmount")!
            let amountText = amountString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let amountNumber = Int(amountText)!
            let requiredNumber = (goalNumber - amountNumber)
            
            let date1 = Date()
            let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
            
            let intDiffs = Int(diffs.day!)
            let monthNumber = intDiffs / 30
            
            var monthlyValue = 0
            
            if(monthNumber == 0){
                monthlyValue = requiredNumber
            }
            else{
                monthlyValue = requiredNumber / monthNumber
            }
            monthLabel.text = String(monthlyValue)
            
            if(date1 == datePicker.date){
                monthLabel.text = "Choose a future date"
            }
            else if (Int(diffs.day!) <= 0){
                monthLabel.text = "Choose a future date"
            }
            
            if(amountNumber > goalNumber){
                monthLabel.text = "Goal already met"
            }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
