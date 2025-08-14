import Foundation
import os

///
/// A logging facility designed for file provider extensions.
///
/// It writes JSON lines to a file.
///
/// > To Do: Consider using macros for the calls so the calling functions and files can be recorded, too!
///
public actor FileProviderLog {
    ///
    /// JSON encoder for ``FileProviderLogMessage`` values.
    ///
    let encoder: JSONEncoder

    ///
    /// The file location to write messages to.
    ///
    let file: URL?

    ///
    /// Used for for the date strings in encoded ``FileProviderLogMessage``.
    ///
    let formatter: DateFormatter

    ///
    /// The handle used for writing to the file located by ``url``.
    ///
    let handle: FileHandle?

    ///
    /// The fallback logger.
    ///
    /// This is important in case the actual log file could be created or written to.
    ///
    let logger: Logger

    ///
    /// The subsystem string to be used as with the unified logging system.
    ///
    let subsystem: String

    ///
    /// Initialize a new log file abstraction.
    ///
    /// - Parameters:
    ///     - fileProviderDomainIdentifier: The raw string value of the file provider domain which this file provider extension process is managing.
    ///     - securityApplicationGroupIdentifier: The app group the running process is part of. This is required to resolve the location to place the log files in.
    ///
    public init(fileProviderDomainIdentifier: String, securityApplicationGroupIdentifier: String) {
        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.sortedKeys]

        self.formatter = DateFormatter()


        self.subsystem = Bundle.main.bundleIdentifier ?? ""
        self.logger = Logger(subsystem: self.subsystem, category: "FileProviderLog")

        let fileManager = FileManager.default

        guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: securityApplicationGroupIdentifier) else {
            logger.error("Failed to get container URL for security application group identifier \"\(securityApplicationGroupIdentifier, privacy: .public)\"!")
            self.file = nil
            self.handle = nil
            return
        }

        let logsDirectory = container
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Logs", isDirectory: true)

        if fileManager.fileExists(atPath: logsDirectory.path) == false {
            do {
                try fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true)
            } catch {
                logger.error("Failed to create logs directory at \"\(logsDirectory.path, privacy: .public)\"!")
            }
        }

        let creationDate = Date()
        let formattedDate = formatter.string(from: creationDate)
        let processIdentifier = ProcessInfo.processInfo.processIdentifier
        let name = "File Provider Domain \(fileProviderDomainIdentifier) (\(creationDate); Process \(processIdentifier)).log.jsonl"
        let file = logsDirectory.appendingPathComponent(name, isDirectory: false)
        self.file = file

        do {
            self.handle = try FileHandle(forWritingTo: file)
        } catch {
            self.handle = nil
            logger.error("Failed to create file handle for writing to \"\(file.path, privacy: .public)\"!")
        }
    }

    ///
    /// Write a message to the unified logging system and current log file.
    ///
    /// Usually, you do not need or want to use this but the methods provided by ``FileProviderLogger`` instead.
    ///
    public func write(category: String, level: OSLogType, message: String, details: [String: String]) {
        logger.log(level: level, "\(message, privacy: .public)")

        guard let handle else {
            return
        }

        let levelDescription: String

        switch level {
            case .debug:
                levelDescription = "debug"
            case .info:
                levelDescription = "info"
            case .default:
                levelDescription = "default"
            case .error:
                levelDescription = "error"
            case .fault:
                levelDescription = "fault"
            default:
                levelDescription = "default"
                break
        }

        let date = Date()
        let formattedDate = formatter.string(from: date)
        let entry = FileProviderLogMessage(category: category, date: formattedDate, details: details, level: levelDescription, message: message, subsystem: subsystem)

        do {
            let object = try encoder.encode(entry)
            try handle.write(contentsOf: object)
        } catch {
            logger.error("Failed to encode and write message: \(message, privacy: .public)!")
            return
        }
    }
}
