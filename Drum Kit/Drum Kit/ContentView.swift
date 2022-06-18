//
//  ContentView.swift
//  Drum Kit
//
//  Created by Shion on 2022/06/18.
//

import SwiftUI
import AudioKit

struct DrumPad:  Identifiable, View{
    @EnvironmentObject var audio: Audio
    @State private var ispressed = false
    var id: String
    var number: MIDINoteNumber
    var body: some View{
        Image(systemName: "square.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(ispressed ? Color.blue :Color.green)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged{ value in
                        if ispressed == false {
                            ispressed = true
                            audio.midi.sendNoteOnMessage(noteNumber: number, velocity: 127)
                        }
                    }
                    .onEnded{valuse in
                        ispressed = false
                        audio.midi.sendNoteOffMessage(noteNumber: number)
                    }
            )
    }
}

class Audio: ObservableObject {
    let midi = MIDI()
    func makeMidi() {
        midi.openOutput()
    }
    func destroyMidi (){
        midi.closeOutput()
    }
}

struct ContentView: View {
    @StateObject var audio = Audio()
    @State var labelText = "Drum kit"
    @State var flag = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text(labelText+" mode now")
                        .font(.title2)
                        .fontWeight(.medium)
                    VStack{
                        HStack{
                            DrumPad(id: "one", number: 36)
                            DrumPad(id: "two", number: 37)
                            DrumPad(id: "three", number: 38)
                            DrumPad(id: "four", number: 39)
                        }
                        HStack{
                            DrumPad(id: "five", number: 40)
                            DrumPad(id: "six", number: 41)
                            DrumPad(id: "seven", number: 12)
                            DrumPad(id: "eight", number: 43)
                        }
                        HStack{
                            DrumPad(id: "nine", number: 44)
                            DrumPad(id: "ten", number: 45)
                            DrumPad(id: "eleven", number: 46)
                            DrumPad(id: "twelve", number: 47)
                        }
                        HStack{
                            DrumPad(id: "thirteen", number: 48)
                            DrumPad(id: "fourteen", number: 49)
                            DrumPad(id: "fifteen", number: 50)
                            DrumPad(id: "sixteen", number: 51)
                        }
                    }
                    .shadow(radius: 0.5)
                    .padding()
                    .onAppear {
                        audio.makeMidi()
                    }
                    .onDisappear {
                        audio.destroyMidi()
                    }
                    .environmentObject(audio)
                    Spacer()
                    VStack {
                        Button(action: {
                            if(self.flag){
                                self.labelText = "Drum mode"
                                self.flag = false
                            }
                            else{
                                self.labelText = "Sample"
                                self.flag = true
                            }
                        }){
                            Text("Change inst")
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                        }
                        .padding(.all)
                        .background(Color.blue)
                    .cornerRadius(20)
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Pad")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
