//
//  ViewController2.swift
//  TweetFromSpace
//
//  Created by K on 2020/10/04.
//  Copyright © 2020 K. All rights reserved.
//

import UIKit
import SocketIO

class ViewController2: UIViewController {
    
    let manager = SocketManager(socketURL: URL(string: "http://lit-stram-05733.herokuapp.com:80/")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var dataList: NSMutableArray! = []
    
    @IBAction func socketBtn(_ sender: Any) {
        wsConnect()
//        socket.emit("from_client", "button pushed!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View2 Start")
        
        dataList = NSMutableArray()
        socket = manager.defaultSocket
    }
    
    func wsConnect(){
        // Prepare for start to socket connection
        socket.on(clientEvent: .connect){ data, ack in
            print("socket connected!")
        }
        socket.on(clientEvent: .disconnect){ data, ack in
            print("socket disconnected!")
        }
        socket.on("from_server"){ data, ack in
            if let message = data as? [String]{
                print(message[0])
                self.dataList.insert(message[0], at: 0)
            }
        }
        socket.connect()
    }
    
}
