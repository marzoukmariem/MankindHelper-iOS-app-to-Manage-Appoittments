//
//  AcceuilSecController.swift
//  miniprojetios
//
//  Created by maryem on 4/13/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire

class AcceuilSecController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var labelPasRdv: UILabel!
    var tvShowArray : NSArray = []
    var AllArray : NSArray = []
    var idCabinet:String?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        let contentView = cell?.viewWithTag(0)
        let img = contentView?.viewWithTag(1) as! UIImageView
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.height/2
        img.clipsToBounds = true
        let nomEtPrenom = contentView?.viewWithTag(2) as! UILabel
        let date = contentView?.viewWithTag(3) as! UILabel
        let url:String?
        let tvShowDict = AllArray[indexPath.row] as! Dictionary<String, Any>
        nomEtPrenom.text = (tvShowDict["Nom_User"] as! String ) + " " + (tvShowDict["Prenom_User"] as! String)
        url = "http://41.226.11.252:1180/medichelper/" + (tvShowDict["UrlImage_Patient"] as! String)
        img.af_setImage(withURL: URL(string: url!)!)
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
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     performSegue(withIdentifier: "toRdvDateSelect", sender: indexPath)
     
     }*/
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "toFiche"{
     let DVC = segue.destination as! FichePatientController
     
     
     
     
     
     let index = sender as! IndexPath
     
     let tvShowDict = AllArray[index.row] as! Dictionary<String, Any>
     
     idPatient = (tvShowDict["Id_User"] as! String )
     imagePatient = (tvShowDict["UrlImage_Patient"] as! String )
     professionPatient = (tvShowDict["Cin_Patient"] as! String )
     prenomPatient = (tvShowDict["Prenom_User"] as! String )
     nomPatient = (tvShowDict["Nom_User"] as! String )
     numTelPatient = (tvShowDict["NumTel_User"] as! String )
     dateNaissancePatient = (tvShowDict["DateNaissance_User"] as! String )
     print("performSegue"+idPatient)
     DVC.idPatient = self.idPatient
     DVC.imagePatient = self.imagePatient
     DVC.professionPatient = self.professionPatient
     DVC.prenomPatient = self.prenomPatient
     DVC.nomPatient = self.nomPatient
     DVC.numTelPatient = self.numTelPatient
     DVC.dateNaissancePatient = self.dateNaissancePatient
     
     }}*/
    
    
    
    var selectedDay: String = ""
    var selectedMonth: String = ""
    var selectedYear: String = ""
    
   
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    ///////////////////////////////////////////////////////
    
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
        
        
        print("http://41.226.11.252:1180/medichelper/gettallredsmedecin.php?idCabinet="+self.idCabinet!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/gettallredsmedecin.php?idCabinet="+self.idCabinet!).responseJSON { response in
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

        print("http://41.226.11.252:1180/medichelper/gettallredsmedecin.php?idCabinet="+self.idCabinet!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/gettallredsmedecin.php?idCabinet="+self.idCabinet!).responseJSON { response in
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            
            let tvShowDict = AllArray[indexPath.row] as! Dictionary<String, Any>
            let idRdv =  tvShowDict["Id_Rendezvous"] as! String
            print(idRdv)
            
            Alamofire.request("http://41.226.11.252:1180/medichelper/deleteRdv.php?idrdv=" + idRdv).responseJSON { response in
                
                
                Alamofire.request("http://41.226.11.252:1180/medichelper/gettallredsmedecin.php?idCabinet=" + self.idCabinet!).responseJSON { response in
                    self.tvShowArray = response.result.value as! NSArray
                    self.AllArray = []
                    
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
                
            }
            
            
        }
    }
    
    
}
