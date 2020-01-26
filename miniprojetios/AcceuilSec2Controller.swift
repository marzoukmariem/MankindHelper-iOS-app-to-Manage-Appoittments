//
//  AcceuilSec2Controller.swift
//  miniprojetios
//
//  Created by ESPRIT on 25/04/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import Google
import GoogleSignIn

class AcceuilSec2Controller: UIViewController,  UITableViewDelegate, UITableViewDataSource ,GIDSignInDelegate, GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var refreshControl: UIRefreshControl!
    var idCabinet:String?
    var tvShowArray : NSArray = []
    var AllArray : NSArray = []
    @IBOutlet weak var labelPasRdv: UILabel!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllArray.count
    }
    
    @IBAction func deconnection(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        performSegue(withIdentifier: "returnToLogin", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        let contentView = cell?.viewWithTag(0)
        
        let nomEtPrenom = contentView?.viewWithTag(2) as! UILabel
        let date = contentView?.viewWithTag(3) as! UILabel
        let url:String?
        let tvShowDict = AllArray[indexPath.row] as! Dictionary<String, Any>
        nomEtPrenom.text = (tvShowDict["Nom_User"] as! String ) + " " + (tvShowDict["Prenom_User"] as! String)
        
        
        let lowerBound = String.Index.init(encodedOffset: 0)
        let upperBound = String.Index.init(encodedOffset: 10)
        
        date.text = String((tvShowDict["dateRendezvous"] as! String )[lowerBound..<upperBound])
        let temp = contentView?.viewWithTag(4) as! UILabel
        let lowerBound2 = String.Index.init(encodedOffset: 11)
        let upperBound2 = String.Index.init(encodedOffset: 16)
        
        temp.text = String((tvShowDict["dateRendezvous"] as! String )[lowerBound2..<upperBound2])
        
        //titre.text = names[indexPath.row] as! String
        
        
        
        return cell!
    }
    
    var idPatient:String = ""
    var nomPatient:String = ""
    var prenomPatient:String = ""
    var numTelPatient:String = ""
    var dateNaissancePatient:String = ""
    var professionPatient:String = ""
    var imagePatient:String = ""
    var idRendezvous:String = ""
    var date:String = ""
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toRdvDateSelect", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRdvDateSelect"{
            let DVC = segue.destination as! RdvUpdateController
            
            
            
            
            
            let index = sender as! IndexPath
            
            let tvShowDict = AllArray[index.row] as! Dictionary<String, Any>
            
            idRendezvous = (tvShowDict["Id_Rendezvous"] as! String )
            prenomPatient = (tvShowDict["Prenom_User"] as! String )
            nomPatient = (tvShowDict["Nom_User"] as! String )
            date = (tvShowDict["dateRendezvous"] as! String )
            
            
            DVC.idRendezvous = self.idRendezvous
            DVC.prenomPatient = self.prenomPatient
            DVC.nomPatient = self.nomPatient
            DVC.date = self.date
            
        }}
    
    
    
    var selectedDay: String = ""
    var selectedMonth: String = ""
    var selectedYear: String = ""
    
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    
    
    
    private var datePicker : UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AcceuilSecController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AcceuilSecController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        inputTextField.inputView = datePicker
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let someDateTime = dateFormatter.string(from: Date())
        inputTextField.text = someDateTime
        selectedDay = String((someDateTime as! String )[String.Index.init(encodedOffset: 8)..<String.Index.init(encodedOffset: 10)])
        print("selectedday" + selectedDay)
        selectedMonth = String((someDateTime as! String )[String.Index.init(encodedOffset: 5)..<String.Index.init(encodedOffset: 7)])
        print("selectedMoth" + selectedMonth)
        selectedYear = String((someDateTime as! String )[String.Index.init(encodedOffset: 0)..<String.Index.init(encodedOffset: 4)])
        print("selectedYear" + selectedYear)
        
        
        print("http://41.226.11.252:1180/medichelper/getallrendezvous.php?idCabinet=" + idCabinet!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/getallrendezvous.php?idCabinet=" + idCabinet!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            
            
            
            
            for g in self.tvShowArray{
                print("haaaa")
                let gdict =  g as! Dictionary<String, Any>
                let lowerBound = String.Index.init(encodedOffset: 0)
                let upperBound = String.Index.init(encodedOffset: 10)
                
                let test = String((gdict["dateRendezvous"] as! String )[lowerBound..<upperBound])
                print(" here "+test)
                var selectedDayR: String = ""
                var selectedMonthR: String = ""
                var selectedYearR: String = ""
                selectedDayR = String((gdict["dateRendezvous"] as! String)[String.Index.init(encodedOffset: 8)..<String.Index.init(encodedOffset: 10)])
                print("selecteddayR" + selectedDayR)
                selectedMonthR = String((gdict["dateRendezvous"] as! String )[String.Index.init(encodedOffset: 5)..<String.Index.init(encodedOffset: 7)])
                print("selectedMothR" + selectedMonthR)
                selectedYearR = String((gdict["dateRendezvous"] as! String)[String.Index.init(encodedOffset: 0)..<String.Index.init(encodedOffset: 4)])
                print("selectedYearR" + selectedYearR)
                
                if(selectedDayR.elementsEqual(self.selectedDay) && selectedMonthR.elementsEqual(self.selectedMonth) && selectedYearR.elementsEqual(self.selectedYear) ){
                    print("pppppppppppppppp")
                    self.AllArray=self.AllArray.adding(g) as NSArray
                }
                
            }
            print(self.AllArray)
            self.tableView.reloadData()
            
            if (self.AllArray.count > 0){
                self.labelPasRdv.isHidden = true
                
            }else{
                self.labelPasRdv.isHidden = false
            }
        }
        
        
        
        
        //titre.text = names[indexPath.row] as! String
        
        
        
        
        
    }
    
    @objc func refresh(_ sender: Any) {
        self.AllArray = []
        print("http://41.226.11.252:1180/medichelper/getallrendezvous.php?idCabinet=" + idCabinet!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/getallrendezvous.php?idCabinet=" + idCabinet!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            
            
            
            
            for g in self.tvShowArray{
                print("haaaa")
                let gdict =  g as! Dictionary<String, Any>
                let lowerBound = String.Index.init(encodedOffset: 0)
                let upperBound = String.Index.init(encodedOffset: 10)
                
                let test = String((gdict["dateRendezvous"] as! String )[lowerBound..<upperBound])
                print(" here "+test)
                var selectedDayR: String = ""
                var selectedMonthR: String = ""
                var selectedYearR: String = ""
                selectedDayR = String((gdict["dateRendezvous"] as! String)[String.Index.init(encodedOffset: 8)..<String.Index.init(encodedOffset: 10)])
                print("selecteddayR" + selectedDayR)
                selectedMonthR = String((gdict["dateRendezvous"] as! String )[String.Index.init(encodedOffset: 5)..<String.Index.init(encodedOffset: 7)])
                print("selectedMothR" + selectedMonthR)
                selectedYearR = String((gdict["dateRendezvous"] as! String)[String.Index.init(encodedOffset: 0)..<String.Index.init(encodedOffset: 4)])
                print("selectedYearR" + selectedYearR)
                
                if(selectedDayR.elementsEqual(self.selectedDay) && selectedMonthR.elementsEqual(self.selectedMonth) && selectedYearR.elementsEqual(self.selectedYear) ){
                    print("pppppppppppppppp")
                    self.AllArray=self.AllArray.adding(g) as NSArray
                }
                
            }
            print(self.AllArray)
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            
            if (self.AllArray.count > 0){
                self.labelPasRdv.isHidden = true
                
            }else{
                self.labelPasRdv.isHidden = false
            }
        }
    }
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        self.AllArray = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        inputTextField.text = dateFormatter.string(from: datePicker.date)
        
        
        selectedDay = String((inputTextField.text as! String )[String.Index.init(encodedOffset: 8)..<String.Index.init(encodedOffset: 10)])
        print("selectedday" + selectedDay)
        selectedMonth = String((inputTextField.text as! String )[String.Index.init(encodedOffset: 5)..<String.Index.init(encodedOffset: 7)])
        print("selectedMoth" + selectedMonth)
        selectedYear = String((inputTextField.text as! String )[String.Index.init(encodedOffset: 0)..<String.Index.init(encodedOffset: 4)])
        print("selectedYear" + selectedYear)
        
        for g in self.tvShowArray{
            print("haaaa")
            let gdict =  g as! Dictionary<String, Any>
            let lowerBound = String.Index.init(encodedOffset: 0)
            let upperBound = String.Index.init(encodedOffset: 10)
            
            let test = String((gdict["dateRendezvous"] as! String )[lowerBound..<upperBound])
            print(" here "+test)
            var selectedDayR: String = ""
            var selectedMonthR: String = ""
            var selectedYearR: String = ""
            selectedDayR = String((gdict["dateRendezvous"] as! String)[String.Index.init(encodedOffset: 8)..<String.Index.init(encodedOffset: 10)])
            print("selecteddayR" + selectedDayR)
            selectedMonthR = String((gdict["dateRendezvous"] as! String )[String.Index.init(encodedOffset: 5)..<String.Index.init(encodedOffset: 7)])
            print("selectedMothR" + selectedMonthR)
            selectedYearR = String((gdict["dateRendezvous"] as! String)[String.Index.init(encodedOffset: 0)..<String.Index.init(encodedOffset: 4)])
            print("selectedYearR" + selectedYearR)
            
            if(selectedDayR.elementsEqual(self.selectedDay) && selectedMonthR.elementsEqual(self.selectedMonth) && selectedYearR.elementsEqual(self.selectedYear) ){
                print("pppppppppppppppp")
                self.AllArray=self.AllArray.adding(g) as NSArray
            }
            
        }
        print(self.AllArray)
        self.tableView.reloadData()
        
        view.endEditing(true)
        
        if (self.AllArray.count > 0){
            self.labelPasRdv.isHidden = true
            
        }else{
            self.labelPasRdv.isHidden = false
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
