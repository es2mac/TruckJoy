//
//  JoystickController.swift
//  TruckJoy
//
//  Created by Paul on 7/23/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import Foundation


private let maxXAxis                 = (1 << 12) - 1        // 4095
private let midXAxis                 = (maxXAxis + 1) / 2
private let totalRotationalRangeInPi = 5
private let xValuePerRotation        = 2 * (maxXAxis + 1) / totalRotationalRangeInPi
private let tolerance                = xValuePerRotation / 2


/**
 The `JoystickController` class is an output controller that converts device rotation (yaw)
 to a joystick's X-axis, and send it as a MIDI modulation wheel message.
 */
final class JoystickController {


    var xAxis = midXAxis {
        didSet {
            if xAxis != oldValue {
                midiHandler.send(.modulationWheel(xAxis))
                midiHandler.send([
                    .noteOn(.C3, velocity: 127),
                    .noteOff(.key(42), velocity: 127)])
            }
        }
    }


    private let midiHandler: MidiMessageHandling

    private var scaledYaw = 0
    private var xOffset   = midXAxis


    init(midiHandler: MidiMessageHandling) {
        self.midiHandler = midiHandler
    }

    convenience init() {
        self.init(midiHandler: MidiController())
    }

}


extension JoystickController: OutputController {

    func updateWithYaw(yaw: Double) {
        let newScaledYaw = Int(round(Double(xValuePerRotation) * yaw / (2 * M_PI)))
        let change       = newScaledYaw - scaledYaw
        scaledYaw        = newScaledYaw

        guard change != 0 else { return }

        // Adjust for pi <--> -pi flip
        if change > tolerance {
            xOffset -= xValuePerRotation
        }
        else if change < -tolerance {
            xOffset += xValuePerRotation
        }

        // Calculate X-axis
        xAxis = min(max(scaledYaw + xOffset, 0), maxXAxis)
    }

    func reset() {
        xAxis   = midXAxis
        xOffset = xAxis - scaledYaw     // xAxis = scaledYaw + xOffset
    }

}

