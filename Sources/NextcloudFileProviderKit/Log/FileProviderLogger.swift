import os

///
/// A proxy type to be used by logging types which automatically augments messages with the once configured category.
///
public actor FileProviderLogger {
    ///
    /// The category string to be used as with the unified logging system.
    ///
    let category: String

    ///
    /// The unified logging system object.
    ///
    let logger: Logger

    ///
    /// The file logging system object.
    ///
    let log: FileProviderLog

    ///
    /// Create a new logger which is supposed to be used by individual types and their instances.
    ///
    public init(category: String, log: FileProviderLog) {
        self.category = category
        self.logger = Logger(subsystem: log.subsystem, category: category)
        self.log = log
    }

    ///
    /// Dispatch a task to write a message with the level `OSLogType.debug`.
    ///
    public func debug(_ message: String) {
        Task {
            await log.write(category: category, level: .debug, message: message)
        }
    }

    ///
    /// Dispatch a task to write a message with the level `OSLogType.info`.
    ///
    public func info(_ message: String) {
        Task {
            await log.write(category: category, level: .info, message: message)
        }
    }

    ///
    /// Dispatch a task to write a message with the level `OSLogType.error`.
    ///
    public func error(_ message: String) {
        Task {
            await log.write(category: category, level: .error, message: message)
        }
    }

    ///
    /// Dispatch a task to write a message with the level `OSLogType.fault`.
    ///
    public func fault(_ message: String) {
        Task {
            await log.write(category: category, level: .fault, message: message)
        }
    }
}
