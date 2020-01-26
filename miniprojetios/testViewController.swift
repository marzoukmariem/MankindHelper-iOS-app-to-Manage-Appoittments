//
//  testViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 07/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import Mapbox
import CoreLocation

class testViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UICollectionViewDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var iduser : String?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBOutlet weak var collectionview: UICollectionView!
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return region.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return region[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.reg = region[row]
        Alamofire.request("http://41.226.11.252:1180/medichelper/allcabinet.php?idpt=" + self.reg.replacingOccurrences(of: " ", with: "%20")).responseJSON{ response in
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
                    self.tableview.reloadData()}
                
            } }
        
        let nrg = images1[row]
        self.imgrg.image = UIImage(named: nrg);
        print(self.reg)
    }
    
    
    
    @IBOutlet weak var imgrg: UIImageView!
    
    
    
    
    var reg = "";
    let spec = ["chirurgie générale", "Dentiste", "Psychiatre" ,"Ophtalmologue", "Pédiatre", "dermatologue","médecine alternative","neurochirurgie"]
    
    let region = ["Grand tunis", "Bizerte", "région Ouest" ,"Cap Bon", "région est", "région Sud"]
    let images = ["gener", "dents1", "ped" ,"opt", "neuro", "geni","psy","alter","derma"]
    let images1 = ["tunis", "Bizerte", "ouest" ,"capbon", "sehel", "sud"]
    @IBOutlet weak var tableview: UITableView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    //  @IBOutlet weak var collectionview: UICollectionView!
    
    // @IBOutlet weak var collectioview: UICollectionView!
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        //image.image = castMembers[indexPath.row] as! Image
        let nomimg = images[indexPath.row]
        image.image = UIImage(named: nomimg )
        //   let t1 = cell.viewWithTag(3) as! UILabel
        
        //  let tvShowDict1 = tvShowArray1[indexPath.row] as! Dictionary<String, Any>
        //   t1.text = "hello" ;
        // t1.text = tvShowDict1["Nom_Cabinet"] as! String
        
        return cell
        
        
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "filtre", sender: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
    }
    
    
    var tvShowArray : NSArray = []
    var tvShowArray1 : NSArray = []
    
    
    //@IBOutlet weak var tableview: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShowArray.count
    }
    
    
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
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Rservez", sender: indexPath) //appelle PrepareForSegue automatiquement
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        
        let color1 = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 255);
        var  r = "Grand tunis";
        self.reg = r
        let maryem = "maryem  marzouk hi";
        let res = maryem.replacingOccurrences(of: " ", with: "%20")
        print("resultat ********")
        print(res)
        self.picker.setValue(color1, forKey: "textColor")
        print("userid from acceuilpatient ********")
        print(self.iduser)
        
        
        
        print("tab tab")
        print(self.tvShowArray)
        // Do any additional setup after loading the view.
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/allcabinet.php?idpt=" + r.replacingOccurrences(of: " ", with: "%20")).responseJSON{ response in
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
                    self.tableview.reloadData()}
                
            }
            
        }
        
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/cabinetproches.php?lat=36.81897&log=10.16579").responseJSON{ response in
            self.tvShowArray1 = response.result.value as! NSArray
            //  self.collectionview.reloadData()
            
        }
        
        
        
        
        
        
        print("userlocation")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
  
        
        let color1 = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 255);
        var  r = "Grand tunis";
        self.reg = r
        let maryem = "maryem  marzouk hi";
        let res = maryem.replacingOccurrences(of: " ", with: "%20")
        print("resultat ********")
        print(res)
        self.picker.setValue(color1, forKey: "textColor")
        print("userid from acceuilpatient ********")
        print(self.iduser)
        
       
        
        print("tab tab")
        print(self.tvShowArray)
        // Do any additional setup after loading the view.
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/allcabinet.php?idpt=" + r.replacingOccurrences(of: " ", with: "%20")).responseJSON{ response in
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
                    self.tableview.reloadData()}
                
            }
            
        }
        Alamofire.request("http://41.226.11.252:1180/medichelper/cabinetproches.php?lat=36.81897&log=10.16579").responseJSON{ response in
            self.tvShowArray1 = response.result.value as! NSArray
            //  self.collectionview.reloadData()
            
        }
        
        
        
        
        
        
        print("userlocation")
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Rservez", sender: indexPath)
        performSegue(withIdentifier: "map", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Rservez"{
            let destination = segue.destination as! ReserverRendezvousController
            destination.iduser = self.iduser;
            let indice = self.tableview.indexPathForSelectedRow
            
            let tvShowDict = self.tvShowArray[(indice?.row)!] as! Dictionary<String, Any>
            destination.idcabinet = tvShowDict["Id_Cabinet"] as? String
            
        }
        
        
        if segue.identifier == "filtre"{
            
            let destination1 = segue.destination as! filtreViewController
            // destination.iduser = self.iduser;
           // let indice1 = self.collectionview.indexPathsForSelectedItems
            print(self.collectionview.indexPathsForSelectedItems?[0])
            print("indice ******")
            let indexPath2 = self.collectionview.indexPathsForSelectedItems?[0]
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
