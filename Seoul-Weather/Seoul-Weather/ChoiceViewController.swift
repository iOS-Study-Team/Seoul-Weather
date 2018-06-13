//
//  ChoiceViewController.swift
//  Seoul-Weather
//
//  Created by KimSuyoung on 13/06/2018.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination: MapViewController = segue.destination as! MapViewController else { return }
        
        switch segue.identifier {
        case .some("atype"):
            destination.choiceType = MapViewController.MapType.Atype
        case .some("btype"):
            destination.choiceType = MapViewController.MapType.Btype
        case .some("dtype"):
            destination.choiceType = MapViewController.MapType.Dtype
        default:
            fatalError("지도타입을 확인해주세요")
        }
    }
}
