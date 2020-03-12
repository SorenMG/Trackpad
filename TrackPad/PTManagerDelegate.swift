//
//  PTManagerDelegate.swift
//  TrackPad
//
//  Created by Søren Møller Gade Hansen on 18/11/2018.
//  Copyright © 2018 Søren Møller Gade Hansen. All rights reserved.
//

extension TrackpadViewController: PTManagerDelegate {
    
    func peertalk(shouldAcceptDataOfType type: UInt32) -> Bool {
        return true
    }
    
    func peertalk(didReceiveData data: Data, ofType type: UInt32) {
        return
    }
    
    func peertalk(didChangeConnection connected: Bool) {
        print("Connection: \(connected)")
    }
    
}
