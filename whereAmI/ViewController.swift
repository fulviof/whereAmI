//
//  ViewController.swift
//  whereAmI
//
//  Created by Fulvio Fanelli on 24/07/2018.
//  Copyright © 2018 ac3000. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    var gerenciadorLocalizacao = CLLocationManager();
    
    @IBOutlet weak var velocidadeLabel: UILabel!
    
    @IBOutlet weak var latidudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var enderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self;
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest;
        gerenciadorLocalizacao.requestWhenInUseAuthorization();
        gerenciadorLocalizacao.startUpdatingLocation();
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUsuario = locations.last!;
        
        let longitude = localizacaoUsuario.coordinate.longitude;
        
        
        
        
        
        let latitude = localizacaoUsuario.coordinate.latitude
        
        longitudeLabel.text = String(longitude);
        latidudeLabel.text = String(latitude);
        
        if localizacaoUsuario.speed > 0 {
            velocidadeLabel.text = String(round(localizacaoUsuario.speed * 1.6));
        }
        
        let deltaLat: CLLocationDegrees = 0.01;
        let deltaLong: CLLocationDegrees = 0.01;
        
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
        
        let areaExibicao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLat, deltaLong);
        
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaExibicao);
        
        mapa.setRegion(regiao, animated: true);
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { (detalhesLocal, erro) in
            
            if erro == nil {
                
                let dadosLocal = detalhesLocal?.first;
                
                var thoroughfare = "";
                
                if dadosLocal?.thoroughfare != nil {
                    
                    thoroughfare = (dadosLocal?.thoroughfare)!;
                }
                
                var subthoroughfare = "";
                
                if dadosLocal?.subThoroughfare != nil {
                    
                    subthoroughfare = (dadosLocal?.subThoroughfare)!;
                }
                
                var locality = "";
                
                if dadosLocal?.locality != nil {
                    
                    locality = (dadosLocal?.locality)!;
                }
                
                var subLocality = "";
                
                if dadosLocal?.subLocality != nil {
                    
                    subLocality = (dadosLocal?.subLocality)!;
                }
                
                self.enderLabel.text = thoroughfare + ", " + subthoroughfare + " - " + locality;
                
            }
            else{
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            
            let alertaController = UIAlertController(title: "Permissão de sequestro", message: "Necessário a localização para te sequestrarmos =^)", preferredStyle: .alert);
            
            let acaoConfiguracao = UIAlertAction(title: "Abrir configurações", style: .default) { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL);
                }
                
            };
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil);
        
            alertaController.addAction(acaoConfiguracao);
            alertaController.addAction(acaoCancelar);
            
            present(alertaController, animated: true, completion: nil);
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

 
