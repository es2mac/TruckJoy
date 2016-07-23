//
//  MidiController.swift
//  TruckJoy
//
//  Created by Paul on 7/23/16.
//  Copyright © 2016 Mathemusician.net. All rights reserved.
//

import Foundation


final class MidiController: NSObject, MidiHandler {
    
    
    private let midi: PGMidi


    init(midi: PGMidi) {
        self.midi = midi
        super.init()
        midi.delegate = self
    }
    
    convenience override init() {
        self.init(midi: PGMidi())
    }

    func send(messages: [MidiMessage]) {
        let bytes = messages.flatMap { $0.bytes }
        midi.sendBytes(bytes, size: UInt32(bytes.count * sizeof(UInt8)))
    }

}


extension MidiController: PGMidiDelegate {
    
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
