//
//  StationList.swift
//  Departures WatchKit Extension
//
//  Created by Martin Richter on 09.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

struct StationList: View {
    @State var stations = [
        Station(id: "900000054103", name: "U Eisenacher Str."),
        Station(id: "900000055151", name: "Barbarossastr."),
        Station(id: "900000055102", name: "U Bayerischer Platz"),
        Station(id: "900000013102", name: "U Kottbusser Tor"),
    ]
    
    var body: some View {
        List(stations) { station in
            NavigationLink(destination: StationDetail(station: station)) {
                Text(station.name)
            }
        }
    }
}

struct StationList_Previews: PreviewProvider {
    static var previews: some View {
        StationList()
    }
}

