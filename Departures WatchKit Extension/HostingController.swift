//
//  HostingController.swift
//  Departures WatchKit Extension
//
//  Created by Martin Richter on 08.12.19.
//  Copyright © 2019 Martin Richter. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<StationList> {
    override var body: StationList {
        return StationList()
    }
}
