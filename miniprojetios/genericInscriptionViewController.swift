//
//  genericInscriptionViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 5/6/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import Google

class genericInscriptionViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var role : String = ""
    
    
    
    /*func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
     if error != nil{
     print (error ?? "some error")
     return
     }
     
     //labelMessage.text = user.profile.email
     print(self.role)
     if self.role.elementsEqual("Medecin") {
     performSegue(withIdentifier: "toAddCabinet", sender: self)
     print("aaaaaaa")
     }
     
     }
     */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    @IBOutlet var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Patient", "Medecin"]
        self.role = "Patient"
        /*var error : NSError?
         GGLContext.sharedInstance()?.configureWithError(&error)
         
         if error != nil {
         print (error ?? "some error")
         return
         }
         
         GIDSignIn.sharedInstance().uiDelegate = self
         GIDSignIn.sharedInstance()?.delegate = self
         
         let googleSignInButton = GIDSignInButton()
         googleSignInButton.center = view.center
         googleSignInButton.frame.origin = CGPoint(x: 130, y:550)
         
         view.addSubview((googleSignInButton))
         
         */
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func continueClick(_ sender: Any) {
        if self.role.elementsEqual("Medecin") {
            performSegue(withIdentifier: "toAddCabinet", sender: self)
            print("aaaaaaa")
        }
        else if self.role.elementsEqual("Patient") {
            performSegue(withIdentifier: "toPatientInscription", sender: self)
            print("aaaaaaa")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.role = pickerData[row]
        print(self.role)
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
