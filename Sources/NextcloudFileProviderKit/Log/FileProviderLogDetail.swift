import Foundation

///
/// An enum that can represent any JSON value and is `Encodable`.
///
public enum FileProviderLogDetail: Encodable {
    ///
    /// The represented detail value is a string in JSON.
    ///
    case string(String)

    ///
    /// The represented detail value is an integer in JSON.
    ///
    case int(Int)

    ///
    /// The represented detail value is a double in JSON.
    ///
    case double(Double)

    ///
    /// The represented detail value is a boolean in JSON.
    ///
    case bool(Bool)

    ///
    /// The represented detail value is an array in JSON.
    ///
    case array([FileProviderLogDetail])

    ///
    /// The represented detail value is a dictionary in JSON.
    ///
    case dictionary([String: FileProviderLogDetail])

    ///
    /// The represented detail value is `null` in JSON.
    ///
    case null

    var value: Any {
        switch self {
            case .string(let v):
                return v
            case .int(let v):
                return v
            case .double(let v):
                return v
            case .bool(let v):
                return v
            case .array(let v):
                return v.map { $0.value }
            case .dictionary(let v):
                return v.mapValues { $0.value }
            case .null:
                return NSNull()
        }
    }

    ///
    /// Attempt to create a detail value based on any given type.
    ///
    init(_ anyOptional: Any?) {
        if let someValue = anyOptional {
            if someValue.self is String {
                self = .string(someValue as! String)
            } else {
                self = .string("<unsupported log detail type>")
            }
        } else {
            self = .null
        }
    }

    // MARK: Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .string(let v):
                try container.encode(v)
            case .int(let v):
                try container.encode(v)
            case .double(let v):
                try container.encode(v)
            case .bool(let v):
                try container.encode(v)
            case .array(let v):
                try container.encode(v)
            case .dictionary(let v):
                try container.encode(v)
            case .null:
                try container.encodeNil()
        }
    }
}
