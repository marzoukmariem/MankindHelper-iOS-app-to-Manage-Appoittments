//
//  detailuserViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 12/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
class detailuserViewController: UIViewController , UIScrollViewDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var iduser : String?
    var idcab : String?
    var tvShowArray : NSArray = []
    var tvShowArray1 : NSArray = []
    
    
    @IBAction func logout(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        print("la requetes")
        print("http://41.226.11.252:1180/medichelper/getInnfopatient.php?idpt=" + self.iduser! )
        Alamofire.request("http://41.226.11.252:1180/medichelper/getInnfopatient.php?idpt=" + self.iduser! ).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            
            self.scroll.minimumZoomScale = 1.0
            self.scroll.maximumZoomScale = 10.0
            
            print("tab es tab ")
            print(self.tvShowArray)
            let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
            print("userinfo")
            print(tvShowDict)
            let nomM = tvShowDict["Nom_User"] as! String
            let prenomM = tvShowDict["Prenom_User"] as! String
            let telM = tvShowDict["NumTel_User"] as! String
            
            
            let url = "http://41.226.11.252:1180/medichelper/" + (tvShowDict["UrlImage_diplome"] as! String)
            print("url photo")
            print(url)
            self.diplome.af_setImage(withURL: URL(string: url)!)
            self.nom.text = nomM + " " + prenomM
            self.tel.text = telM
            
            
        }
        
        
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/getinfocab.php?idpt=" + self.idcab!).responseJSON{ response in
            self.tvShowArray1 = response.result.value as! NSArray
            
            
            
            print("tab es tab ")
            print(self.tvShowArray1)
            let tvShowDict = self.tvShowArray1[0] as! Dictionary<String, Any>
            print("cabinet info")
            print(tvShowDict)
            let nc = tvShowDict["Nom_Cabinet"] as! String
            var emp = tvShowDict["Emplacement_Cabinet"] as! String
            var info = tvShowDict["Info_Cabinet"] as! String
            self.adresse.text = emp
            self.nomcab.text = nc
            self.spes.text = info
            
        }
        
        
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.diplome
    }
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    @IBAction func supprimer(_ sender: Any) {
        print("requete de suppression")
        print("http://41.226.11.252:1180/medichelper/supprimeruser.php?idpt=" + self.iduser! + "&idcab=" + self.idcab!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/supprimeruser.php?idpt=" + self.iduser! + "&idcab=" + self.idcab!).responseJSON{ response in
            
        }
        
        
        
        
        
        
        
        let alert = UIAlertController(title: "le médecin et son cainet ont été supprimé", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func approuver(_ sender: Any) {
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/approuvermedecinadmin2.php?iduser=" + self.iduser!).responseJSON{ response in
            
        }
        
        
        
        
        
        
        
        let alert = UIAlertController(title: "le médecin a été approuvé", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    @IBOutlet weak var spes: UILabel!
    @IBOutlet weak var nomcab: UILabel!
    @IBOutlet weak var adresse: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var diplome: UIImageView!
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
