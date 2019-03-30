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
            FeedButton.layer.borderColor = UIColor.black.cgColor
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
class Cat1TableViewController: UITableViewController {
    var masstime: [(Int)] {
        var ret = [(Int)]()
        for _ in 1...7{
            ret.append((0))
        }
        return ret
    }
    var mtbool = [false,true,true,false,false,false,false]
    
    @IBOutlet weak var mass1: UILabel!
    @IBOutlet weak var mass2: UILabel!
    @IBOutlet weak var mass3: UILabel!
    @IBOutlet weak var mass4: UILabel!
    @IBOutlet weak var mass5: UILabel!
    @IBOutlet weak var mass6: UILabel!
    @IBOutlet weak var mass7: UILabel!
    
//    func setMass(){
//        for mtindex in mtbool.indices{
//            if mtbool[mtindex]{
//                switch mtindex{
//                case 0:
//                    mass1.text = "Mass: \(masstime[mtindex])"
//                case 1:
//                    mass1.text = "Mass: \(masstime[mtindex])"
//                case 2:
//                    mass1.text = "Mass: \(masstime[mtindex])"
//                case 3:
//                    mass1.text = "Mass: \(masstime[mtindex])"
//                case 4:
//                    mass1.text = "Mass: \(masstime[mtindex])"
//                case 5:
//                    mass1.text = "Mass: \(masstime[mtindex])"
//                case 6:
//                    mass1.text = "Mass: \(masstime[mtindex])"
//                default: break
//
//
//                }
//            }
//        }
//    }
//
    

    
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
