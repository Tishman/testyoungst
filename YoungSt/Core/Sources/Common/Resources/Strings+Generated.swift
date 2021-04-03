// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum Localizable {
  /// E-mail
  public static let emailPlaceholder = Localizable.tr("Localizable", "emailPlaceholder")
  /// Enter word
  public static let inputTranslationPlacholder = Localizable.tr("Localizable", "inputTranslationPlacholder")
  /// Result here
  public static let outputTranslationPlacholder = Localizable.tr("Localizable", "outputTranslationPlacholder")
  /// Password
  public static let passwordPlaceholder = Localizable.tr("Localizable", "passwordPlaceholder")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension Localizable {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
