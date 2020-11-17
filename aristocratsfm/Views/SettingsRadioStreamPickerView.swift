//
//  SettingsRadioStreamPickerView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 15.11.2020.
//

import SwiftUI

struct SettingsRadioStreamPickerView: View {
    @AppStorage("Stream") private var stream = Streams.Main.name
    @ObservedObject var player: PlayerObservableObject = .shared

    var body: some View {
        Section(header: Text("Stream")) {
            Picker("Stream", selection: $stream) {
                ForEach(Streams.List, id:\.name) { stream in
                    Text(stream.name)
                }
            }.onChange(of: stream) { _ in
                if player.isPlaying {
                    // Reset play state
                    player.play()
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct SettingsRadioStreamPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRadioStreamPickerView()
    }
}
