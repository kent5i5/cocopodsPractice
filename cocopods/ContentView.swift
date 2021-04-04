//
//  ContentView.swift
//  cocopods
//
//  Created by ying kit ng on 4/3/21.
//

import SwiftUI
import Alamofire
struct ContentView: View {
    
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear(){
                AF.request("https://httpbin.org/get").response { response in
                    debugPrint(response)
                }
            }
        
        CocopodsViewControllerRepresentation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
