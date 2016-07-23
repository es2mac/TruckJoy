//
//  MidiCommon.swift
//  TruckJoy
//
//  Created by Paul on 7/23/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import Foundation


protocol MidiHandler {
    func send(messages: [MidiMessage])
}

extension MidiHandler {
    func send(midiMessage: MidiMessage) {
        send([midiMessage])
    }
}


enum MidiMessage {

    
    enum Note: UInt8 {
        case C3 = 36, C4 = 48, C5 = 60
    }


    case noteOff(Note, velocity: UInt8)
    case noteOn(Note, velocity: UInt8)
    case modulationWheel(value: UInt16)


    var bytes: [UInt8] {
        switch self {
        case .noteOn(let note, velocity: let velocity):
            precondition(0...127 ~= note.rawValue)
            precondition(0...127 ~= velocity)

            return [0b1001_0000, note.rawValue, velocity]

        case .noteOff(let note, velocity: let velocity):
            precondition(0...127 ~= note.rawValue)
            precondition(0...127 ~= velocity)

            return [0b1000_0000, note.rawValue, velocity]

        case .modulationWheel(value: let value):
            precondition(0...16383 ~= value)

            let coarse = UInt8(value >> 7)
            let fine = UInt8(value & 0b111_1111)
            return [0b1011_0000, 1, coarse, 33, fine]
        }
    }

}
