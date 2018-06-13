//
//  SimpleMapViewController.swift
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorizeView()
        loadMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        loadMap()
        
        var items = [MTMapPOIItem]()
        items.append(mpoiItem(name: "하나", latitude: 37.4981688, longitude: 127.0484572))
        items.append(mpoiItem(name: "둘", latitude: 37.4987963, longitude: 127.0415946))
        items.append(mpoiItem(name: "셋", latitude: 37.5025612, longitude: 127.0415946))
        items.append(mpoiItem(name: "넷", latitude: 37.5037539, longitude: 127.0426469))
        //위 부분은 viewDidLoad()에서 수행해도 괜찮습니다
        
        daumView.addPOIItems(items)
        daumView.fitAreaToShowAllPOIItems()  // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    private func colorizeView() {
        guard choiceType == MapType.Btype else { return }
        let themeColor = UIColor.init(hexString: "#696969")
        view.backgroundColor = themeColor
        svgView?.backgroundColor = themeColor
    }
    
    private func loadMap() {
        guard choiceType != MapType.Dtype else {
            loadDaumMap()
            return
        }
        
        let type = choiceType==MapType.Atype ? "mSeoul_type_A" : "mSeoul_type_B"
        let htmlPath = Bundle.main.path(forResource: type, ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        wkwebView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        wkwebView.navigationDelegate = self
        wkwebView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        wkwebView.scrollView.showsVerticalScrollIndicator = false
    }
    
    private func loadDaumMap() {
        daumView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        daumView.delegate = self
        daumView.baseMapType = .standard
        
        let mapPointGeo = MTMapPointGeo(latitude: 37.526804306404337, longitude: 126.96612433919596)
        let mapPoint = MTMapPoint(geoCoord: mapPointGeo)
        daumView.setMapCenter(mapPoint, zoomLevel: 7, animated: true)
        view.addSubview(daumView)
        view.insertSubview(daumView, at: 0)
        
        addMarker()
        
    }
    
    private func addMarker() {
        
        var items = [MTMapPOIItem]()
        
        
        let point = MTMapPOIItem()
        point.itemName = "시청역"
        point.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.526804306404337, longitude: 126.96612433919596))
        point.markerType = .redPin
        point.markerSelectedType = .redPin
        point.showAnimationType = .noAnimation
        point.draggable = true
        point.tag = 153
        point.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 30, offsetY: 0)
        items.append(point)
        
        //
        point.itemName = "시청역"
        point.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.537229, longitude: 127.005515))
        point.markerType = .redPin
        point.showAnimationType = .noAnimation
        point.draggable = true
        point.tag = 153
        point.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 30, offsetY: 0)
        items.append(point)
        
        daumView.addPOIItems(items)
        let i = MTMapLocationMarkerItem()
        print(i)
        daumView.updateCurrentLocationMarker(i)
        daumView.fitAreaToShowAllPOIItems()
    }
    
    //    Swift
    //
    //    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
    //        let item = MTMapPOIItem()
    //        item.itemName = name
    //        item.markerType = .redPin
    //        item.markerSelectedType = .redPin
    //        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
    //        item.showAnimationType = .noAnimation
    //        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
    //
    //        return item
    //    }
    //
    //
    func mpoiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .redPin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        
        return item
    }
    
}

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
    
    
}

extension MapViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        guard let svgframe = svgView?.frame else {
            return
        }
        daumView.frame = svgframe
    }
    
    func mapView(_ mapView: MTMapView!, openAPIKeyAuthenticationResultCode resultCode: Int32, resultMessage: String!) {
        view.addSubview(daumView)
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
