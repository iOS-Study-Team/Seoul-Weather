//
//  MapViewController.swift
//  Seoul-Weather
//
//  Created by KimSuyoung on 12/06/2018.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
import WebKit

class MapViewController: UIViewController {
    
    enum MapType {
        case Atype, Btype, Dtype
    }
    var choiceType = MapType.Atype
    
    let wkwebView = WKWebView()
    let daumView = MTMapView()
    
    @IBOutlet weak var svgView = UIView()
    
    @IBAction func touchUpButton(_ sender: UIButton) {
        
        if choiceType == MapType.Dtype {
            updateMarkerState()
        } else {
            updateImageState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorizeView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadMap()
    }

    private func colorizeView() {
        guard choiceType == MapType.Btype else { return }
        let themeColor = UIColor.init(hexString: "#696969")
        view.backgroundColor = themeColor
        svgView?.backgroundColor = themeColor
    }
    
    private func loadMap() {
        if choiceType == MapType.Dtype {
            loadDaumMap()
        } else {
            loadSVGMap()
        }
    }
    
}

// Web View 관련 메소드
extension MapViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let svgframe = svgView?.frame else {
            return
        }
        wkwebView.frame = svgframe
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.addSubview(wkwebView)
    }
    
    private func loadSVGMap() {
        let type = choiceType==MapType.Atype ? "mSeoul_type_A" : "mSeoul_type_B"
        let htmlPath = Bundle.main.path(forResource: type, ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        wkwebView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        wkwebView.navigationDelegate = self
        wkwebView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        wkwebView.scrollView.showsVerticalScrollIndicator = false
        
    }
    
    private func updateImageState() {
        
        for id in 0...24 {
            let imageState = arc4random_uniform(5)
            let script = "region_click(\(id), \(imageState));"
            wkwebView.evaluateJavaScript(script) { (result, error) in
                if error != nil {
                    print(error.debugDescription)
                }
            }
        }
        
    }
    
}

// Daum Map View 관련 메소드
extension MapViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, openAPIKeyAuthenticationResultCode resultCode: Int32, resultMessage: String!) {
        if daumView.frame == svgView?.frame {
            return
        }
        
        if let svgframe = svgView?.frame {
            daumView.frame = svgframe
        }
    }
    
    
    private func loadDaumMap() {
        daumView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        daumView.delegate = self
        daumView.baseMapType = .standard
        daumView.setZoomLevel(6, animated: false)
        view.addSubview(daumView)
        
        loadGuData()
    }
    
    private func loadGuData() {
        addMarker(name: "중구", latitude: 37.557335, longitude: 126.997985)
        addMarker(name: "강서구", latitude: 37.55844, longitude: 126.824859)
        addMarker(name: "서대문구", latitude: 37.574997, longitude: 126.941155)
        addMarker(name: "은평구", latitude: 37.616431, longitude: 126.929119)
        addMarker(name: "강북구", latitude: 37.64071, longitude: 127.013272)
        addMarker(name: "성북구", latitude: 37.602917, longitude: 127.019697)
        addMarker(name: "종로구", latitude: 37.592128, longitude: 126.97942)
        addMarker(name: "동대문구", latitude: 37.579132, longitude: 127.057221)
        addMarker(name: "광진구", latitude: 37.543059, longitude: 127.088351)
        addMarker(name: "송파구", latitude: 37.502168, longitude: 127.118003)
        addMarker(name: "강남구", latitude: 37.493712, longitude: 127.065334)
        addMarker(name: "서초구", latitude: 37.47074, longitude: 127.033245)
        addMarker(name: "동작구", latitude: 37.496075, longitude: 126.953734)
        addMarker(name: "영등포구", latitude: 37.519739, longitude: 126.912303)
        addMarker(name: "용산구", latitude: 37.528582, longitude: 126.981987)
        addMarker(name: "성동구", latitude: 37.54824, longitude: 127.043114)
        addMarker(name: "양천구", latitude: 37.52194, longitude: 126.857526)
        addMarker(name: "구로구", latitude: 37.491581, longitude: 126.858351)
        addMarker(name: "관악구", latitude: 37.46457, longitude: 126.947435)
        addMarker(name: "금천구", latitude: 37.457775, longitude: 126.902894)
        addMarker(name: "도봉구", latitude: 37.66633, longitude: 127.034471)
        addMarker(name: "중랑구", latitude: 37.595194, longitude: 127.095157)
        addMarker(name: "마포구", latitude: 37.556708, longitude: 126.910326)
        addMarker(name: "노원구", latitude: 37.649734, longitude: 127.077134)
        addMarker(name: "강동구", latitude: 37.547522, longitude: 127.149107)
        
    }
    
    private func addMarker(name: String, latitude: Double, longitude: Double) {
        
        let point = MTMapPOIItem()
        point.itemName = name
        point.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        point.markerType = .customImage
        point.showAnimationType = .noAnimation
        point.draggable = false
        point.showDisclosureButtonOnCalloutBalloon = false
        point.tag = daumView.poiItems.count
        
        let image = UIImage(named: "small_check")
        point.customImage = image
        daumView.add(point)
        daumView.fitAreaToShowAllPOIItems()
    }
    
    private func updateMarkerState() {
        
        for point in daumView.poiItems {
            guard let point: MTMapPOIItem = point as? MTMapPOIItem else {
                return
            }
            daumView.remove(point)
            
            let state = Int(arc4random_uniform(5))
            let name = getMarkerStateName(num: state)
            let image = UIImage(named: "small_"+name)
            point.customImage = image
            daumView.add(point)
        }
        
    }
    
    private func getMarkerStateName(num: Int) -> String {
        switch num {
        case 0:
            return "good"
        case 1:
            return "normal"
        case 2:
            return "bad"
        case 3:
            return "toobad"
        case 4:
            return "check"
        default:
            fatalError("marker 상태를 확인해주세요")
        }
    }
    
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
}
