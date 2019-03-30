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
            
            self.ref.child("data/cat2/history").observe(DataEventType.value, with:{ (snapchat) in
                let data = snapchat.value! 
                print(data)
//                if data!.count > 0{
//                    for index in 0 ..< data!.count{
//                        self.masses[index] = (data![index])["foodMass"]!
//                        print(self.masses[index])
//                    }
//                }
                
            })
                
        })
    }
    var masses: [Int] = [0, 0, 0, 0, 0]
    var times: [String] = ["","","","",""]
    var mtbool: [Bool] = [false,false,false,false,false]
    

    
}
