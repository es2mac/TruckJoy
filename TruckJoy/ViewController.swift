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


private let maxJoystickValue = (1 << 12) - 1     // 4095
private let midJoystickValue = (maxJoystickValue + 1) / 2
private let totalRotationalRangeInPi = 5
private let joystickValuePerRotation = 2 * (maxJoystickValue + 1) / totalRotationalRangeInPi
private let tolerance = joystickValuePerRotation / 2



final class ViewController: UIViewController {


    private let midi = PGMidi()
    private let motionManager = CMMotionManager()


    @IBOutlet var label: UILabel!


    private var yaw = 0.0 {
        didSet {    // Calculate scaled yaw
            let scaledYaw = Int(Double(joystickValuePerRotation) * yaw / (2 * M_PI))
            if self.scaledYaw != scaledYaw {
                self.scaledYaw = scaledYaw
            }
        }
    }
    private var joystickOffset = midJoystickValue
    private var scaledYaw = 0 {
        willSet {   // Adjust offset
            let delta = newValue - scaledYaw

            if delta > tolerance {
                joystickOffset -= joystickValuePerRotation
            }
            else if delta < -tolerance {
                joystickOffset += joystickValuePerRotation
            }
        }
        didSet {    // Calculate joystick value
            var joystickX = scaledYaw + joystickOffset
            if joystickX < 0 {
//                joystickOffset = 0 - scaledYaw
                joystickX = 0
            }
            else if joystickX > maxJoystickValue {
//                joystickOffset = maxJoystickValue - scaledYaw
                joystickX = maxJoystickValue
            }
            self.joystickX = joystickX
        }
    }
    private var joystickX = midJoystickValue {
        didSet {    // Send as value as midi
            if (joystickX == oldValue) { return }

            label.text = "\(joystickX)"

            let topValue = UInt8(joystickX >> 7)
            let bottomValue = UInt8(joystickX & 127)

            midi.sendBytes([0x90, 36, bottomValue, 0x90, 48, topValue], size: 6 * UInt32(sizeof(UInt8)))
        }
    }


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
            if let yaw = motion?.attitude.yaw { self?.yaw = yaw }
        }
    }

    @IBAction private func connect() {
        let audioController = CABTMIDILocalPeripheralViewController()
        showViewController(audioController, sender: nil)
    }

    @IBAction private func zero() {
        joystickOffset = midJoystickValue - scaledYaw
        joystickX = midJoystickValue
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

