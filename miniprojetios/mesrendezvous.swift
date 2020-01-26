//
//  mesrendezvous.swift
//  miniprojetios
//
//  Created by ESPRIT on 08/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire

class mesrendezvous: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShowArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
          let tvShowDict = tvShowArray[indexPath.row] as! Dictionary<String, Any>
        let contentView = cell?.viewWithTag(0)
        let  saison2 = contentView?.viewWithTag(1) as! UILabel
        let saison = contentView?.viewWithTag(3) as! UILabel
        saison2.text = tvShowDict["dateRendezvous"] as! String
        saison.text = tvShowDict["Nom_Cabinet"] as! String
        return cell!
    }
    
    
    
    var iduser : String?
 
    
    var tvShowArray : NSArray = []
    
    
    @IBOutlet weak var tableview: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/rdvpatientconnecte.php?idpt=" + self.iduser!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            print("response")
            print(response.result.value)
            print(response.data?.count)
            if(response.data?.count == 0){ print("empty empty")} else {
                self.tvShowArray = response.result.value as! NSArray
                if self.tvShowArray .count == 0 {
                    self.tableview.isHidden = true;
                    print("hello it is empty");
                    self.tableview.reloadData()
                }
                else {
                    print("tab tab tab *************")
                    print(response.result.value)
                    self.tableview.isHidden = false;
                    self.tableview.reloadData()}
                
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/rdvpatientconnecte.php?idpt=" + self.iduser!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            print("response")
            print(response.result.value)
            print(response.data?.count)
            if(response.data?.count == 0){ print("empty empty")} else {
                self.tvShowArray = response.result.value as! NSArray
                if self.tvShowArray .count == 0 {
                    self.tableview.isHidden = true;
                    print("hello it is empty");
                    self.tableview.reloadData()
                }
                else {
                    print("tab tab tab *************")
                    print(response.result.value)
                    self.tableview.isHidden = false;
                    self.tableview.reloadData()}
                
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

    }
