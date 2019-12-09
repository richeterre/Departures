//
//  ContentView.swift
//  Juostako WatchKit Extension
//
//  Created by Martin Richter on 08.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import SwiftUI

let EXAMPLE_URL = URL(string: "https://3.vbb.transport.rest/stops/900013103/departures")!

struct ContentView: View {
    @State var departures = [Departure]()
    @State var now = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            List(departuresByLine(departures: departures, moment: now)) { departureList in
                VStack(alignment: .trailing) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(departureList.directedLine.line.name)")
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
            }
            Spacer()
            Button(action: loadDepartures) {
                Text("Reload")
            }
        }
        .onReceive(timer) { self.now = $0 }
        .onAppear(perform: loadDepartures)
        .navigationBarTitle("U Prinzenstraße")
    }
    
    func loadDepartures() {
        URLSession.shared.dataTask(with: EXAMPLE_URL) { (data, _, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([Departure].self, from: data) {
                    DispatchQueue.main.async {
                        self.departures = decodedResponse
                    }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            departures: [
                Departure(
                    direction: "S+U Warschauer Str.",
                    when: Date.init(timeIntervalSinceNow: 0),
                    line: Line(name: "U1")
                ),
                Departure(
                    direction: "Uhlandstraße",
                    when: Date.init(timeIntervalSinceNow: 120),
                    line: Line(name: "U1")
                ),
                Departure(
                    direction: "Krumme Lanke",
                    when: Date.init(timeIntervalSinceNow: 240),
                    line: Line(name: "U3")
                )
            ],
            now: Date()
        )
    }
}
