//
//  FileProviderChangeNotificationInterface.swift
//
//
//  Created by Claudio Cambra on 16/5/24.
//

import FileProvider
import Foundation

public class FileProviderChangeNotificationInterface: ChangeNotificationInterface {
    let domain: NSFileProviderDomain
    let logger: FileProviderLogger

    required init(domain: NSFileProviderDomain, log: FileProviderLog) {
        self.domain = domain
        logger = FileProviderLogger(category: "FileProviderChangeNotificationInterface", log: log)
    }

    public func notifyChange() {
        Task { @MainActor in
            if let manager = NSFileProviderManager(for: domain) {
                do {
                    try await manager.signalEnumerator(for: .workingSet)
                } catch let error {
                    self.logger.error("Could not signal enumerator for \(self.domain.identifier.rawValue): \(error.localizedDescription)", [.domain: self.domain.identifier])
                }
            }
        }
    }
}
