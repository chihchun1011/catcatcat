//
//  ViewController.swift
//  catcatcat
//
//  Created by dingyiyi on 2019/3/30.
//  Copyright © 2019 dingyiyi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    //datas
    var whichcat: Int?
    var state: State?
    
    //for connecting
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        
        
        //for set data
//        ref.child("data/cat1").setValue(50)
        
        //for get data
//        ref.child("data/cat1").observe(DataEventType.value, with:{ (snapchat) in
//            let data = snapchat.value!
//            print(data)
//        })
    }

    
    @IBAction func pressLow(_ sender: UIButton) {
        if state == nil{

            state = State.low
            tellFirebase()
        }
        else{
            
        }
    }
    
    @IBAction func pressMedium(_ sender: UIButton) {
        if state == nil{
            
            state = State.medium
            tellFirebase()
        }
        else{
            
        }
    }
    
    @IBAction func pressHigh(_ sender: UIButton) {
        if state == nil{
            
            state = State.high
            tellFirebase()
        }
        else{
            
        }
    }
    func tellFirebase(){
        assert(state != nil)
        
        
    }
    func reset(){
        state = nil
        whichcat = nil
    }
    
    let cats: [Int: String] = [0: "a",1:"b", 2:"c" ]
}
@IBDesignable
class CatImageView: UIView{
    
    @IBInspectable
    var cat: String = "cat1" { didSet{ setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        if let image = UIImage(named: cat,
                        in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
            image.draw(in: bounds)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
    }
    
}
enum State{
    case low
    case medium
    case high
    
    var num: Int{
        switch self {
        case .low:    return 0
        case .medium: return 1
        case .high:   return 2
        }
    }
}
