//
//  profilpatientViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 11/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GoogleSignIn
import Google

class profilpatientViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func disconnect(_ sender: Any) {
            GIDSignIn.sharedInstance().signOut()
            performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    let celule = ["modifier votre  profil", "Déconnecter"]
    
    @IBOutlet weak var numP: UITextField!
    @IBOutlet weak var prenomP: UITextField!
    
    @IBOutlet weak var nomP: UITextField!
  
    @IBAction func modifier(_ sender: Any) {
        let parameters: Parameters=[
            "id": Int(self.iduser!),
            "nom":self.nomP.text!,
            "numtel":self.numP.text!,
            "prenom":self.prenomP.text!,
            "image":self.imageStr
        ]
       // print(self.imageStr)
        Alamofire.request("http://41.226.11.252:1180/medichelper/ajouterPH.php", method: .post, parameters: parameters).responseString
            {
                response in
              
                print("reponse ************")
                print(response)
                print("reponse ************")
        }
    }
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var insererph: UIButton!
    
    
    @IBAction func insererph(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    var iduser : String?
    var tvShowArray : NSArray = []
    var imageStr:String = ""
    @IBOutlet weak var prenom: UILabel!
   
    @IBOutlet weak var photopatient: UIImageView!
    
    @IBAction func logout(_ sender: Any) {
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
        
        
        print(self.iduser!)
        print("requete***")
        print("http://41.226.11.252:1180/medichelper/getInnfopatient.php?idpt=" + self.iduser!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/getInnfopatient.php?idpt=" + self.iduser! ).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            print("response.result.value:")
            print(response.result.value)
            
           
                let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
                print("tvShowDict:")
                print(tvShowDict)
                let prenom = tvShowDict["Prenom_User"] as! String
                let nom = tvShowDict["Nom_User"] as! String
        
                let email = tvShowDict["Login_User"] as! String
        
                 let tel = tvShowDict["NumTel_User"] as! String
       
         let img = tvShowDict["UrlImage_Patient"] as! String
         self.nomP.text = nom
         self.prenomP.text = prenom
         self.numP.text = tel
         self.prenom.text = nom+" "+prenom
            
    
            
            self.photopatient.layer.borderWidth = 1
            self.photopatient.layer.masksToBounds = false
            self.photopatient.layer.borderColor = UIColor.black.cgColor
            self.photopatient.layer.cornerRadius = self.photopatient.frame.height/4
            self.photopatient.clipsToBounds = true
           let url = "http://41.226.11.252:1180/medichelper/" + (tvShowDict["UrlImage_Patient"] as! String)
            self.photopatient.af_setImage(withURL: URL(string: url)!)
            
        }

   
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            self.photopatient.contentMode = .scaleAspectFit
           self.photopatient.image = selectedImage
            
            
            
            let img = self.photopatient.image?.jpegData(compressionQuality: 0.5)
            
            //let imgTry = UIImage(named: "email")!
            //let imgtry2 = imgTry.jpegData(compressionQuality: 0.1)
            imageStr = img!.base64EncodedString()
            
            //AddImg.image = getImageFromBase64(base64: imageStr)
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
