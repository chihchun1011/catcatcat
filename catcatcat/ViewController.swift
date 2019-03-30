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
    let cats: [Int: String] = [0: "cat1",1:"cat2", 2:"cat3" ]
    var whichcat: Int? = nil {didSet{
            catImage.cat = cats[whichcat!]!
        }}
    var feedmass: feedMass?
    var hadRequestedFromCat: Bool = false
    
    
    
    
    //for connecting
    var ref: DatabaseReference!
    
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {_ in
            
//            print(Date())
            self.ref.child("cache/requestFromDevice").observe(DataEventType.value, with:{ (snapchat) in
                let data = snapchat.value! as? Int
//                print(data)
                
                
                
                if data == -1 {
                    // do nothing
                }
                else{
                    //without checking data's validility
                    self.whichcat = data
                    self.hadRequestedFromCat = true
                    
                    // modify database cache (requestFromDevice) back to initial state (-1)
                    self.ref.child("cache/requestFromDevice").setValue(-1)
                    
                }
                
            })

        })
        
        //for setting data
//        ref.child("data/cat1").setValue(50)
        
        //for getting data
//        ref.child("data/cat1").observe(DataEventType.value, with:{ (snapchat) in
//            let data = snapchat.value!
//            print(data)
//        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil{ timer?.invalidate() }
    }
    @IBOutlet weak var catImage: CatImageView!
    
    @IBAction func pressLow(_ sender: UIButton) {
        if feedmass == nil{

            feedmass = feedMass.low
            tellFirebase()
        }
        else{
            
        }
    }
    
    @IBAction func pressMedium(_ sender: UIButton) {
        if feedmass == nil{
            
            feedmass = feedMass.medium
            tellFirebase()
        }
        else{
            
        }
    }
    
    @IBAction func pressHigh(_ sender: UIButton) {
        if feedmass == nil{
            
            feedmass = feedMass.high
            tellFirebase()
        }
        else{
            
        }
    }
    func tellFirebase(){
        assert(feedmass != nil)
        
        
        
        
    }
    func feedCat(){
        
        
        
    }
    func reset(){
        feedmass = nil
        whichcat = nil
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        var timer: Timer?
////        testqueue(at: ref)
////        testworkitem(at: ref)
//    }
    

}
//func testworkitem(at ref: DatabaseReference){
//    let workitem = DispatchWorkItem {
//        ref.child("data/cat1").observe(DataEventType.value, with:{ (snapchat) in
//            let data = snapchat.value!
//            print(data)
//        })
//    }
//    let timedelay: DispatchTimeInterval = .seconds(2)
//    let queue = DispatchQueue(label: "com.appcoda.queue1", qos: .userInitiated)
//    while true{
//        queue.asyncAfter(deadline: .now()+timedelay, execute: workitem)
////        workitem.notify(queue: DispatchQueue.main){
////            print("haha")
////        }
//    }
//
//}



//func testqueue(at ref: DatabaseReference){
////    let queue1 = DispatchQueue(label: "com.appcoda.queue1", qos: DispatchQoS.userInitiated)
//    let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.background)
////
////    queue1.async {
////        for i in 1...10{
////            print("• ",i)
////        }
////    }
//
//    var timer: Timer?
//    queue2.async {
////        while true {
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {_ in
//
//            print(Date())
//            ref.child("data/cat1").observe(DataEventType.value, with:{ (snapchat) in
//                let data = snapchat.value!
//                print(data)
//            })
//
//        })
//
////            let timedelay: DispatchTimeInterval = .seconds(2)
//
//
////        }
//    }
//    if (timer != nil) {timer?.invalidate()}
////
//}


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


enum feedMass{
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
