//
//  filtreViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 12/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
class filtreViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var iduser : String?
    var idcab : String?
    var tvShowArray : NSArray = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShowArray.count
    }
    
    @IBOutlet weak var tableview: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.viewWithTag(0)
        let img = contentView?.viewWithTag(1) as! UIImageView
        let titre = contentView?.viewWithTag(2) as! UILabel
        let saison = contentView?.viewWithTag(3) as! UILabel
        let saison1 = contentView?.viewWithTag(4) as! UILabel
        let saison2 = contentView?.viewWithTag(5) as! UILabel
        let tvShowDict = tvShowArray[indexPath.row] as! Dictionary<String, Any>
        titre.text = tvShowDict["Nom_Cabinet"] as! String
        saison.text = tvShowDict["Emplacement_Cabinet"] as! String
        saison1.text = tvShowDict["Info_Cabinet"] as! String
        
        saison2.text = tvShowDict["NumTel_Cabinet"] as! String
        img.image = UIImage(named: "cabinet-medical" )
        
        
        
        
        
        
        return cell!
    }
    
  
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       
       
        
        
        
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/gettallcabinet.php").responseJSON{ response in
            //self.tvShowArray = response.result.value as! NSArray
            print("response")
            print(response.result.value)
            print(response.data?.count)
            if(response.data?.count == 0){ print("empty empty")} else {
                self.tvShowArray = response.result.value as! NSArray
                if self.tvShowArray .count == 0 {
                    self.tableview.isHidden = true;
                    print("hello it is empty");
                }
                else {
                    print("tab tab tab *************")
                    print(response.result.value)
                    self.tableview.isHidden = false;
                    self.tableview.reloadData()}
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Rservez", sender: indexPath)
     
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Rservez"{
            let destination = segue.destination as! ReserverRendezvousController
            destination.iduser = self.iduser;
            
        
            
            let index = sender as! IndexPath
            
            let tvShowDict = self.tvShowArray[index.row] as! Dictionary<String, Any>
            
            
            destination.idcabinet = tvShowDict["Id_Cabinet"] as? String
            
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


