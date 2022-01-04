//
//  HomeViewController.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 28/04/2021.
//

import UIKit
import CoreData

struct Movie {
    let theName: String
    let amount: String
}

var movies: [Movie] = [
]


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountCollectionViewCell", for: indexPath) as! AccountCollectionViewCell
        cell.setup(with: movies[indexPath.row])
        setButtonTheme(cell: cell)
        cell.layer.cornerRadius = 13
        cell.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.set(movies[indexPath.row].theName, forKey: "timelineName")
        let amountGoal = movies[indexPath.row].amount
        let amountGoalArr = amountGoal.components(separatedBy: " ")
        let timelineAmount = amountGoalArr[0]
        let timelineGoal = amountGoalArr[2]
        defaults.set(timelineAmount, forKey: "timelineAmount")
        defaults.setValue(timelineGoal, forKey: "timelineGoal")
    }
    
    func fillArray(){
        movies.removeAll()
        checkCoreData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        request.returnsObjectsAsFaults = false
        var number = 0
        var arrayName = [String]()
        var arrayGoal = [Int]()
        var arrayAmount = [Int]()
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                arrayName.append(data.value(forKey: "name") as! String)
                arrayGoal.append(data.value(forKey: "goal") as! Int)
                arrayAmount.append(data.value(forKey: "currentAmount") as! Int)
                number = number + 1;
          }
        } catch {
            print("Failed")
        }
        
        if (number >= 1){
        for i in 1...number {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
            
                let stringTurn = String(arrayGoal[i - 1])
                let amountTurn = Int(stringTurn)!
                var formattedTurn = numberFormatter.string(from: NSNumber(value: amountTurn))
            
                let StringConvert = String(arrayAmount[i - 1])
                let amountConvert = Int(StringConvert)!
                let formattedConvert = numberFormatter.string(from: NSNumber(value: amountConvert))
            
            if (formattedTurn == "0"){
                formattedTurn = "∞"
            }
            
                var stringAmount = formattedConvert! + " / "
                stringAmount.append(formattedTurn!)
                movies.append(Movie(theName: arrayName[i - 1], amount: stringAmount))
        }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setAmount()
        checkCoreData()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView!.backgroundView = nil
        fillArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setAmount()
        reload()
        fillArray()
        checkFirstOpen()
        setBackground()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func checkFirstOpen(){
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "FirstTime") == true){
            welcomeLabel.text = "Welcome " + defaults.string(forKey: "Name")!
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Intro")
            self.present(vc, animated: true)
        }
    }
    
    func reload(){
        self.collectionView.reloadData()
    }
    
    func printDefaults(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    for data in result as! [NSManagedObject] {
                       print(data.value(forKey: "name") as! String)
                        print(data.value(forKey: "goal") as! Int)
                  }
                } catch {
                    print("Failed")
                }
    }
    
    func checkCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    var check = false
                    for data in result as! [NSManagedObject] {
                        let nameOfUser = data.value(forKey: "name") as! String
                        if(nameOfUser == "General"){
                            check = true
                        }
                  }
                    if(check == false){
                        addGeneral()
                    }
                } catch {
                    print("Failed")
                }
    }
    
    func addGeneral(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue("General", forKey: "name")
        newUser.setValue(0, forKey: "goal")
        newUser.setValue(0, forKey: "currentAmount")
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func setAmount(){
        if let amount = Foundation.UserDefaults.standard.string(forKey: "amount") {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let amountInt = Int(amount)!
            let formattedNumber = numberFormatter.string(from: NSNumber(value: amountInt))
            AmountTextLabel.text = ("£" + formattedNumber!)
        }
        else{
            AmountTextLabel.text = "£0"
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
    
    func setButtonTheme(cell: AccountCollectionViewCell){
        let defaults = UserDefaults.standard
        let background = defaults.string(forKey: "Colour")
        
        if (background == "Teal"){
            cell.backgroundColor = UIColor(red: 6/255, green: 172/255, blue: 201/255, alpha: 1)
        }
        else if (background == "Purple"){
            cell.backgroundColor = UIColor(red: 134/255, green: 34/255, blue: 143/255, alpha: 1)
        }
        else if (background == "Gray"){
            cell.backgroundColor = .systemGray2
        }
        else if (background == "Orange"){
            cell.backgroundColor = UIColor(red: 245/255, green: 106/255, blue: 0/255, alpha: 1)
        }
        else if (background == "Indigo"){
            cell.backgroundColor = UIColor(red: 81/255, green: 17/255, blue: 191/255, alpha: 1)
        }
        else if(background == "Sunset"){
            cell.backgroundColor = UIColor(red: 0/255, green: 147/255, blue: 75/255, alpha: 1)
        }
    }

    @IBOutlet weak var AmountTextLabel: UILabel!
    @IBOutlet weak var numberOfAccountsTextField: UILabel!
    @IBOutlet weak var ButtonStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
//    @IBAction func timelineButton(_ sender: Any) {
//        print("Timeline")
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
