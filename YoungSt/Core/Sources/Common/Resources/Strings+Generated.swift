// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum Localizable {
  /// Your account successfully created %
  public static let accountCreated = Localizable.tr("Localizable", "accountCreated")
  /// Add word
  public static let addWordAction = Localizable.tr("Localizable", "addWordAction")
  /// Add word
  public static let addWordTitle = Localizable.tr("Localizable", "addWordTitle")
  /// Close
  public static let closeTitle = Localizable.tr("Localizable", "closeTitle")
  /// Confrim password
  public static let confrimPasswordPlaceholder = Localizable.tr("Localizable", "confrimPasswordPlaceholder")
  /// Dictionaries
  public static let dictionaries = Localizable.tr("Localizable", "dictionaries")
  /// E-mail
  public static let emailPlaceholder = Localizable.tr("Localizable", "emailPlaceholder")
  /// English
  public static let en = Localizable.tr("Localizable", "en")
  /// Please fill all fields.
  public static let fillAllFields = Localizable.tr("Localizable", "fillAllFields")
  /// Incorrect data
  public static let incorrectDataTitle = Localizable.tr("Localizable", "incorrectDataTitle")
  /// Enter word
  public static let inputTranslationPlacholder = Localizable.tr("Localizable", "inputTranslationPlacholder")
  /// Log In
  public static let loginButtonTitle = Localizable.tr("Localizable", "loginButtonTitle")
  /// Login or create an account to get started.
  public static let loginOrRegisterAccountSubtitle = Localizable.tr("Localizable", "loginOrRegisterAccountSubtitle")
  /// Log in to your account to return to our ranks!
  public static let loginToReturnTitle = Localizable.tr("Localizable", "loginToReturnTitle")
  /// OK
  public static let ok = Localizable.tr("Localizable", "ok")
  /// Result here
  public static let outputTranslationPlacholder = Localizable.tr("Localizable", "outputTranslationPlacholder")
  /// Password mismatch.
  public static let passwordConfrimation = Localizable.tr("Localizable", "passwordConfrimation")
  /// Password
  public static let passwordPlaceholder = Localizable.tr("Localizable", "passwordPlaceholder")
  /// I agree to the terms of use and accept the Privacy Policy.
  public static let privacyPolicyTitle = Localizable.tr("Localizable", "privacyPolicyTitle")
  /// Recent
  public static let recent = Localizable.tr("Localizable", "recent")
  /// Register to get started.
  public static let registerToStartTitle = Localizable.tr("Localizable", "registerToStartTitle")
  /// Registration
  public static let registrationButtonTitle = Localizable.tr("Localizable", "registrationButtonTitle")
  /// Russian
  public static let ru = Localizable.tr("Localizable", "ru")
  /// Type text here
  public static let typeText = Localizable.tr("Localizable", "typeText")
  /// Unknown error
  public static let unknownError = Localizable.tr("Localizable", "unknownError")
  /// Username
  public static let usernamePlaceholder = Localizable.tr("Localizable", "usernamePlaceholder")
  /// Welcome back
  public static let welcomeBackTitle = Localizable.tr("Localizable", "welcomeBackTitle")
  /// Welcome
  public static let welcomeTitle = Localizable.tr("Localizable", "welcomeTitle")
  /// Word
  public static let word = Localizable.tr("Localizable", "word")
  /// Description
  public static let wordDescription = Localizable.tr("Localizable", "wordDescription")
  /// Words
  public static let words = Localizable.tr("Localizable", "words")
  /// Cant add empty word. Type something in first field
  public static let youShouldTypeText = Localizable.tr("Localizable", "youShouldTypeText")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension Localizable {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.coreModule.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
