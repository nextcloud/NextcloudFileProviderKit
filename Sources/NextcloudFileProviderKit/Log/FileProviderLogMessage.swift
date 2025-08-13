import Foundation

///
/// A data model for the JSON object to be written into the JSON lines log files.
///
public struct FileProviderLogMessage: Encodable {
    ///
    /// As used with `Logger` of the `os` framework.
    ///
    let category: String

    ///
    /// Time of the message to write.
    ///
    let date: String

    ///
    /// Textual representation of the associated `OSLogType`.
    ///
    let level: String

    ///
    /// The actual text for the entry.
    ///
    let message: String

    ///
    /// As used with `Logger` of the `os` framework.
    ///
    let subsystem: String
}
