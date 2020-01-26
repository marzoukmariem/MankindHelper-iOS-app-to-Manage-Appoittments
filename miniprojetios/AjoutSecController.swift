//
//  AjoutSecController.swift
//  miniprojetios
//
//  Created by ESPRIT on 11/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire

class AjoutSecController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var tvShowArray : NSArray = []
    
    @IBOutlet weak var TFPrenom: UITextField!
    @IBOutlet weak var TFMDP: UITextField!
    @IBOutlet weak var TFLogin: UITextField!
    @IBOutlet weak var TFNom: UITextField!
    @IBOutlet weak var TFNumero: UITextField!
    
    var idCabinet:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(idCabinet!)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Click(_ sender: Any) {
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/login2.php?login=" + TFLogin.text! + "&password=" + TFMDP.text!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            if self.tvShowArray.count == 0 {
        
        var url:String = "nom=" + self.TFNom.text!.replacingOccurrences(of: " ", with: "%20") + "&prenom=" + self.TFPrenom.text!.replacingOccurrences(of: " ", with: "%20")
        
        var url2:String =  "&numtel=" + self.TFNumero.text! + "&login=" + self.TFLogin.text!.replacingOccurrences(of: " ", with: "%20")
        var url3:String = "&password=" + self.TFMDP.text!.replacingOccurrences(of: " ", with: "%20") + "&info=secretaire&cab=" + self.idCabinet!.replacingOccurrences(of: " ", with: "%20")
        
        print("http://41.226.11.252:1180/medichelper/inserersecretaire.php?" + url + url2 + url3)
        Alamofire.request("http://41.226.11.252:1180/medichelper/inserersecretaire.php?" + url + url2 + url3).responseJSON{ response in
            
        }
                
            }else{
                let alert = UIAlertController(title: "Alert", message: "un compte avec les memes coordonnées existe ", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
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
    
    
}
