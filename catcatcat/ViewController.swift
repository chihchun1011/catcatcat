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
    let cats: [Int: String] = [1: "cat1",2:"cat2", 3:"cat3" ]
    var whichcat: Int? = nil {
        didSet{
            if whichcat != nil{
                catImage.cat = cats[whichcat!]!
            }
        }
    }

    var hadRequestedFromCat: Bool = false
    
    
    
    
    //for connecting
    var ref: DatabaseReference!
    
    
    var timer: Timer?
    var forcefeed = false
    
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
//        for button in controlButton{
//            button.layer.cornerRadius = 8.0
//        }
//        FeedButton.layer.cornerRadius = 8.0
//        HistoryButton.layer.cornerRadius = 8.0
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil{ timer?.invalidate() }
    }
    @IBOutlet weak var catImage: CatImageView!
    
    @IBAction func pressLow(_ sender: UIButton) {
        if forcefeed{
            feedCat(for: feedMass.low)
            FeedButton.layer.borderWidth = 0
        }
        else{
            if !tellFirebase(for: feedMass.low){
                //unsuccessful
                
                
            }
        }
        
        
    }
    
    @IBOutlet var controlButton: [UIButton]!
    @IBOutlet weak var FeedButton: UIButton!
    @IBOutlet weak var HistoryButton: UIButton!
    
    @IBAction func pressMedium(_ sender: UIButton) {
        if forcefeed{
            feedCat(for: feedMass.medium)
            FeedButton.layer.borderWidth = 0
        }
        else{
            if !tellFirebase(for: feedMass.medium){
                //unsuccessful
                
                
            }
        }
    }
    
    @IBAction func pressHigh(_ sender: UIButton) {
        if forcefeed{
            feedCat(for: feedMass.high)
            FeedButton.layer.borderWidth = 0
        }
        else{
            if !tellFirebase(for: feedMass.high){
                //unsuccessful
                
                
            }

        }
    }
    
    @IBAction func ForceFeed(_ sender: UIButton) {
        if !forcefeed{
            forcefeed = true
            FeedButton.layer.borderWidth = 4.0
            FeedButton.layer.borderColor = UIColor.white.cgColor
        }
        else{
            forcefeed = false
            FeedButton.layer.borderWidth = 0
        }
        
    }
    
    func tellFirebase(for mass: feedMass) -> Bool{
        if hadRequestedFromCat {
            ref.child("cache/messageFromApps").setValue(mass.num)
            hadRequestedFromCat = false
            return true
        }
        else{
            return false
        }
        
    }
    func feedCat(for mass: feedMass){
        ref.child("cache/messageFromApps").setValue(mass.num)
        
        
    }
}
    
//for setting data
//        ref.child("data/cat1").setValue(50)

//for getting data
//        ref.child("data/cat1").observe(DataEventType.value, with:{ (snapchat) in
//            let data = snapchat.value!
//            print(data)
//        })
    
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
        case .low:    return 1
        case .medium: return 2
        case .high:   return 3
        }
    }
}
