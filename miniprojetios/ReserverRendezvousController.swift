//
//  ReserverRendezvousController.swift
//  miniprojetios
//
//  Created by maryem on 4/13/19.
//  Copyright © 2019 maryem. All rights reserved.
//
import CoreLocation
import UIKit
import Alamofire
import Mapbox
import CoreData
class ReserverRendezvousController: UIViewController , MGLMapViewDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    var seasons : [NSManagedObject] = []
    var tvShowArray : NSArray = []
    var iduser : String?
    var idcabinet : String?
    var latc : String?
    var logc : String?
    var nonc : String?
    var emplacementcabinet : String?
   
    var telcabinet : String?
    var infocabinett : String?
    @IBOutlet weak var datepicker: UIDatePicker!
    var datereserver : Date = Date()
    var d:String = "";
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func favoris(_ sender: Any) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        let managedContext = persistanceContainer.viewContext
        let predicateRequest = NSPredicate(format: "idcabinet == %@", self.idcabinet!) // %@ : string, %f : float, %d : int
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cabinet")
        fetchRequest.predicate = predicateRequest
        
        
        do{
            try self.seasons = managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if self.seasons.count == 0 {
                let entity = NSEntityDescription.entity(forEntityName: "Cabinet", in: managedContext)
                let Season = NSManagedObject(entity: entity!, insertInto: managedContext)
                Season.setValue(self.idcabinet!, forKey: "idcabinet")
                Season.setValue(self.nonc!, forKey: "nom")
                Season.setValue(self.emplacementcabinet!, forKey: "emp")
                Season.setValue(self.infocabinett!, forKey: "info")
                Season.setValue(self.telcabinet!, forKey: "tel")
                try managedContext.save()
                print("cabinet saved")
                let alert = UIAlertController(title: "Alert", message: "Votre Cabinet est ajouter aux favoris", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alert", message: "Cabinet déja ajouter aux favoris", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }catch {
            var nsError = error as! NSError
            print(nsError.userInfo)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    @IBOutlet weak var infocabinet: UITextView!
    @objc func dateChanged(datePicker: UIDatePicker){
        
       // self.datereserver = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       self.d = dateFormatter.string(from: datePicker.date)
        
       // print(String(heloo))
       // print(heloo)
        //print(datePicker.date)
       // print("hello");
       // print(datePicker.date)
       // print("hello");
      // print(heloo)
      //  print("hi");
        
    }
    @IBAction func reserver(_ sender: Any) {
        let datefinale2 = "2019-05-28 14:00:00"
  //    print  ( self.datereserver )
      /*  print("http://41.226.11.252:1180/medichelper/insererrendezvous3.php?approuver_Rendezvous=false&FK_Patient_ID=" + self.iduser + "&date=" + self.d + "&cabinet_ID=" + self.idcabinet")
 */
        let var1 = "http://41.226.11.252:1180/medichelper/insererrendezvous3.php?";
        let var2 = "approuver_Rendezvous=false&FK_Patient_ID=" + self.iduser!;
        let var3 = "&date=" + self.d + "&cabinet_ID=" + self.idcabinet! ;
        print("me me")
        print(var1 + var2 + var3)
        Alamofire.request(var1 + var2 + var3).responseJSON{ response in
            
        }
        
       
        
        
        
        let alert = UIAlertController(title: "Votre Rendez vous a été réservé", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
   
    @IBAction func toDiscussion(_ sender: Any) {
         self.performSegue(withIdentifier: "toPatientDiscussion", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPatientDiscussion" {
            let DVC = segue.destination as! DiscussionPatientViewController
            
            DVC.idcabinet = idcabinet
            DVC.idPatient = iduser
            DVC.nonc = self.nonc!
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("la requetes")
        print("http://41.226.11.252:1180/medichelper/getinfocab.php?idpt=" + self.idcabinet!)
        Alamofire.request("http://41.226.11.252:1180/medichelper/getinfocab.php?idpt=" + self.idcabinet!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
           
           
       
        print("tab es tab ")
        print(self.tvShowArray)
        let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
        print("cabinet info")
        print(tvShowDict)
        self.nonc = tvShowDict["Nom_Cabinet"] as! String
        var emp = tvShowDict["Emplacement_Cabinet"] as! String
        var info = tvShowDict["Info_Cabinet"] as! String
        var logcabinet = tvShowDict["longitude"] as! String
        var latcabinet = tvShowDict["Latitude"] as! String
           
            self.emplacementcabinet =  tvShowDict["Emplacement_Cabinet"] as! String
            self.infocabinett = tvShowDict["Info_Cabinet"] as! String
            self.telcabinet = tvShowDict["NumTel_Cabinet"] as! String
            
            
            self.infocabinet.text = " C'est la cabinet de  " + self.nonc!  + "  spécialisé en  " + info + " situé à  " + emp
        print("lat long  hello")
        print(Double(logcabinet))
        print(Double(logcabinet))
        
        var nvlat = Double(latcabinet)
        var nvlog = Double(logcabinet)
        
        
        
        
        print("id cabinet ")
        print(self.idcabinet)
        print(self.iduser)
        print("iduserb ")
        //datepicker = UIDatePicker()
        self.datepicker?.datePickerMode = UIDatePicker.Mode.date
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        let yearbefore : TimeInterval = 0
          let today = NSDate()
        print("year ***************************");
       
        print(yearbefore)
        let dateyearbefore = today.addingTimeInterval(0)
        //    .addingTimeInterval(yearbefore)
       
        
        components.year = -18
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        self.datepicker?.minimumDate = dateyearbefore as Date
        //datepicker?.maximumDate = dateyearbefore as Date
       self.datepicker?.date = currentDate
      //  datepicker?.addTarget(self, action: "datepickerchaged", for: UIControl.Event.valueChanged)
           self.datepicker?.addTarget(self, action: #selector(ReserverRendezvousController.dateChanged(datePicker:)), for: .valueChanged)
        
        
        
        // map
        var s = CGSize.init()
        s.height = 200
        s.width = 400
       
            var p = CGPoint( x: 5, y: 85)
            var res = CGRect(origin: p,size: s)
        let mapView = MGLMapView(frame: res)
        //  mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: nvlat!, longitude: nvlog!), zoomLevel: 12, animated: false)
       self.view.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: nvlat!, longitude: nvlog!)
        hello.title = "Cabinet"
        hello.subtitle = "Welcome to Cabinet docteur"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(hello)
        
        
         }
        
        }
          //6- set the current date/time as a minimum
       // datepicker.date = currentDate as Date
    
    
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    
  
    }
    
    
   
    
    
    
    
    
    
    
    
  

