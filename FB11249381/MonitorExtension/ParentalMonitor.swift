//
//  ParentalMonitor.swift
//  ParentalMonitorExtension
//
//  Created by Salavat Khanov on 7/10/21.
//

import Foundation
import DeviceActivity
import ManagedSettings
import os.log

final class ParentalMonitor: DeviceActivityMonitor {
    
    private let settings = ManagedSettingsStore()
        
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        os_log(.default, log: self.log, "Interval did start for activity: %{public}@", activity.rawValue)
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        os_log(.default, log: self.log, "Interval did end for activity: %{public}@", activity.rawValue)
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        os_log(.default, log: self.log, "Event did reach threshold for: %{public}@ (%{public}@)", activity.rawValue, event.rawValue)
    }
    
    private let log = OSLog(subsystem: "parental-monitor", category: "default")
}
