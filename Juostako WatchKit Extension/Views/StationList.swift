//
//  StationList.swift
//  Juostako WatchKit Extension
//
//  Created by Martin Richter on 09.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

let BASE_URL_STRING = "https://3.vbb.transport.rest/stops"

struct StationList: View {
    @State var stations = [
        Station(id: "900000054103", name: "U Eisenacher Str."),
        Station(id: "900000013103", name: "U Prinzenstr."),
        Station(id: "900000017104", name: "U Möckernbrücke")
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

