//
//  Cat2HistoryViewController.swift
//  catcatcat
//
//  Created by dingyiyi on 2019/3/31.
//  Copyright © 2019 dingyiyi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Cat2HistoryViewController: UIViewController {
    
    
    //for connecting
    var ref: DatabaseReference!
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {_ in
            
            self.ref.child("data/cat3/history").observe(DataEventType.value, with:{ (snapchat) in
                let data = snapchat.value! as? NSMutableArray
//                let data = snapchat.value!
                var index = 0
                
                
                for dataindex in stride(from: data!.count, to: (((data!.count-5) > 0) ?  (data!.count-5) : 0), by: -1){

                    let massnum = ( (data![dataindex-1] as? [String:Any])?["foodMass"] )!
                    self.masses[index] = (massnum as? Int)!
                    
                    let timestr = ( (data![dataindex-1] as? [String:Any])?["time"] )!
                    var tmp = (timestr as? String)!
                    tmp.insert("/", at: tmp.index(tmp.startIndex, offsetBy: 4))
                    tmp.insert("/", at: tmp.index(tmp.startIndex, offsetBy: 7))
                    tmp.insert(" ", at: tmp.index(tmp.startIndex, offsetBy: 10))
                    tmp.insert(":", at: tmp.index(tmp.startIndex, offsetBy: 13))
                    
                    self.times[index] = tmp
                    
//                    print(index)
//                    print(data![dataindex-1])
//                    print((data![index] as? [String:Any])!)
//                    print( ( (data![index] as? [String:Any])?["foodMass"] )! )
//                    print(self.masses[index])
//                    print(self.times[index])
                    index += 1
                }
                
//                print(data)
//                print(type(of: data))
//
                
            })
                
        })
    }
    var masses: [Int] = [0, 0, 0, 0, 0]{
        didSet{
            var i=0
            for label in massLabels{
                label.text = "Mass: \(masses[i])"
                i+=1
            }
        }
    }
    var times: [String] = ["N/A","N/A","N/A","N/A","N/A"]{
        didSet{
            var i=0
            for label in timeLabels{
                label.text = "Time: " + times[i]
                i+=1
            }
        }
    }
    var mtbool: [Bool] = [false,false,false,false,false]
    
    
    @IBOutlet var massLabels: [UILabel]!
    @IBOutlet var timeLabels: [UILabel]!
    
    
}
class Cat1HistoryViewController: UIViewController {
    
    
    //for connecting
    var ref: DatabaseReference!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {_ in
            
            self.ref.child("data/cat2/history").observe(DataEventType.value, with:{ (snapchat) in
                let data = snapchat.value! as? NSMutableArray
                //                let data = snapchat.value!
                var index = 0
                
                
                for dataindex in stride(from: data!.count, to: (((data!.count-5) > 0) ?  (data!.count-5) : 0), by: -1){
                    
                    let massnum = ( (data![dataindex-1] as? [String:Any])?["foodMass"] )!
                    self.masses[index] = (massnum as? Int)!
                    
                    let timestr = ( (data![dataindex-1] as? [String:Any])?["time"] )!
                    var tmp = (timestr as? String)!
                    tmp.insert("/", at: tmp.index(tmp.startIndex, offsetBy: 4))
                    tmp.insert("/", at: tmp.index(tmp.startIndex, offsetBy: 7))
                    tmp.insert(" ", at: tmp.index(tmp.startIndex, offsetBy: 10))
                    tmp.insert(":", at: tmp.index(tmp.startIndex, offsetBy: 13))
                    
                    self.times[index] = tmp
                    
                    //                    print(index)
                    //                    print(data![dataindex-1])
                    //                    print((data![index] as? [String:Any])!)
                    //                    print( ( (data![index] as? [String:Any])?["foodMass"] )! )
//                    print(self.masses[index])
//                    print(self.times[index])
                    index += 1
                }
                
                //                print(data)
                //                print(type(of: data))
                //
                
            })
            
        })
    }
    var masses: [Int] = [0, 0, 0, 0, 0]{
        didSet{
            var i=0
            for label in massLabels{
                label.text = "Mass: \(masses[i])"
                i+=1
            }
        }
    }
    var times: [String] = ["N/A","N/A","N/A","N/A","N/A"]{
        didSet{
            var i=0
            for label in timeLabels{
                label.text = "Time: " + times[i]
                i+=1
            }
        }
    }
    var mtbool: [Bool] = [false,false,false,false,false]
    
    
    @IBOutlet var massLabels: [UILabel]!
    @IBOutlet var timeLabels: [UILabel]!
    
    
}

class Cat0HistoryViewController: UIViewController {
    
    
    //for connecting
    var ref: DatabaseReference!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {_ in
            
            self.ref.child("data/cat1/history").observe(DataEventType.value, with:{ (snapchat) in
                let data = snapchat.value! as? NSMutableArray
                //                let data = snapchat.value!
                var index = 0
                
                
                for dataindex in stride(from: data!.count, to: (((data!.count-5) > 0) ?  (data!.count-5) : 0), by: -1){
                    
                    let massnum = ( (data![dataindex-1] as? [String:Any])?["foodMass"] )!
                    self.masses[index] = (massnum as? Int)!
                    
                    let timestr = ( (data![dataindex-1] as? [String:Any])?["time"] )!
                    var tmp = (timestr as? String)!
                    tmp.insert("/", at: tmp.index(tmp.startIndex, offsetBy: 4))
                    tmp.insert("/", at: tmp.index(tmp.startIndex, offsetBy: 7))
                    tmp.insert(" ", at: tmp.index(tmp.startIndex, offsetBy: 10))
                    tmp.insert(":", at: tmp.index(tmp.startIndex, offsetBy: 13))
                    
                    self.times[index] = tmp
                    
                    //                    print(index)
                    //                    print(data![dataindex-1])
                    //                    print((data![index] as? [String:Any])!)
                    //                    print( ( (data![index] as? [String:Any])?["foodMass"] )! )
                    //                    print(self.masses[index])
                    //                    print(self.times[index])
                    index += 1
                }
                
                //                print(data)
                //                print(type(of: data))
                //
                
            })
            
        })
    }
    var masses: [Int] = [0, 0, 0, 0, 0]{
        didSet{
            var i=0
            for label in massLabels{
                label.text = "Mass: \(masses[i])"
                i+=1
            }
        }
    }
    var times: [String] = ["N/A","N/A","N/A","N/A","N/A"]{
        didSet{
            var i=0
            for label in timeLabels{
                label.text = "Time: " + times[i]
                i+=1
            }
        }
    }
    var mtbool: [Bool] = [false,false,false,false,false]
    
    
    @IBOutlet var massLabels: [UILabel]!
    @IBOutlet var timeLabels: [UILabel]!
    
    
}
