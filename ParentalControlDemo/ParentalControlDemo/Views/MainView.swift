//
//  MainView.swift
//  ParentalControlDemo
//
//  Created by Salavat Khanov on 19.01.2022.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct MainView: View, AlertViewMaker {
    
    @StateObject var model = MainViewModel()
    
    @State private var context = DeviceActivityReport.Context("Total Activity")
    @State private var filter = DeviceActivityFilter(
        users: .children,
        devices: .all
    )
    
    var body: some View {
        NavigationView {
            Form {
                authorizeSection
                reportView
            }
            .navigationTitle("Demo")
            .alert(item: $model.activeAlert, content: alert(forItem:))
        }
        .navigationViewStyle(.stack)
    }
    
    private var currentStatus: AuthorizationStatus {
        model.authorizationStatusManager.actualStatus ?? .notDetermined
    }
    
    private var authorizeSection: some View {
        Section(header: Text("Parental Authorization")) {
            HStack {
                Text("Status").bold()
                Spacer()
                Text(currentStatus.description)
            }
            
            if currentStatus != .approved {
                Button("Request Authorization", action: model.authorizeParentalControlButtonDidTap)
            }
            
            if currentStatus == .approved {
                Button("Revoke Authorization", role: .destructive, action: model.revokeParentalControlAuthorizationButtonDidTap)
            }
        }
    }
    
    private var reportView: some View {
        Section(header: Text("DeviceActivityReport View")) {
            DeviceActivityReport(context, filter: filter)
                .frame(height: 220)
                .border(Color.red)
        }
    }
}
