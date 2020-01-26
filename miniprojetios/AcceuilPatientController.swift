//
//  AcceuilPatientController.swift
//  miniprojetios
//
//  Created by maryem on 4/13/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import Mapbox
import CoreLocation
class AcceuilPatientController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource,CLLocationManagerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
     let manager = CLLocationManager()
    var locationuser : CLLocation? = nil
    var iduser : String?
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShowArray1.count
    }
    
    
    
    @IBOutlet weak var collectioview: UICollectionView!
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        //image.image = castMembers[indexPath.row] as! Image
        image.image = UIImage(named: "cabinet-medical" )
        let t1 = cell.viewWithTag(2) as! UILabel
      
        let tvShowDict1 = tvShowArray1[indexPath.row] as! Dictionary<String, Any>
        t1.text = tvShowDict1["Nom_Cabinet"] as! String
       
        return cell
        
        
        
        
        
        
    }
    
     var tvShowArray : NSArray = []
     var tvShowArray1 : NSArray = []

    
    @IBOutlet weak var tableview: UITableView!
    
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userid from acceuilpatient ********")
        print(self.iduser)
        let content = UNMutableNotificationContent()
        content.title = " Mes Rendez-vous"
        content.subtitle = "Votre Rendez-vous est approuvé "
        content.body = "Its lunch time at the park, please join us for a dinosaur feeding"
        content.sound = UNNotificationSound.default
        
        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5, repeats: false)
        
        //create request to display
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
        
        //add request to notification center
        UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
        
        
        
       // user location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        
       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
         Alamofire.request("http://41.226.11.252:1180/medichelper/gettallcabinet.php").responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            self.tableview.reloadData()
            
        }
        Alamofire.request("http://41.226.11.252:1180/medichelper/cabinetproches.php?lat=36.81897&log=10.16579").responseJSON{ response in
            self.tvShowArray1 = response.result.value as! NSArray
            self.collectioview.reloadData()
            
        }
        
        
        
        
        
        
        print("userlocation")
      
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hello")
        let location = locations[0]
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        self.locationuser = location
        
       
        
        
        
        
        manager.stopUpdatingLocation()
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
