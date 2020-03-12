//
//  TrackpadViewController.swift
//  TrackPad
//
//  Created by Søren Møller Gade Hansen on 17/11/2018.
//  Copyright © 2018 Søren Møller Gade Hansen. All rights reserved.
//

import UIKit
import CoreBluetooth

class TrackpadViewController: UIViewController {
    
    var peripherals: [CBPeripheral] = []
    var manager: CBCentralManager? = nil
    
    // Peertalk properties
    let ptManager = PTManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CBCentralManager(delegate: self, queue: .main)
        
        // Setup PTManager
        ptManager.delegate = self
        ptManager.connect(portNumber: PORT_NUMBER)
        
        // Stop device from sleeping
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Setup tap event listener
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleUserTap))
        
        view.addGestureRecognizer(tapRecognizer)
        
        setupTrackpadLayout()
        
    }
    
    /* When view appears, reconnect */
    override func viewDidAppear(_ animated: Bool) {
        ptManager.connect(portNumber: PORT_NUMBER)
    }
    
    /* When view disappears, disconnect device */
    override func viewDidDisappear(_ animated: Bool) {
        ptManager.disconnect()
    }
    
    // MARK: - Layout setup methods
    
    /* Setup View */
    func setupTrackpadLayout() {
        view.backgroundColor = .white
        
        // Quick fix
        setupUpperCorners()
        
        setupLowerCorners()
    }
    
    /* Setup upper corners */
    func setupUpperCorners() {
        let upperCornerImage = resizeImage(image: UIImage(named: "upperCorner")!, size: CGSize(width: 50, height: 50))
        
        // Left upper corner
        let leftUpperCornerImage = UIImageView(image: upperCornerImage)
        leftUpperCornerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftUpperCornerImage)
        
        // Setup constraints
        leftUpperCornerImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        leftUpperCornerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        // Right upper corner
        let rightUpperCornerImage = UIImageView(image: upperCornerImage)
        rightUpperCornerImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        rightUpperCornerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightUpperCornerImage)
        
        // Setup constraints
        rightUpperCornerImage.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -20 - rightUpperCornerImage.frame.size.width).isActive = true
        rightUpperCornerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    }
    
    /* Setup lower corners */
    func setupLowerCorners() {
        let lowerCornerImage = resizeImage(image: UIImage(named: "lowerCorner")!, size: CGSize(width: 50, height: 50)) 
        
        // Left upper corner
        let leftLowerCornerImage = UIImageView(image: lowerCornerImage)
        leftLowerCornerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftLowerCornerImage)
        
        // Setup constraints
        leftLowerCornerImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        leftLowerCornerImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        // Right upper corner
        let rightLowerCornerImage = UIImageView(image: lowerCornerImage)
        rightLowerCornerImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        rightLowerCornerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightLowerCornerImage)
        
        // Setup constraints
        rightLowerCornerImage.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -20 - rightLowerCornerImage.frame.size.width).isActive = true
        rightLowerCornerImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
    }
    
    /* Resize image */
    func resizeImage(image: UIImage, size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // MARK: - Touch protocol methods
    
    /* When called, it sends coordinates to host */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendTouchesToConnectedDevice(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendTouchesToConnectedDevice(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ptManager.sendObject(object: "0,0", type: PTType.number.rawValue)
    }
    
    @objc func handleUserTap() {
        ptManager.sendObject(object: "0,-1", type: PTType.number.rawValue)
    }
    
    func sendTouchesToConnectedDevice(touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self.view)
            
            let locationString = "\(location.x),\(location.y)"
            
            ptManager.sendObject(object: locationString, type: PTType.number.rawValue)
        }
    }
}
