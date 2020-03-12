//
//  CentralBluetoothManager.swift
//  TrackPad
//
//  Created by Søren Møller Gade Hansen on 17/11/2018.
//  Copyright © 2018 Søren Møller Gade Hansen. All rights reserved.
//

import UIKit
import CoreBluetooth

extension TrackpadViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            //manager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            // Add peripheral
            peripherals.append(peripheral)
            NSLog("Peripheral discovered \(peripheral)")
            
            // QUICK FIX - Connect to Macbook
            if peripheral.identifier == UUID(uuidString: "786999C3-7CCE-1D18-F801-99C3277CF682") {
                manager?.connect(peripheral, options: nil)
                
                // TODO: - Connect and communicate with Macbook
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
    }
    
    
}
