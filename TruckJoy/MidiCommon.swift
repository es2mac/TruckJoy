//
//  MidiCommon.swift
//  TruckJoy
//
//  Created by Paul on 7/23/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import Foundation


/**
 Usage examples:

     handler.send(.modulationWheel(3543))
 Or:

     handler.send([
         .noteOn(.C3, velocity: 127),
         .noteOff(.key(42), velocity: 0)])
 */
protocol MidiMessageHandling {
    func send(messages: Array<MidiMessage>)
}

extension MidiMessageHandling {
    func send(midiMessage: MidiMessage) {
        send( [midiMessage] )
    }
}


/**
 Formalized MIDI message specification
 */
enum MidiMessage {


    /// Complete list of MIDI notes (0~127)
    enum Note: UInt8 {

        static func key(key: Int) -> Note {
            return Note(rawValue: UInt8(key))!
        }

        case C0  = 0,   C0s  = 1,   D0  = 2,   D0s  = 3,   E0  = 4,   F0  = 5,   F0s  = 6,   G0  = 7,   G0s  = 8,   A0 = 9,   A0s = 10,  B0 = 11
        case C1  = 12,  C1s  = 13,  D1  = 14,  D1s  = 15,  E1  = 16,  F1  = 17,  F1s  = 18,  G1  = 19,  G1s  = 20,  A1 = 21,  A1s = 22,  B1 = 23
        case C2  = 24,  C2s  = 25,  D2  = 26,  D2s  = 27,  E2  = 28,  F2  = 29,  F2s  = 30,  G2  = 31,  G2s  = 32,  A2 = 33,  A2s = 34,  B2 = 35
        case C3  = 36,  C3s  = 37,  D3  = 38,  D3s  = 39,  E3  = 40,  F3  = 41,  F3s  = 42,  G3  = 43,  G3s  = 44,  A3 = 45,  A3s = 46,  B3 = 47
        case C4  = 48,  C4s  = 49,  D4  = 50,  D4s  = 51,  E4  = 52,  F4  = 53,  F4s  = 54,  G4  = 55,  G4s  = 56,  A4 = 57,  A4s = 58,  B4 = 59
        case C5  = 60,  C5s  = 61,  D5  = 62,  D5s  = 63,  E5  = 64,  F5  = 65,  F5s  = 66,  G5  = 67,  G5s  = 68,  A5 = 69,  A5s = 70,  B5 = 71
        case C6  = 72,  C6s  = 73,  D6  = 74,  D6s  = 75,  E6  = 76,  F6  = 77,  F6s  = 78,  G6  = 79,  G6s  = 80,  A6 = 81,  A6s = 82,  B6 = 83
        case C7  = 84,  C7s  = 85,  D7  = 86,  D7s  = 87,  E7  = 88,  F7  = 89,  F7s  = 90,  G7  = 91,  G7s  = 92,  A7 = 93,  A7s = 94,  B7 = 95
        case C8  = 96,  C8s  = 97,  D8  = 98,  D8s  = 99,  E8  = 100, F8  = 101, F8s  = 102, G8  = 103, G8s  = 104, A8 = 105, A8s = 106, B8 = 107
        case C9  = 108, C9s  = 109, D9  = 110, D9s  = 111, E9  = 112, F9  = 113, F9s  = 114, G9  = 115, G9s  = 116, A9 = 117, A9s = 118, B9 = 119
        case C10 = 120, C10s = 121, D10 = 122, D10s = 123, E10 = 124, F10 = 125, F10s = 126, G10 = 127
    }


    // Add cases as needed
    case noteOff(Note, velocity: Int)
    case noteOn(Note, velocity: Int)
    case modulationWheel(Int)


    var bytes: [UInt8] {
        switch self {
        case .noteOn(let note, velocity: let velocity):
            precondition(0...127 ~= note.rawValue)
            precondition(0...127 ~= velocity)

            return [0b1001_0000, note.rawValue, UInt8(velocity)]

        case .noteOff(let note, velocity: let velocity):
            precondition(0...127 ~= note.rawValue)
            precondition(0...127 ~= velocity)

            return [0b1000_0000, note.rawValue, UInt8(velocity)]

        case .modulationWheel(let value):
            precondition(0...16383 ~= value)

            let coarse = UInt8(value >> 7)
            let fine = UInt8(value & 0b111_1111)
            return [0b1011_0000, 1, coarse, 33, fine]
        }
    }

}
