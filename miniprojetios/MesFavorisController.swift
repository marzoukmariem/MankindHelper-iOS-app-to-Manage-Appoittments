//
//  MesFavorisController.swift
//  miniprojetios
//
//  Created by ESPRIT on 14/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import CoreData
class MesFavorisController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var tableview: UITableView!
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.viewWithTag(0)
        let img = contentView?.viewWithTag(1) as! UIImageView
        let titre = contentView?.viewWithTag(2) as! UILabel
        let saison = contentView?.viewWithTag(3) as! UILabel
        let saison1 = contentView?.viewWithTag(4) as! UILabel
        let saison2 = contentView?.viewWithTag(5) as! UILabel
        titre.text = seasons[indexPath.row].value(forKey: "nom") as! String
        saison.text = seasons[indexPath.row].value(forKey: "emp") as! String
        saison1.text = seasons[indexPath.row].value(forKey: "info") as! String
        
        saison2.text = seasons[indexPath.row].value(forKey: "tel") as! String
        img.image = UIImage(named: "cabinet-medical" )
        
        return cell!
    }
    
var seasons : [NSManagedObject] = []
      var iduser : String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenceContainer = appDelegate.persistentContainer
        let managedContext = persistenceContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cabinet")
        do {
            try seasons = managedContext.fetch(fetchRequest) as! [NSManagedObject]
           
        } catch  {
            let nsError = error as! NSError
            print(nsError.userInfo)
        }
        

        
        
        
        
        
        if(seasons.count == 0) {tableview.isHidden = true}
        else {tableview.isHidden = false}
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistenceContainer = appDelegate.persistentContainer
        let managedContext = persistenceContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cabinet")
       
      
        
        
        do {
            try seasons = managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch  {
            let nsError = error as! NSError
            print(nsError.userInfo)
        }
        
        
      
   
        
    }
    

    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Reservez2", sender: indexPath)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Reservez2"{
            let destination = segue.destination as! ReserverRendezvousController
            destination.iduser = self.iduser;
            let indice = self.tableview.indexPathForSelectedRow
            
          //  destination.idcabinet =  seasons[(indice?.row)!].value(forKey: "idcabinet") as! String
            
            
            // var res = seasons[0].value(forKey: "idcabinet") as! String
            let res = seasons[(indice?.row)!].value(forKey: "idcabinet") as! String
            print(" la valeur de lid dans segue ")
            print(res)
           destination.idcabinet =  res
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
