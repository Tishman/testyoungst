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
  /// Add to dictionary
  public static let addToDictionary = Localizable.tr("Localizable", "addToDictionary")
  /// Add word
  public static let addWordAction = Localizable.tr("Localizable", "addWordAction")
  /// Add word
  public static let addWordTitle = Localizable.tr("Localizable", "addWordTitle")
  /// Become student
  public static let becomeStudent = Localizable.tr("Localizable", "becomeStudent")
  /// Cancel
  public static let cancel = Localizable.tr("Localizable", "cancel")
  /// Cancel invite
  public static let cancelInvite = Localizable.tr("Localizable", "cancelInvite")
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
  /// Request sent. Wait for your teacher to accept it.
  public static let didSendRequestToBecomeStudent = Localizable.tr("Localizable", "didSendRequestToBecomeStudent")
  /// Plural format key: "%#@VARIABLE@"
  public static func dWords(_ p1: Int) -> String {
    return Localizable.tr("Localizable", "dWords", p1)
  }
  /// Update profile
  public static let editProfileAction = Localizable.tr("Localizable", "editProfileAction")
  /// Update profile
  public static let editProfileTitle = Localizable.tr("Localizable", "editProfileTitle")
  /// Edit word
  public static let editWordAction = Localizable.tr("Localizable", "editWordAction")
  /// Edit word
  public static let editWordTitle = Localizable.tr("Localizable", "editWordTitle")
  /// E-mail
  public static let emailPlaceholder = Localizable.tr("Localizable", "emailPlaceholder")
  /// We have sent a confirmation code to your email. Enter the code in the box below to verify your account.
  public static let emailSendedToConfrim = Localizable.tr("Localizable", "emailSendedToConfrim")
  /// You don't yet have any dictionary.\nTap 'plus' to add
  public static let emptyGroupsPlaceholder = Localizable.tr("Localizable", "emptyGroupsPlaceholder")
  /// You don't have any words yet.\nTap 'plus' in menu to add
  public static let emptyWordsPlaceholder = Localizable.tr("Localizable", "emptyWordsPlaceholder")
  /// English
  public static let en = Localizable.tr("Localizable", "en")
  /// Enter code
  public static let enterCode = Localizable.tr("Localizable", "enterCode")
  /// Please fill all fields.
  public static let fillAllFields = Localizable.tr("Localizable", "fillAllFields")
  /// You almost done. Fill info about you
  public static let fillInfoDescription = Localizable.tr("Localizable", "fillInfoDescription")
  /// Welcome!
  public static let fillInfoWelcome = Localizable.tr("Localizable", "fillInfoWelcome")
  /// First name
  public static let firstName = Localizable.tr("Localizable", "firstName")
  /// Incorrect data
  public static let incorrectDataTitle = Localizable.tr("Localizable", "incorrectDataTitle")
  /// Enter word
  public static let inputTranslationPlacholder = Localizable.tr("Localizable", "inputTranslationPlacholder")
  /// First name can't be empty
  public static let invalidFirstName = Localizable.tr("Localizable", "invalidFirstName")
  /// Nickname can't be empty
  public static let invalidNickname = Localizable.tr("Localizable", "invalidNickname")
  /// Last name
  public static let lastName = Localizable.tr("Localizable", "lastName")
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
  /// Nickname
  public static let nickname = Localizable.tr("Localizable", "nickname")
  /// Nickname already in use. Choose another
  public static let nicknameAlreadyUsed = Localizable.tr("Localizable", "nicknameAlreadyUsed")
  /// No translation
  public static let noTranslation = Localizable.tr("Localizable", "noTranslation")
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
  /// Provide info
  public static let provideInfo = Localizable.tr("Localizable", "provideInfo")
  /// Recent
  public static let recent = Localizable.tr("Localizable", "recent")
  /// Register to get started.
  public static let registerToStartTitle = Localizable.tr("Localizable", "registerToStartTitle")
  /// Registration
  public static let registrationButtonTitle = Localizable.tr("Localizable", "registrationButtonTitle")
  /// Remove teacher
  public static let removeTeacher = Localizable.tr("Localizable", "removeTeacher")
  /// Russian
  public static let ru = Localizable.tr("Localizable", "ru")
  /// Settings
  public static let settings = Localizable.tr("Localizable", "settings")
  /// Do you want to delete group? This cannot be undone.
  public static let shouldDeleteGroup = Localizable.tr("Localizable", "shouldDeleteGroup")
  /// Do you want to delete word? This cannot be undone.
  public static let shouldDeleteWord = Localizable.tr("Localizable", "shouldDeleteWord")
  /// You almost done!\nOne more last step left
  public static let shouldFinishInfoProviding = Localizable.tr("Localizable", "shouldFinishInfoProviding")
  /// Student
  public static let student = Localizable.tr("Localizable", "student")
  /// Students
  public static let students = Localizable.tr("Localizable", "students")
  /// Teacher
  public static let teacher = Localizable.tr("Localizable", "teacher")
  /// Teacher have not accept your invintation yet
  public static let teacherNotAcceptedInviteYet = Localizable.tr("Localizable", "teacherNotAcceptedInviteYet")
  /// Translation
  public static let translation = Localizable.tr("Localizable", "translation")
  /// Type text here
  public static let typeText = Localizable.tr("Localizable", "typeText")
  /// Unknown error
  public static let unknownError = Localizable.tr("Localizable", "unknownError")
  /// Unnamed
  public static let unnamed = Localizable.tr("Localizable", "unnamed")
  /// Update
  public static let update = Localizable.tr("Localizable", "update")
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
  /// You can send request to become student. Good luck in learning!
  public static let youCanSendRequestToBecomeStudent = Localizable.tr("Localizable", "youCanSendRequestToBecomeStudent")
  /// You can't become student because you already have teacher.
  public static let youCantBecomeStudent = Localizable.tr("Localizable", "youCantBecomeStudent")
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
