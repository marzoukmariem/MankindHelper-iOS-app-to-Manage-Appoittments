//
//  InscriptionPatientViewController.swift
//  Medichelper
//
//  Created by ESPRIT on 17/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import Alamofire

class InscriptionPatientViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tvShowArray : NSArray = []
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil{
            print (error ?? "some error")
            return
        }
        
        labelMessage.text = user.profile.email
        labelMessage.text = "Veuillez Patientez!"
        //
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/login3.php?login=" + user.profile.email ).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            print("response.result.value:")
            print(response.result.value)
            
            if (self.tvShowArray.count == 0){
        
        let parameters: Parameters=[
            "login":user.profile.email!,
            "nom":self.tfnom.text!,
            "numtel":self.tfnumero.text!,
            "prenom":self.tfprenom.text!,
            "datenaiss":self.date!,
            "image":self.imageStr,
            "cin":self.tfprofession.text!
        ]
        Alamofire.request("http://41.226.11.252:1180/medichelper/uploadIos.php", method: .post, parameters: parameters).responseString
            {
                response in
                //printing response
                print(response)
                print("ADDED SUCCESSFULY")
                GIDSignIn.sharedInstance().signOut()
                self.performSegue(withIdentifier: "returnToLogin", sender: self)
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
    

    @IBAction func loadImageButton(_ sender: Any) {
    }
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tfnom: UITextField!
    @IBOutlet weak var tfprenom: UITextField!
    @IBOutlet weak var tfnumero: UITextField!
    @IBOutlet weak var tfadresse: UITextField!
    @IBOutlet weak var tfprofession: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date:String?
    var imageStr:String = ""
    
    @IBOutlet weak var imageView: UIImageView! //
    @IBAction func loadImageButtonTaped(_ sender: Any) { //
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController() //
    
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
        googleSignInButton.center = CGPoint(x: self.view.center.x, y:UIScreen.main.bounds.height - 40)
        
        view.addSubview((googleSignInButton))
        // Do any additional setup after loading the view.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: datePicker.date)
        
        print(date)
        self.date=date
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismisss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func valueChanged(sender: UIDatePicker, forEvent event: UIEvent){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: datePicker.date)
        
        print(date)
        self.date=date
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
