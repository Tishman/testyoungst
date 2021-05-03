// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum Localizable {
  /// Your account successfully created %
  public static let accountCreated = Localizable.tr("Localizable", "accountCreated")
  /// Add group
  public static let addGroupAction = Localizable.tr("Localizable", "addGroupAction")
  /// New dictionary
  public static let addGroupTitle = Localizable.tr("Localizable", "addGroupTitle")
  /// Add word
  public static let addWordAction = Localizable.tr("Localizable", "addWordAction")
  /// Add word
  public static let addWordTitle = Localizable.tr("Localizable", "addWordTitle")
  /// Cancel
  public static let cancel = Localizable.tr("Localizable", "cancel")
  /// Close
  public static let closeTitle = Localizable.tr("Localizable", "closeTitle")
  /// Confrim password
  public static let confrimPasswordPlaceholder = Localizable.tr("Localizable", "confrimPasswordPlaceholder")
  /// Delete
  public static let delete = Localizable.tr("Localizable", "delete")
  /// Dictionaries
  public static let dictionaries = Localizable.tr("Localizable", "dictionaries")
  /// Dictionary
  public static let dictionary = Localizable.tr("Localizable", "dictionary")
  /// Plural format key: "%#@VARIABLE@"
  public static func dWords(_ p1: Int) -> String {
    return Localizable.tr("Localizable", "dWords", p1)
  }
  /// E-mail
  public static let emailPlaceholder = Localizable.tr("Localizable", "emailPlaceholder")
  /// We have sent a confirmation code to your email. Enter the code in the box below to verify your account.
  public static let emailSendedToConfrim = Localizable.tr("Localizable", "emailSendedToConfrim")
  /// Enter code
  public static let enterCode = Localizable.tr("Localizable", "enterCode")
  /// English
  public static let en = Localizable.tr("Localizable", "en")
  /// Please fill all fields.
  public static let fillAllFields = Localizable.tr("Localizable", "fillAllFields")
  /// Incorrect data
  public static let incorrectDataTitle = Localizable.tr("Localizable", "incorrectDataTitle")
  /// Enter word
  public static let inputTranslationPlacholder = Localizable.tr("Localizable", "inputTranslationPlacholder")
  /// Updated
  public static let lastUpdateTime = Localizable.tr("Localizable", "lastUpdateTime")
  /// Log In
  public static let loginButtonTitle = Localizable.tr("Localizable", "loginButtonTitle")
  /// Login or create an account to get started.
  public static let loginOrRegisterAccountSubtitle = Localizable.tr("Localizable", "loginOrRegisterAccountSubtitle")
  /// Log in to your account to return to our ranks!
  public static let loginToReturnTitle = Localizable.tr("Localizable", "loginToReturnTitle")
  /// Name
  public static let name = Localizable.tr("Localizable", "name")
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
  /// Profile
  public static let profile = Localizable.tr("Localizable", "profile")
  /// Recent
  public static let recent = Localizable.tr("Localizable", "recent")
  /// Register to get started.
  public static let registerToStartTitle = Localizable.tr("Localizable", "registerToStartTitle")
  /// Registration
  public static let registrationButtonTitle = Localizable.tr("Localizable", "registrationButtonTitle")
  /// Russian
  public static let ru = Localizable.tr("Localizable", "ru")
  /// Do you want to delete group? This cannot be undone.
  public static let shouldDeleteGroup = Localizable.tr("Localizable", "shouldDeleteGroup")
  /// Type text here
  public static let typeText = Localizable.tr("Localizable", "typeText")
  /// Unknown error
  public static let unknownError = Localizable.tr("Localizable", "unknownError")
  /// Unnamed
  public static let unnamed = Localizable.tr("Localizable", "unnamed")
  /// Username
  public static let usernamePlaceholder = Localizable.tr("Localizable", "usernamePlaceholder")
  /// Verification
  public static let verification = Localizable.tr("Localizable", "verification")
  /// Verify
  public static let verify = Localizable.tr("Localizable", "verify")
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
