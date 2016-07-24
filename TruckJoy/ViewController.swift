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


final class ViewController: UIViewController {


    @IBOutlet var label: UILabel!


    var motionManager:    CMMotionManager!
    var outputController: OutputController!


    override func viewDidLoad() {
        super.viewDidLoad()
        checkDependencies()
        startMotionUpdates()
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    private func checkDependencies() {
        if motionManager == nil {
            motionManager = CMMotionManager()
            motionManager.deviceMotionUpdateInterval = 0.01
        }
        if outputController == nil {
            outputController = JoystickController()
        }
    }

    private func startMotionUpdates() {
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(.XArbitraryCorrectedZVertical,
                                                                  toQueue: .mainQueue())
        { [weak self] (motion, _) in self?.updateWithMotion(motion) }
    }

    private func updateWithMotion(motion: CMDeviceMotion?) {
        guard let yaw = motion?.attitude.yaw else { return }

        self.outputController.updateWithYaw(yaw)
        
        // Debug display
        if let joystickController = outputController as? JoystickController {
            label.text = "\(joystickController.xAxis)"
        }
    }

    @IBAction private func connect() {
        let audioController = CABTMIDILocalPeripheralViewController()
        showViewController(audioController, sender: nil)
    }

    @IBAction private func zero() {
        outputController.reset()
    }

}

