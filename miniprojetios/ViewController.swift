//
//  ViewController.swift
//  miniprojetios
//
//  Created by maryem on 4/10/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import GoogleSignIn
import Google

class ViewController: UIViewController , FBSDKLoginButtonDelegate,GIDSignInDelegate, GIDSignInUIDelegate  {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var ID : String = ""
    var idCabinet : String = ""
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var lgbtn: UIImageView!
    
    var error : NSError?
    
    var iduser : String?
    var tvShowArray : NSArray = []
    
    @IBAction func lg(_ sender: Any) {
        Alamofire.request("http://41.226.11.252:1180/medichelper/login2.php?login=" + emailtxt.text! + "&password=" + password.text!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            if self.tvShowArray.count > 0 {
            print(response.result.value)
            
            let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
            print(tvShowDict)
            let role = tvShowDict["Role_User"] as! String
            let ID = tvShowDict["Id_User"] as! String
            let idCabinet = tvShowDict["FK_Cabinet_ID"] as! String
            print("ID -*************-")
            print(ID)
            print(self.emailtxt.text)
            print(self.password.text)
            self.iduser = ID;
            self.idCabinet=idCabinet
                
                
                self.ID=ID
                
            let ok="true"
            if ok.elementsEqual("true"){
                if role.elementsEqual("patient")
                {  self.performSegue(withIdentifier: "AcceuilPatient", sender: self.iduser)
                    
                }
                if role.elementsEqual("medecin"){
                    self.performSegue(withIdentifier: "AcceuilDocteur", sender: self.iduser)
                }
                if role.elementsEqual("secretaire"){
                    self.performSegue(withIdentifier: "AcceuilSecretaire", sender: self.iduser)
                }
                if role.elementsEqual("admin"){
                    self.performSegue(withIdentifier: "AcceuilAdmin", sender: self.iduser)
                }
            }
            else {print("false")}
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "Ce compte n'est pas associé a aucun compte", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
         
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        print("iduser from login ")
        print(self.iduser)
        
        lgbtn.layer.cornerRadius = 50
      
        /*
         Alamofire.request(url).responseJSON{ response in
         
         print(response.result.value)
         }*/
        
        
        
        if (FBSDKAccessToken.current() == nil) {
            print("Not loged in..")
            print("Login buttoon clicked")
          
            
            
            
        } else {
            print("Loged in...")
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
            
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    print("Error: \(error)")
                }
                else
                {
                    do {
                        /*
                        let fbResult = try JSONSerialization.jsonObject(with: result as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        print(fbResult.value(forKey: "name"))
                        */
                        
                        let facedic =  result as! [String:Any]
                        print("result ********")
                        print("fb result")
                        print(facedic)
                    } catch {
                        print(error)
                    }
                    
                }
            })
            
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        loginButton.center = CGPoint(x: self.view.center.x, y:500)
        loginButton.delegate = self
        
        //self.view.addSubview(loginButton)
        
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
        googleSignInButton.center = CGPoint(x: self.view.center.x, y:550)
        
        view.addSubview((googleSignInButton))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- Facebook Login
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
        
        if error == nil
        {
            print("login completed...")
            self.performSegue(withIdentifier: "showNew", sender: self)
        }
        else
        {
            print(error?.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Loged out...")
    }
    
    
    /////////////////////////////////////////////////////////
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print (error ?? "some error")
            return
        }
        
        labelMessage.text = user.profile.email
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/login3.php?login=" + user.profile.email ).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            print("response.result.value:")
            print(response.result.value)
            
            if (self.tvShowArray.count > 0){
                let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
                print("tvShowDict:")
                print(tvShowDict)
                let role = tvShowDict["Role_User"] as! String
                let ID = tvShowDict["Id_User"] as! String
                let idCabinet = tvShowDict["FK_Cabinet_ID"] as! String
                print("ID -*************-")
                print(ID)
                print(self.emailtxt.text)
                print(self.password.text)
                
                self.iduser = ID;
                
                self.ID=ID
                self.idCabinet=idCabinet
                
                if role.elementsEqual("patient")
                {   print("hello");
                    self.performSegue(withIdentifier: "AcceuilPatient", sender: self)
                    
                }
                if role.elementsEqual("medecin"){
                    self.performSegue(withIdentifier: "AcceuilDocteur", sender: self)
                }
                if role.elementsEqual("secretaire"){
                    self.performSegue(withIdentifier: "AcceuilSecretaire", sender: self)
                }
                if role.elementsEqual("admin"){
                    self.performSegue(withIdentifier: "AcceuilAdmin", sender: self)
                }
            }
            
            
            else{
                GIDSignIn.sharedInstance()?.signOut()
            let alert = UIAlertController(title: "Alert", message: "Ce compte n'est pas associé a aucun compte", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
                }
        
        
        
    }
    }
    
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "AcceuilPatient"{
     
     let tabCtrl: UITabBarController = segue.destination as! UITabBarController
     let destinationVC = tabCtrl.viewControllers![0] as! filtreViewController
     
     destinationVC.iduser = self.iduser
    // destinationVC.idCabinet = self.idCabinet
     
     let destinationmesrdv = tabCtrl.viewControllers![1] as!
     mesrendezvous
     
       destinationmesrdv.iduser = self.iduser

        let destinationmesprofil = tabCtrl.viewControllers![2] as!
        profilpatientViewController
        
        destinationmesprofil.iduser = self.iduser
        
        let destinationfavoris = tabCtrl.viewControllers![3] as! MesFavorisController
        
        
        destinationfavoris.iduser = self.iduser
     }
        
        if segue.identifier == "AcceuilDocteur"{
            
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let destinationVC = tabCtrl.viewControllers![0] as! HomeDocViewController
            
            destinationVC.id = self.ID
            destinationVC.idCabinet = self.idCabinet
            
            let destinationAcciuelDoc = tabCtrl.viewControllers![1] as! AcceuilDocteurController
            
            destinationAcciuelDoc.idCabinet = self.idCabinet
            
            let destinationMsgs = tabCtrl.viewControllers![2] as! DiscussionDocteurViewController
            
            destinationMsgs.id = self.ID
            
            let destinationProfile = tabCtrl.viewControllers![3] as! profileDocteurViewController
            
            destinationProfile.id = self.ID
            destinationProfile.idCabinet = self.idCabinet
            
        }
        
        if segue.identifier == "AcceuilSecretaire"{
            
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let destinationAcc1 = tabCtrl.viewControllers![0] as! AcceuilSecController
            
            destinationAcc1.idCabinet = self.idCabinet
            print("perform segueeeeeeeeeeeeeeeee ", self.idCabinet)
            
            let destinationAcc2 = tabCtrl.viewControllers![1] as! AcceuilSec2Controller
            
            destinationAcc2.idCabinet = self.idCabinet
            
            
            
        }
     
     
        /*
     
     
     if segue.identifier == "AcceuilPatient"{
            let destination = segue.destination as! testViewController
           
            
            destination.iduser = self.iduser;
            print("iduser from login prepare")
            print(self.iduser)
            //destination.nomImage = "1"
        }
    }
    
    */
}
    
    @IBAction func toGenericInscription(_ sender: Any) {
        self.performSegue(withIdentifier: "toGenericInscription", sender: self)
    }
}
