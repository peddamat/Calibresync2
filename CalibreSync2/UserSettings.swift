//
//  UserSettings.swift
//  CalibreSync2
//
//  Created by Sumanth Peddamatham on 11/27/19.
//  Copyright © 2019 Sumanth Peddamatham. All rights reserved.
//

import Combine
import Foundation

final class UserSettings: ObservableObject {

    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault("LibraryRoot", defaultValue: nil)
    var libraryRoot: Data {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("ShowOnStart", defaultValue: true)
    var showOnStart: Bool {
        willSet {
            objectWillChange.send()
        }
    }
}
