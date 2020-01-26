//
//  AcceuilAdminController.swift
//  miniprojetios
//
//  Created by maryem on 4/13/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
class AcceuilAdminController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    @IBAction func logout(_ sender: Any) {
     performSegue(withIdentifier: "toLogin", sender: self)
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var tvShowArray : NSArray = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.tvShowArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.viewWithTag(0)
        
        let titre = contentView?.viewWithTag(1) as! UILabel
        
        let tvShowDict = tvShowArray[indexPath.row] as! Dictionary<String, Any>
        print("erreur")
        print(tvShowDict)
        let nom = tvShowDict["Nom_User"] as! String
        let prenom = tvShowDict["Prenom_User"] as! String
        titre.text = nom + " " + prenom
        
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailuser", sender: indexPath) //appelle PrepareForSegue automatiquement
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailuser"{
            let destination = segue.destination as! detailuserViewController
            
            let indice = self.tableview.indexPathForSelectedRow
            
            let tvShowDict = self.tvShowArray[(indice?.row)!] as! Dictionary<String, Any>
            destination.iduser = tvShowDict["Id_User"] as? String
            destination.idcab = tvShowDict["FK_Cabinet_ID"] as? String
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/approuveradmin.php").responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
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
                    self.tableview.isHidden = false;
                    self.tableview.reloadData()
                    
                }
                
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
