//
//  ContentView.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 17/01/21.
//

import SwiftUI

struct ContentView: View {
    @State private var isShown = true
    var body: some View {
        Text(isShown ? "Shown" : "hidden")
            .padding()
            .onTapGesture {
                isShown.toggle()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
