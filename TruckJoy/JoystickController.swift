//
//  JoystickController.swift
//  TruckJoy
//
//  Created by Paul on 7/23/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import Foundation


private let maxXAxis                 = (1 << 12) - 1// 4095
private let midXAxis                 = (maxXAxis + 1) / 2
private let totalRotationalRangeInPi = 5
private let xValuePerRotation        = 2 * (maxXAxis + 1) / totalRotationalRangeInPi
private let tolerance                = xValuePerRotation / 2


final class JoystickController: NSObject, OutputController {


    var xAxis = midXAxis {
        didSet {
            if xAxis != oldValue {
                midiHandler.send(.modulationWheel(value: UInt16(xAxis)))
            }
        }
    }


    private let midiHandler: MidiHandler

    private var yaw       = 0.0
    private var scaledYaw = 0
    private var xOffset   = midXAxis


    init(midiHandler: MidiHandler) {
        self.midiHandler = midiHandler
    }

    convenience override init() {
        self.init(midiHandler: MidiController())
    }


    func updateWithYaw(yaw: Double) {
        let newScaledYaw = Int(Double(xValuePerRotation) * yaw / (2 * M_PI))
        let delta        = newScaledYaw - scaledYaw
        scaledYaw        = newScaledYaw

        guard delta != 0 else { return }

        // Adjust for pi <--> -pi flip
        if delta > tolerance {
            xOffset -= xValuePerRotation
        }
        else if delta < -tolerance {
            xOffset += xValuePerRotation
        }

        // Calculate X-axis
        xAxis = min(max(scaledYaw + xOffset, 0), maxXAxis)
    }

    func reset() {
        xAxis   = midXAxis
        xOffset = xAxis - scaledYaw// xAxis = scaledYaw + xOffset
    }

}

