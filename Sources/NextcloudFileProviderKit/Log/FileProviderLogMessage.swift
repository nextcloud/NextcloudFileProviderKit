import Foundation

///
/// A data model for the JSON object to be written into the JSON lines log files.
///
public struct FileProviderLogMessage: Encodable {
    ///
    /// As used with `Logger` of the `os` framework.
    ///
    public let category: String

    ///
    /// Time of the message to write.
    ///
    public let date: String

    ///
    /// Textual representation of the associated `OSLogType`.
    ///
    public let level: String

    ///
    /// The actual text for the entry.
    ///
    public let message: String

    ///
    /// As used with `Logger` of the `os` framework.
    ///
    public let subsystem: String
}
