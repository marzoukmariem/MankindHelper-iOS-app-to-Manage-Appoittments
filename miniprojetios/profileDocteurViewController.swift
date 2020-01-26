//
//  profileDocteurViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 16/05/2019.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import Mapbox

class profileDocteurViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,MGLMapViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    var id:String?
    var idCabinet:String?
    
    @IBOutlet weak var NomMedecin: UITextField!
    @IBOutlet weak var NomCabinet: UITextField!
    @IBOutlet weak var NumeroCabinet: UITextField!
    @IBOutlet weak var TFPrenom: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    var role : String = ""
    var hello = MGLPointAnnotation()
     var tvShowArray : NSArray = []
    
    var pickerData: [String] = [String]()
    @IBOutlet weak var pickler: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Grand tunis", "Bizerte", "région Ouest" ,"Cap Bon", "région est", "région Sud"]
        self.role = "Grand tunis"
        
        Alamofire.request("http://41.226.11.252:1180/medichelper/getelmentdoctoupdate.php?iduser=" + self.id!).responseJSON{ response in
            self.tvShowArray = response.result.value as! NSArray
            
            
            let tvShowDict = self.tvShowArray[0] as! Dictionary<String, Any>
            print(tvShowDict)
            let nomCabinet = tvShowDict["Nom_Cabinet"] as! String
            let adresseCabinet = tvShowDict["Emplacement_Cabinet"] as! String
            
            let email = tvShowDict["Login_User"] as! String
            
            let nom = tvShowDict["Nom_User"] as! String
            let prenom = tvShowDict["Prenom_User"] as! String
            let numero = tvShowDict["NumTel_Cabinet"] as! String
            var logcabinet = tvShowDict["longitude"] as! String
            var latcabinet = tvShowDict["Latitude"] as! String
            
            var nvlat = Double(latcabinet)
            var nvlog = Double(logcabinet)
            
            self.NomCabinet.text = nomCabinet
            self.NumeroCabinet.text = numero
            self.TFPrenom.text = prenom
            self.NomMedecin.text = nom
            
            // map
            var s = CGSize.init()
            s.height = 200
            s.width = 400
            
            var p = CGPoint( x: 5, y: 80)
            var res = CGRect(origin: p,size: s)
            let mapView = MGLMapView(frame: res)
            //  mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: nvlat!, longitude: nvlog!), zoomLevel: 9, animated: false)
            self.view.addSubview(mapView)
            
            // Set the delegate property of our map view to `self` after instantiating it.
            mapView.delegate = self
            
            // Declare the marker `hello` and set its coordinates, title, and subtitle.
            
            self.hello.coordinate = CLLocationCoordinate2D(latitude: nvlat!, longitude: nvlog!)
            self.hello.title = "Emplacement"
            self.hello.subtitle = "veuillez choisir l'emplacement de votre cabinet"
            
            // Add marker `hello` to the map.
            mapView.addAnnotation(self.hello)
        }
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func update(_ sender: Any) {
        var url:String = "nomcabinet=" + NomCabinet.text!.replacingOccurrences(of: " ", with: "%20") + "&logitude=" + String(hello.coordinate.longitude)
    
        var url2:String =  "&latitude=" + String(hello.coordinate.latitude) + "&nom=" + NomMedecin.text!.replacingOccurrences(of: " ", with: "%20")
        var url3:String = "&prenom=" + TFPrenom.text! + "&numtel="+NumeroCabinet.text!
        
        var url4:String = "&emplacement=" + self.role.replacingOccurrences(of: " ", with: "%20")
        
        var url5:String = "&idCabinet=" + idCabinet! + "&iddoc="+id!
        
        print("http://41.226.11.252:1180/medichelper/updatedocIos.php?" + url + url2 + url3 + url4 + url5)
        Alamofire.request("http://41.226.11.252:1180/medichelper/updatedocIos.php?" + url + url2 + url3 + url4 + url5).responseJSON{ response in
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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.role = pickerData[row]
        print(self.role)
    }
    
    
    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // For better performance, always try to reuse existing annotations. To use multiple different annotation views, change the reuse identifier for each.
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "draggablePoint") {
            return annotationView
        } else {
            return DraggableAnnotationView(reuseIdentifier: "draggablePoint", size: 50)
        }
        
        
        
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    @IBAction func save(_ sender: Any) {
        
    }
    
    class DraggableAnnotationView: MGLAnnotationView {
        init(reuseIdentifier: String, size: CGFloat) {
            super.init(reuseIdentifier: reuseIdentifier)
            
            // `isDraggable` is a property of MGLAnnotationView, disabled by default.
            isDraggable = true
            
            // This property prevents the annotation from changing size when the map is tilted.
            scalesWithViewingDistance = false
            
            // Begin setting up the view.
            frame = CGRect(x: 0, y: 0, width: size, height: size)
            
            backgroundColor = .darkGray
            
            // Use CALayer’s corner radius to turn this view into a circle.
            layer.cornerRadius = size / 2
            layer.borderWidth = 1
            layer.borderColor = UIColor.white.cgColor
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
            
        }
        
        // These two initializers are forced upon us by Swift.
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // Custom handler for changes in the annotation’s drag state.
        override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
            super.setDragState(dragState, animated: animated)
            
            switch dragState {
            case .starting:
                print("Starting", terminator: "")
                startDragging()
            case .dragging:
                print(".", terminator: "")
            case .ending, .canceling:
                print("Ending")
                endDragging()
            case .none:
                return
            }
        }
        
        // When the user interacts with an annotation, animate opacity and scale changes.
        func startDragging() {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                self.layer.opacity = 0.8
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            }, completion: nil)
            
            // Initialize haptic feedback generator and give the user a light thud.
            if #available(iOS 10.0, *) {
                let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                hapticFeedback.impactOccurred()
            }
        }
        
        func endDragging() {
            transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                self.layer.opacity = 1
                self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }, completion: nil)
            
            // Give the user more haptic feedback when they drop the annotation.
            if #available(iOS 10.0, *) {
                let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                hapticFeedback.impactOccurred()
            }
            print(self.annotation!.coordinate.latitude)
        }
    }
}


