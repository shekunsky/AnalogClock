//
//  ContentView.swift
//  AnalogClock
//
//  Created by Alex2 on 21.04.2023.
//

import SwiftUI

struct ContentView: View {
    let offset: CGFloat = 50
    var body: some View {
        AnalogClock()
            .padding(EdgeInsets(top: offset,
                                leading: offset,
                                bottom: offset,
                                trailing: offset))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
