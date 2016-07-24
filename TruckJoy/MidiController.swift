//
//  MIDIController.swift
//  TruckJoy
//
//  Created by Paul on 7/23/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import Foundation


/**
 Light wrapper class around PGMidi
 */
final class MIDIController: NSObject {
    
    
    private let midi: PGMidi

    // Running status, just to be sure, reset every 32th message
    private var lastStatusByte: UInt8?
    private var runningCounter = 0 {
        didSet {
            if runningCounter >= 32 { lastStatusByte = nil; runningCounter = 0 }
        }
    }


    init(midi: PGMidi) {
        self.midi = midi
        super.init()
        midi.delegate = self
    }
    
    convenience override init() {
        self.init(midi: PGMidi())
    }

}


extension MIDIController: MIDIMessageHandling {

    func send(messages: [MIDIMessage]) {

        // Optimize for MIDI running status
        var bytes = [UInt8]()

        for message in messages {
            var rawBytes = message.bytes

            if let byte = lastStatusByte where byte == rawBytes.first {
                rawBytes.removeFirst()
                runningCounter += 1
            }
            else {
                lastStatusByte = rawBytes.first
            }

            bytes += rawBytes
        }

        midi.sendBytes(bytes, size: UInt32(bytes.count * sizeof(UInt8)))
    }

}


extension MIDIController: PGMidiDelegate {
    
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
