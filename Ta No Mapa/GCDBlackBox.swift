//
//  GCDBlackBox.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 14/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
