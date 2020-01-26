//
//  DiscussionPatientViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 14/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire

class DiscussionPatientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvShowDict = messages[indexPath.row] as! Dictionary<String, Any>
        
        
        var cell : UITableViewCell?
        switch tvShowDict["FK_User_ID"] as! String  {
        case self.idPatient! :
            
            cell = tableView.dequeueReusableCell(withIdentifier: "prototype2")
            let contentView = cell?.viewWithTag(22)
            let msg = contentView?.viewWithTag(3) as! UILabel
            msg.text = (tvShowDict["detail_Msg"] as! String )
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "prototype1")
            let contentView = cell?.viewWithTag(11)
            let msg = contentView?.viewWithTag(2) as! UILabel
            msg.text = (tvShowDict["detail_Msg"] as! String )
            let img = contentView?.viewWithTag(1) as! UIImageView
            img.layer.borderWidth = 1
            img.layer.masksToBounds = false
            img.layer.borderColor = UIColor.black.cgColor
            img.layer.cornerRadius = img.frame.height/2
            img.clipsToBounds = true
            let nomEtPrenom = contentView?.viewWithTag(2) as! UILabel
            
        }
        return cell!
    }
    
    
    var messages : NSArray = []
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var idcabinet: String?
    var idPatient:String?
    var nonc: String?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        navigationBar.title = nonc!
        print("aaaadqfdhbhbhvbshbhsbhbhbdshjqjhbhbhbdshjqjhbhbhbdshjqjhbjhqbvqjhbhjbjhbhbqvjhbvjhjhvbjhvbqvf")
        print("Userid=" + idPatient!)
        print("idcabinet=" + idcabinet!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/getallMsgsOfCOnnectedPatientWithHisDoctor.php?Userid="+idPatient! + "&idcabinet="+idcabinet! ).responseJSON{
            response in
            self.messages = response.result.value as! NSArray
            self.tableView.reloadData()
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var msgTXT: UITextField!
    
    
    @IBAction func sendAction(_ sender: Any) {
        if msgTXT.text=="" {
            
        }
        else {
            
            var url1 = "http://41.226.11.252:1180/medichelper/ajoutermsg2.php?idcabinet="+idcabinet!  + "&FK_User_ID=" + idPatient!
            var url2 = "&detail_Msg=" + msgTXT.text!.replacingOccurrences(of: " ", with: "%20") as String
            Alamofire.request(url1 + url2 ).responseJSON{
                response in
                
                Alamofire.request("http://41.226.11.252:1180/medichelper/getallMsgsOfCOnnectedPatientWithHisDoctor.php?Userid="+self.idPatient! + "&idcabinet="+self.idcabinet! ).responseJSON{
                    response in
                    self.messages = response.result.value as! NSArray
                    self.tableView.reloadData()
                    
                }
                
                
            }
            msgTXT.text=""
    }
    
    
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
     */
    
}
