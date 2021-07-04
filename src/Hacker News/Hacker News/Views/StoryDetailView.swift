//
//  StoryDetailView.swift
//  Hacker News
//
//  Created by Bohirjon Akhmedov on 04/07/21.
//

import SwiftUI

struct StoryDetailView: View {
    
    let stringUrl : String
    
    var body: some View {
       Webview(url: URL(string: stringUrl)!)
    }
    
}
