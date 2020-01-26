//
//  DiscussionDocteurViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 01/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire

class DiscussionDocteurViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var refreshControl: UIRefreshControl!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonnesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.viewWithTag(0)
        let img = contentView?.viewWithTag(1) as! UIImageView
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.height/2
        img.clipsToBounds = true
        let nomEtPrenom = contentView?.viewWithTag(2) as! UILabel
        let url:String?
        let tvShowDict = PersonnesArray[indexPath.row] as! Dictionary<String, Any>
        nomEtPrenom.text = (tvShowDict["Nom_User"] as! String ) + " " + (tvShowDict["Prenom_User"] as! String)
        url = "http://41.226.11.252:1180/medichelper/" + (tvShowDict["UrlImage_Patient"] as! String)
        img.af_setImage(withURL: URL(string: url!)!)
        
        return cell!
    }
    
    var PersonnesArray : NSArray = []
    var id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        print(id!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/getallpatientsHavingMessages.php?Userid="+id!).responseJSON{
            response in
            self.PersonnesArray = response.result.value as! NSArray
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDiscussionWithPatient", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDiscussionWithPatient"{
            let DVC = segue.destination as! DiscussionWithPatientViewController
            
            let index = sender as! IndexPath
            
            let tvShowDict = PersonnesArray[index.row] as! Dictionary<String, Any>
            
            let idPatient = (tvShowDict["Id_User"] as! String )
            let imagePatient = (tvShowDict["UrlImage_Patient"] as! String )
            let nomPatient = (tvShowDict["Nom_User"] as! String )
            
            print("performSegue"+idPatient)
            DVC.idPatient = idPatient
            DVC.imagePatient = imagePatient
            DVC.nomPatient = nomPatient
            DVC.idDocteur = id
            
        }
        
    }
    
    @objc func refresh(_ sender: Any) {
        Alamofire.request("http://41.226.11.252:1180/medichelper/getallpatientsHavingMessages.php?Userid="+id!).responseJSON{
            response in
            self.PersonnesArray = response.result.value as! NSArray
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
}
