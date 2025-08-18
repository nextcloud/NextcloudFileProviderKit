///
/// A predefined set of detail keys to avoid having multiple keys for the same type of information accidentally while still leaving the possibility to define arbitrary keys.
///
public enum FileProviderLogDetailKey: String {
    ///
    /// The identifier for an account.
    ///
    case account

    ///
    /// The raw value of an `NSFileProviderDomainIdentifier`.
    ///
    case domain

    ///
    /// HTTP entity tag.
    ///
    /// See [Wikipedia](https://en.wikipedia.org/wiki/HTTP_ETag) for further information.
    ///
    case eTag

    ///
    /// The raw value of an `NSFileProviderItemIdentifier`.
    ///
    case item

    ///
    /// The name of a file or directory in the file system.
    ///
    case name

    ///
    /// The server-side item identifier.
    ///
    case ocId

    ///
    /// Any relevant URL, in example in context of a network request.
    ///
    case url
}
