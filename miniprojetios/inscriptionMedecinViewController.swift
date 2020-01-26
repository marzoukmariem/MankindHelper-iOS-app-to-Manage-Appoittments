//
//  inscriptionMedecinViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 5/8/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import Google


class inscriptionMedecinViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    @IBOutlet weak var imageView: UIImageView! //
    @IBAction func loadImageButtonTaped(_ sender: Any) { //
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController() //
    
    
    var NomCabinet:String?
    var Telephone:String?
    var Specialite:String?
    var adresse:String?
    var longitude:String?
    var latitude:String?
    var imageStr:String = ""
    var tvShowArray : NSArray = []
    
    @IBOutlet var TFNomMedecin: UITextField!
    @IBOutlet var TFPrenomMedecin: UITextField!
    @IBOutlet var TFNumertoMedecin: UITextField!
    @IBOutlet var labelMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        var error : NSError?
        GGLContext.sharedInstance()?.configureWithError(&error)
        
        if error != nil {
            print (error ?? "some error")
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.center = view.center
        googleSignInButton.center = CGPoint(x: self.view.center.x, y:UIScreen.main.bounds.height - 100)
        
        view.addSubview((googleSignInButton))
        // Do any additional setup after loading the view.
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print (error ?? "some error")
            return
        }
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/login3.php?login=" + user.profile.email ).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            print("response.result.value:")
            print(response.result.value)
            
            if (self.tvShowArray.count == 0){
        
        self.labelMessage.text = user.profile.email
        self.labelMessage.text = "Veuillez Patientez!"
        
        var url:String = "nom=" + self.NomCabinet!.replacingOccurrences(of: " ", with: "%20") + "&adresse=" + self.adresse!.replacingOccurrences(of: " ", with: "%20")
        
        var url2:String =  "&numtel=" + self.Telephone! + "&info=" + self.Specialite!.replacingOccurrences(of: " ", with: "%20")
        var url3:String = "&lat=" + self.latitude! + "&log="+self.longitude!
        
        print("http://41.226.11.252:1180/medichelper/ajoutercabinet.php?" + url + url2 + url3)
        Alamofire.request("http://41.226.11.252:1180/medichelper/ajoutercabinet.php?" + url + url2 + url3).responseJSON{ response in
            
            
            
            let parameters: Parameters=[
                "login":user.profile.email!,
                "nom":self.TFNomMedecin.text!,
                "numtel":self.TFNumertoMedecin.text!,
                "prenom":self.TFPrenomMedecin.text!,
                "info":"generaliste",
                "image":self.imageStr
            ]
            Alamofire.request("http://41.226.11.252:1180/medichelper/ajoutermedecinAvecImage.php", method: .post, parameters: parameters).responseString
                {
                    response in
                    //printing response
                    GIDSignIn.sharedInstance().signOut()
                    print(response)
                    print("ADDED SUCCESSFULY")
                    
                    self.performSegue(withIdentifier: "returnToLogin", sender: self)
                    
            }
            /*
            
            var url4:String = "login=" + user.profile.email + "&nom=" + self.TFNomMedecin.text!
            var url5:String = "&numtel=" + self.TFNumertoMedecin.text! + "&prenom=" + self.TFPrenomMedecin.text! + "&info=generaliste"
            var url6:String = "&password=nopass&img=aa"
            
            
            Alamofire.request("http://41.226.11.252:1180/medichelper/ajoutermedecinSansPhoto.php?" + url4 + url5 + url6).responseJSON{ response in
                
                self.performSegue(withIdentifier: "returnToLogin", sender: self)
                
                
            }
            */
            
            
        }
        
            }else{
                GIDSignIn.sharedInstance().signOut()
                let alert = UIAlertController(title: "Erreur", message: "Ce mail est associé a un autre compte", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = selectedImage
            
            
            
            let img = imageView.image?.jpegData(compressionQuality: 0.5)
            
            //let imgTry = UIImage(named: "email")!
            //let imgtry2 = imgTry.jpegData(compressionQuality: 0.1)
            imageStr = img!.base64EncodedString()
            
            //AddImg.image = getImageFromBase64(base64: imageStr)
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
