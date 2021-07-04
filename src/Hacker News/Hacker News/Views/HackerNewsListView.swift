//
//  ContentView.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 17/01/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = MainViewModel(hackerNewsApi: HackerNewsApi())
    var body: some View {
        NavigationView{
            listView
                .navigationBarTitle("Top Stories", displayMode: .large)
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "magnifyingglass")
                    })
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                    })
                })
        }
        .onAppear(perform: {
            self.viewModel.fetchIds()
        })
    }
    
    @ViewBuilder
    var listView: some View {
        if let safeIds = viewModel.ids {
            ScrollView {
                LazyVStack {
                    ForEach(safeIds, id: \.self) { id in
                        StoryView(storyId: id)
                    }
                }
            }
        } else {
            ProgressView("loading")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
