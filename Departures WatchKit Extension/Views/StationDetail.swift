//
//  StationDetail.swift
//  Departures WatchKit Extension
//
//  Created by Martin Richter on 08.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

struct StationDetail: View {
    let station: Station
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State var departures = [Departure]()
    @State var lastUpdated = Date()
    
    var body: some View {
        VStack {
            List(departuresByLine(departures: departures, moment: lastUpdated)) { departureList in
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(alignment: .center) {
                        LineIcon(line: departureList.directedLine.line)
                        Spacer()
                        Text("→ \(departureList.directedLine.direction)")
                            .font(.system(size: 11))
                            .lineLimit(1)
                    }
                    HStack {
                        ForEach(departureList.departures, id: \.self) {
                            MinutesBox(minutes: $0)
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            }
        }
        .contextMenu(menuItems: {
            Button(action: loadDepartures, label: {
                VStack {
                    Image(systemName: "arrow.clockwise").font(.title)
                    Text("Reload")
                }
            })
        })
        .onAppear(perform: loadDepartures)
        .onReceive(timer) { _ in self.loadDepartures() }
        .navigationBarTitle(station.name)
    }
    
    func loadDepartures() {
        Store.shared.loadDepartures(station: station) { result in
            switch result {
            case .success(let departures):
                self.departures = departures
                self.lastUpdated = Date()
            case .failure(let error):
                print("Got error: \(error)")
            }
        }
    }
    
    func departuresByLine(departures: [Departure], moment: Date) -> [LineDepartureList] {
        return Dictionary.init(grouping: departures) { $0.directedLine }
            .map { (key, value) in
                LineDepartureList(directedLine: key, departures: value.map { minutesUntilDeparture(departure: $0, moment: moment) })
            }
            .sorted(by: { $0.directedLine < $1.directedLine })
    }
    
    func minutesUntilDeparture(departure: Departure, moment: Date) -> Int {
        return Int(round(moment.distance(to: departure.when) / 60))
    }
}

struct StationDetail_Previews: PreviewProvider {
    static var previews: some View {
        StationDetail(
            station: Station(id: "900000013103", name: "U Prinzenstr."),
            departures: [
                Departure(
                    direction: "S+U Warschauer Str.",
                    when: Date.init(timeIntervalSinceNow: 0),
                    line: Line(name: "U1", product: "subway", color: LineColors(fg: "#fff", bg: "#55a822"))
                ),
                Departure(
                    direction: "Uhlandstraße",
                    when: Date.init(timeIntervalSinceNow: 120),
                    line: Line(name: "U1", product: "subway", color: LineColors(fg: "#fff", bg: "#55a822"))
                ),
                Departure(
                    direction: "Krumme Lanke",
                    when: Date.init(timeIntervalSinceNow: 240),
                    line: Line(name: "U3", product: "subway", color: LineColors(fg: "#fff", bg: "#019377"))
                )
            ],
            lastUpdated: Date()
        )
    }
}
