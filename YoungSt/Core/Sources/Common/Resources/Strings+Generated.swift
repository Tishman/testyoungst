// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum Localizable {
  /// Confrim password
  public static let confrimPasswordPlaceholder = Localizable.tr("Localizable", "confrimPasswordPlaceholder")
  /// E-mail
  public static let emailPlaceholder = Localizable.tr("Localizable", "emailPlaceholder")
  /// Enter word
  public static let inputTranslationPlacholder = Localizable.tr("Localizable", "inputTranslationPlacholder")
  /// Log In
  public static let loginButtonTitle = Localizable.tr("Localizable", "loginButtonTitle")
  /// Log in to your account to return to our ranks!
  public static let loginToReturnTitle = Localizable.tr("Localizable", "loginToReturnTitle")
  /// Result here
  public static let outputTranslationPlacholder = Localizable.tr("Localizable", "outputTranslationPlacholder")
  /// Password
  public static let passwordPlaceholder = Localizable.tr("Localizable", "passwordPlaceholder")
  /// I agree to the terms of use and accept the Privacy Policy.
  public static let privacyPolicyTitle = Localizable.tr("Localizable", "privacyPolicyTitle")
  /// Register to get started.
  public static let registerToStartTitle = Localizable.tr("Localizable", "registerToStartTitle")
  /// Registration
  public static let registrationButtonTitle = Localizable.tr("Localizable", "registrationButtonTitle")
  /// Username
  public static let usernamePlaceholder = Localizable.tr("Localizable", "usernamePlaceholder")
  /// Welcome back
  public static let welcomeBackTitle = Localizable.tr("Localizable", "welcomeBackTitle")
  /// Welcome
  public static let welcomeTitle = Localizable.tr("Localizable", "welcomeTitle")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension Localizable {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.coreModule.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
