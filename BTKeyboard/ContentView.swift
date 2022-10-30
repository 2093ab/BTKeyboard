//
//  ContentView.swift
//  BTKeyboard
//
//  Created by 길수민 on 2022/10/30.
//

import SwiftUI
import AudioKit
import Keyboard

class AudioMidi: ObservableObject {
    let midi = MIDI()
    
    func makeMidi() {
        midi.openOutput()
    }
    
    func destroyMidi() {
        midi.closeOutput()
    }
    
    func noteOn (pitch: Pitch, point: CGPoint) {
        midi.sendNoteOnMessage (noteNumber: MIDINoteNumber(pitch.intValue), velocity: 127)
    }
    
    func noteOff (pitch: Pitch) {
        midi.sendNoteOffMessage(noteNumber: MIDINoteNumber(pitch.intValue))
    }
}

struct SwiftUIKeyboard: View {
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in}
    var noteOff: (Pitch) -> Void
    var body: some View {
        Keyboard(layout: .piano(pitchRange: Pitch(intValue: 48)...Pitch(intValue: 72)), noteOn: noteOn, noteOff: noteOff)
            .cornerRadius(5.0, antialiased: true)
    }
}

struct ContentView: View {
    @StateObject var controller = AudioMidi()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            SwiftUIKeyboard(noteOn: controller.noteOn, noteOff: controller.noteOff)
                .padding(10)
        }
            .background(Color.black)
            .onAppear(perform: controller.makeMidi)
            .onDisappear(perform: controller.destroyMidi)
            .environmentObject(controller)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
