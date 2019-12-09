//
//  StationDetail.swift
//  Juostaanko WatchKit Extension
//
//  Created by Martin Richter on 08.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

struct StationDetail: View {
    let station: Station
    
    @State var departures = [Departure]()
    @State var lastUpdated = Date()
    
    var body: some View {
        VStack {
            List(departuresByLine(departures: departures, moment: lastUpdated)) { departureList in
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(alignment: .center) {
                        LineIcon(line: departureList.directedLine.line)
                        Spacer()
                        Text("→ \(departureList.directedLine.direction)")
                            .font(.system(size: 10))
                            .lineLimit(1)
                    }
                    HStack {
                        ForEach(departureList.departures, id: \.self) {
                            MinutesBox(minutes: $0)
                        }
                    }
                }
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }
            Spacer()
            Button(action: loadDepartures) {
                Text("Reload")
            }
        }
        .onAppear(perform: loadDepartures)
        .navigationBarTitle(station.name)
    }
    
    func loadDepartures() {
        let url = URL(string: "\(BASE_URL_STRING)/\(station.id)/departures")!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let decodedResponse = try decoder.decode([Departure].self, from: data)
                    DispatchQueue.main.async {
                        self.departures = decodedResponse
                        self.lastUpdated = Date()
                        
                    }
                } catch let error {
                    print("Decode error", error)
                }
                return
            }
            print("Fetch error", error ?? "Unknown error")
        }.resume()
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
