//
//  AjoutCabinetViewController.swift
//  miniprojetios
//
//  Created by ESPRIT on 5/6/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import Google
import Mapbox


class AjoutCabinetViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate,MGLMapViewDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    var specialite : String = ""
    var adresse : String = ""
    
    var picker1Options = ["Grand tunis", "Bizerte", "région Ouest" ,"Cap Bon", "région est", "région Sud"]
    var picker2Options = ["chirurgie", "Odontologie", "Pédiatrie" ,"Ophtalmologie", "neurochirurgie", "génécologie","Psychiatrie","pseudo-Medecine","Dermatologie"]
    
    @IBOutlet var TFnumero: UITextField!
    @IBOutlet var TFnom: UITextField!
    @IBOutlet var TFspecialite: UITextField!
    
    @IBOutlet var TFadresse: UITextField!
    
    var hello = MGLPointAnnotation()
    
     var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adresse="Grand tunis"
        self.specialite="chirurgie"
        
        // map
        var s = CGSize.init()
        s.height = 200
        s.width = 400
        
        var p = CGPoint( x: 0, y: 80)
        var res = CGRect(origin: p,size: s)
        let mapView = MGLMapView(frame: res)
        //  mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 36.899081, longitude: 10.189350), zoomLevel: 9, animated: false)
        self.view.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        
        hello.coordinate = CLLocationCoordinate2D(latitude: 36.899081, longitude: 10.189350)
        hello.title = "Emplacement"
        hello.subtitle = "veuillez choisir l'emplacement de votre cabinet"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(hello)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print (error ?? "some error")
            return
        }
        
        labelMessage.text = user.profile.email
        
        
        
       
        
    }
    
    @IBOutlet var labelMessage: UILabel!
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    @IBAction func ClickContinue(_ sender: Any) {
        performSegue(withIdentifier: "toInscriptionMedecin", sender: nil)
        print(hello.coordinate.latitude)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInscriptionMedecin"{
            let DVC = segue.destination as! inscriptionMedecinViewController
            
            DVC.NomCabinet = self.TFnom.text!
            DVC.Telephone = self.TFnumero.text!
            //DVC.Specialite = self.TFspecialite.text!
            //DVC.adresse = self.TFadresse.text!
            DVC.Specialite = self.specialite
            DVC.adresse = self.adresse
            DVC.longitude =  String(hello.coordinate.longitude)
            DVC.latitude =  String(hello.coordinate.latitude)
            
            
        }
    }
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
        if pickerView.tag == 1 {
            return picker1Options[row]
        } else {
            return picker2Options[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return picker1Options.count
        } else {
            return picker2Options.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.adresse = picker1Options[row]
        } else {
            self.specialite = picker2Options[row]
        }
        print("specialite"+self.specialite)
        print("adresse"+self.adresse)
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
