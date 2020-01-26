//
//  FichePatientController.swift
//  miniprojetios
//
//  Created by ESPRIT on 4/20/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire

class FichePatientController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBOutlet var TVTitre: UITextView!
    @IBOutlet var TVRemarque: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelDateNaissance: UILabel!
    @IBOutlet weak var labelNumTel: UILabel!
    @IBOutlet weak var labelNomEtPrenom: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var savingButton: UIButton!
    
    
    let images = ["1", "2", "3" ,"4", "5", "6","7"]
    
    let dates = ["2011", "2012", "2013" ,"2014", "2015", "2016","2017"]
    
    var tvShowArray : NSArray = []
    var rdvArray : NSArray = []
    var selectedRdv : NSArray = []
    var IdSelectedRdv : String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rdvArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.viewWithTag(0)
        let date = contentView?.viewWithTag(1) as! UILabel
        let temp = contentView?.viewWithTag(2) as! UILabel
        
        let rdvDict = rdvArray[indexPath.row] as! Dictionary<String, Any>
        let lowerBound = String.Index.init(encodedOffset: 0)
        let upperBound = String.Index.init(encodedOffset: 10)
        
        date.text = String((rdvDict["dateRendezvous"] as! String )[lowerBound..<upperBound])
        
        let lowerBound2 = String.Index.init(encodedOffset: 11)
        let upperBound2 = String.Index.init(encodedOffset: 16)
        
        temp.text = String((rdvDict["dateRendezvous"] as! String )[lowerBound2..<upperBound2])
        return cell!
    }
    
    
    var idPatient:String?
    var imagePatient:String?
    var professionPatient:String?
    var prenomPatient:String?
    var nomPatient:String?
    var numTelPatient:String?
    var dateNaissancePatient:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savingButton.layer.cornerRadius = 5
        savingButton.isHidden = true
        savingButton.layer.borderWidth = 1
        
        labelProfession.text = professionPatient!
        labelNomEtPrenom.text = nomPatient! + " " + prenomPatient!
        labelProfession.text = professionPatient!
        
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.height/2
        img.clipsToBounds = true
        
        img.af_setImage(withURL: URL(string: "http://41.226.11.252:1180/medichelper/" + imagePatient!)!)
        
        let lowerBound = String.Index.init(encodedOffset: 0)
        let upperBound = String.Index.init(encodedOffset: 10)
        
        labelDateNaissance.text = String(dateNaissancePatient![lowerBound..<upperBound])
        
        print("http://41.226.11.252:1180/medichelper/getInnfopatient.php?idpt=" + idPatient!)
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/getInnfopatient.php?idpt=" + idPatient!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            
            
            
            let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
            
            let role = tvShowDict["Nom_User"] as! String
            print(role)
            
            
            
        }
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/ListeRendezVousPatientMedecinIos.php?idUser=" + idPatient!).responseJSON{ response in
            self.rdvArray = response.result.value as! NSArray
            self.tableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        savingButton.isHidden = false
        
        let rdvDict = rdvArray[indexPath.row] as! Dictionary<String, Any>
        let id = rdvDict["Id_Rendezvous"] as! String
        print("id du rdv selectionné ",id )
        Alamofire.request("http://41.226.11.252:1180/medichelper/fichepatient.php?idCabinet=" + id).responseJSON{ response1 in
            self.selectedRdv = response1.result.value as! NSArray
            
            let selectedRdvDict = self.selectedRdv[0] as! Dictionary<String, Any>
            let titre = selectedRdvDict["Titre_Consultation"] as! String
            print("titre: ",titre)
            
            let detail = selectedRdvDict["detail_Consultation"] as! String
            print("description: ",titre)
            
            self.TVTitre.text=titre
            self.TVRemarque.text=detail
            
            self.IdSelectedRdv = id
            
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
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        var http : String="http://41.226.11.252:1180/medichelper/editconsultaion.php?idrdv="+self.IdSelectedRdv
        var http2 : String = "&titrerdv=" + self.TVTitre.text!.replacingOccurrences(of: " ", with: "%20") + "&detrdv=" + self.TVRemarque.text!.replacingOccurrences(of: " ", with: "%20")
        print(http + http2)
        
        Alamofire.request(http + http2).responseJSON{_ in
            
            let alert = UIAlertController(title: "Alert", message: "Modification Enregistrée", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
