//
//  RdvUpdateController.swift
//  miniprojetios
//
//  Created by ESPRIT on 25/04/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire

class RdvUpdateController: UIViewController {
    
    var tvShowArray1 : NSArray = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var labelDateChoisiPaPatient: UILabel!
    
    @IBOutlet weak var labelDateChoisiParSecretaire: UILabel!
    
    @IBOutlet weak var labelNomPrenom: UILabel!
    
    
    
    var idRendezvous:String?
    var prenomPatient:String?
    var nomPatient:String?
    var date:String?
    var datefinale:String?
    var datefinale2:String?
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+1:00") //Current time zone
        //according to date format your date string
        guard let date1 = dateFormatter.date(from: date!) else {
            fatalError()
        }

        datePicker?.date = date1
        
        super.viewDidLoad()
        labelDateChoisiPaPatient.text = date!
        labelNomPrenom.text = nomPatient! + " " + prenomPatient!
        datefinale2 = date!
        datefinale = "2019-05-02%14:14:00"
        labelDateChoisiParSecretaire.text = datefinale2
        
        datePicker.datePickerMode = .dateAndTime
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func valueChanged(sender: UIDatePicker, forEvent event: UIEvent){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss "
        labelDateChoisiParSecretaire.text = dateFormatter.string(from: datePicker.date)
        let lowerBound = String.Index.init(encodedOffset: 0)
        let upperBound = String.Index.init(encodedOffset: 10)
        
        let date = (labelDateChoisiParSecretaire.text as! String)[lowerBound..<upperBound]
        print(date)
        let lowerBound1 = String.Index.init(encodedOffset: 11)
        let upperBound1 = String.Index.init(encodedOffset: 19)
        let time = (labelDateChoisiParSecretaire.text as! String)[lowerBound1..<upperBound1]
        print(time)
        self.datefinale = date+"%20"+time
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func updateTime(_ sender: Any) {
        var http : String="http://41.226.11.252:1180/medichelper/updatetimesec.php?idrdv=" + self.idRendezvous! + "&daterdv=" + self.datefinale!
        
        print(http)
        
        let alert = UIAlertController(title: "rendezVous Enregistrer", message: "modification enregistrée", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        Alamofire.request(http ).responseJSON{_ in
            
        }
  
    }
    
    @IBAction func `return`(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
