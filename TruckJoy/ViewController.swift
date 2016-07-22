//
//  ViewController.swift
//  TruckJoy
//
//  Created by Paul on 7/22/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import UIKit
import CoreMotion
import CoreAudioKit


private let maxJoystickValue = (1 << 11) - 1     // 2047
private let totalRotationalRangeInPi = 4


final class ViewController: UIViewController {


    private let midi = PGMidi()
    private let motionManager = CMMotionManager()
    private var joystickX = (maxJoystickValue + 1) / 2


    override func viewDidLoad() {
        super.viewDidLoad()
        midi.delegate = self
        startMotionUpdates()
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    private func startMotionUpdates() {
        motionManager.deviceMotionUpdateInterval = 0.016
        motionManager.startDeviceMotionUpdatesToQueue(.mainQueue()) { [weak self] (motion: CMDeviceMotion?, error: NSError?) in
            if let yaw = motion?.attitude.yaw { self?.sendJoystickValueWithYaw(yaw) }
        }
    }

    private func sendJoystickValueWithYaw(yaw: Double) {
        let x = joystickValueWithYaw(yaw)
        if joystickX == x { return }



        joystickX = x

//        print(x)

        midi.sendBytes([0x90, 60, UInt8(x)], size: 3 * UInt32(sizeof(UInt8)))
    }

    private func joystickValueWithYaw(yaw: Double) -> Int {

        let doubleValue = Double(maxJoystickValue) * (yaw + M_PI) / (2 * M_PI)
        let cappedValue = min(maxJoystickValue, max(0, Int(doubleValue)))

        return cappedValue
    }

    @IBAction private func connect() {
        let audioController = CABTMIDILocalPeripheralViewController()
        showViewController(audioController, sender: nil)
    }

    @IBAction private func playC5(sender: UISwitch) {
        if sender.on {
            midi.sendBytes([0x90, 60, 123], size: 3 * UInt32(sizeof(UInt8)))
        }
        else {
            midi.sendBytes([0x90, 60, 1], size: 3 * UInt32(sizeof(UInt8)))
        }
    }

}

extension ViewController: PGMidiDelegate {

    func midi(midi: PGMidi!, sourceAdded source: PGMidiSource!) {
        print(#function)
    }
    func midi(midi: PGMidi!, sourceRemoved source: PGMidiSource!) {
        print(#function)
    }
    func midi(midi: PGMidi!, destinationAdded destination: PGMidiDestination!) {
        print(#function)
    }
    func midi(midi: PGMidi!, destinationRemoved destination: PGMidiDestination!) {
        print(#function)
    }

}

