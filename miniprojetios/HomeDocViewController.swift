//
//  HomeDocViewController.swift
//  Alamofire
//
//  Created by ESPRIT on 09/05/2019.
//

import UIKit
import Alamofire
import GoogleSignIn
import Google

class HomeDocViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //wa
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

  
    @IBOutlet weak var barcontrol: UINavigationItem!
    
    @IBOutlet var labelNomCabinet: UILabel!
    @IBOutlet var labelAdresseCabinet: UILabel!
    @IBOutlet var labelEmailCabinet: UILabel!
    @IBOutlet var imagePatient: UIImageView!
    @IBOutlet var labelNomPrenomPatioent: UILabel!
    @IBOutlet var labelDateProchainRdv: UILabel!
    
    var id:String?
    var idCabinet:String?
    var tvShowArray : NSArray = []
    var prochainRdvs : NSArray = []
    
    @IBAction func disconnect(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("http://41.226.11.252:1180/medichelper/getelmentdoctoupdate.php?iduser=" + self.id!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/getelmentdoctoupdate.php?iduser=" + self.id!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            
            
            
            let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
            print(tvShowDict)
            let nomCabinet = tvShowDict["Nom_Cabinet"] as! String
            let adresseCabinet = tvShowDict["Emplacement_Cabinet"] as! String
            
            let email = tvShowDict["Login_User"] as! String
            
            let nom = tvShowDict["Nom_User"] as! String
            
            self.labelAdresseCabinet.text = adresseCabinet
            self.labelEmailCabinet.text = email
            self.labelNomCabinet.text = nomCabinet
            self.barcontrol.title = "Dr. " + nom
        }
        
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/gettallredsmedecinTriParDate.php?idCabinet=" + self.idCabinet!).responseJSON{ response in
            self.prochainRdvs = response.result.value as! NSArray
            
            if self.prochainRdvs.count > 0 {
            
            let rdvDict = self.prochainRdvs[0] as! Dictionary<String, Any>
            
            let nomPatient = (rdvDict["Nom_User"] as! String) + " " + (rdvDict["Prenom_User"] as! String)
            let DateRdv = rdvDict["dateRendezvous"] as! String
            
            let url = "http://41.226.11.252:1180/medichelper/" + (rdvDict["UrlImage_Patient"] as! String)
            print(url)
            self.imagePatient.layer.borderWidth = 1
            self.imagePatient.layer.masksToBounds = false
            self.imagePatient.layer.borderColor = UIColor.black.cgColor
            self.imagePatient.layer.cornerRadius = self.imagePatient.frame.height/2
            self.imagePatient.clipsToBounds = true
            
            self.imagePatient.af_setImage(withURL: URL(string: url)!)
            self.labelNomPrenomPatioent.text = nomPatient
            
            let lowerBound2 = String.Index.init(encodedOffset: 0)
            let upperBound2 = String.Index.init(encodedOffset: 16)
            
            
            self.labelDateProchainRdv.text = String(DateRdv[lowerBound2..<upperBound2])
         }
        }
        // Do any additional setup after loading the view.
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
