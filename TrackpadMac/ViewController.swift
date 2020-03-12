//
//  ViewController.swift
//  TrackpadMac
//
//  Created by Søren Møller Gade Hansen on 24/11/2018.
//  Copyright © 2018 Søren Møller Gade Hansen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let ptManager = PTManager.instance
    
    var mouseStartLocation: NSPoint?
    var touchStartLocation: NSPoint?
    var updateLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup PTManager
        ptManager.delegate = self
        ptManager.connect(portNumber: PORT_NUMBER)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}

extension ViewController: PTManagerDelegate {
    
    func peertalk(shouldAcceptDataOfType type: UInt32) -> Bool {
        return true
    }
    
    func peertalk(didReceiveData data: Data, ofType type: UInt32) {
        if type == PTType.number.rawValue {
            let dataString = data.convert() as! String
            
            // Convert string to CGPoint
            let pointTapped = dataString.components(separatedBy: "").map { (NSPointFromString("{\($0)}")) }.first!
            
            //            print(pointTapped)
            
            // User has stopped touching the surface
            if pointTapped == NSPoint(x: 0, y: 0) {
                mouseStartLocation = nil
                updateLocation = true
                return
            } else if updateLocation {
                // Set relative mouse position
                mouseStartLocation = NSEvent.mouseLocation
                touchStartLocation = pointTapped
                updateLocation = false
            }
            
            // Get screen bounds
            let screenFrame = NSScreen.main!.frame
            
            let touchXVector = pointTapped.x - touchStartLocation!.x
            let touchYVector = pointTapped.y - touchStartLocation!.y
            
            var mouseNewLocation = NSPoint(x: mouseStartLocation!.x + touchXVector, y: screenFrame.height - mouseStartLocation!.y + touchYVector)
            
            // See if x-axis exceeds screen bounds
            if mouseNewLocation.x > screenFrame.width {
                mouseNewLocation.x = screenFrame.width
            } else if mouseNewLocation.x < 0 {
                mouseNewLocation.x = 0
            }
            
            // See if y-axis exceeds screen bounds
            if mouseNewLocation.y > screenFrame.height {
                mouseNewLocation.y = screenFrame.height
            } else if mouseNewLocation.y < 0 {
                mouseNewLocation.y = 0
            }
            
            // Listen for tap command
            if pointTapped == NSPoint(x: 0, y: -1) {
                CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: NSPoint(x: mouseStartLocation!.x, y: screenFrame.height - mouseStartLocation!.y), mouseButton: .left)?.post(tap: .cghidEventTap)
                CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: NSPoint(x: mouseStartLocation!.x, y: screenFrame.height - mouseStartLocation!.y), mouseButton: .left)?.post(tap: .cghidEventTap)
                updateLocation = true
                return
            }
            
            //            print(mouseNewLocation)
            
            CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: mouseNewLocation, mouseButton: .left)?.post(tap: .cghidEventTap)
            
        }
    }
    
    func peertalk(didChangeConnection connected: Bool) {
        print("Connection \(connected)")
    }
    
}
