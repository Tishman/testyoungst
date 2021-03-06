// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum Loc {
  public enum Errors {
    /// No acces for requested operation
    public static let errAccessDenied = Loc.tr("Errors", "errAccessDenied")
    /// Already have teacher
    public static let errAlreadyHaveTeacher = Loc.tr("Errors", "errAlreadyHaveTeacher")
    /// Could not establish internet connection. Check your network config
    public static let errConnectionIssue = Loc.tr("Errors", "errConnectionIssue")
    /// Group not found. Maybe it already deleted?
    public static let errGroupNotFound = Loc.tr("Errors", "errGroupNotFound")
    /// Incorrect confirmation code. Please check again
    public static let errIncorrectConfirmationCode = Loc.tr("Errors", "errIncorrectConfirmationCode")
    /// Invorrect invite link
    public static let errIncorrectInvitePassword = Loc.tr("Errors", "errIncorrectInvitePassword")
    /// Incorrect request data
    public static let errIncorrectRequest = Loc.tr("Errors", "errIncorrectRequest")
    /// Incorrect reset code
    public static let errIncorrectResetPasswordCode = Loc.tr("Errors", "errIncorrectResetPasswordCode")
    /// Internal error
    public static let errInternal = Loc.tr("Errors", "errInternal")
    /// Invalid credentials
    public static let errInvalidCredentials = Loc.tr("Errors", "errInvalidCredentials")
    /// Invalid email
    public static let errInvalidEmail = Loc.tr("Errors", "errInvalidEmail")
    /// First name is icorrect
    public static let errInvalidFirstName = Loc.tr("Errors", "errInvalidFirstName")
    /// Invalid input format
    public static let errInvalidFormat = Loc.tr("Errors", "errInvalidFormat")
    /// Last name is incorrect
    public static let errInvalidLastName = Loc.tr("Errors", "errInvalidLastName")
    /// Invalid login
    public static let errInvalidLogin = Loc.tr("Errors", "errInvalidLogin")
    /// Nickname is incorrect
    public static let errInvalidNickname = Loc.tr("Errors", "errInvalidNickname")
    /// Invalid password
    public static let errInvalidPassword = Loc.tr("Errors", "errInvalidPassword")
    /// Invite expired
    public static let errInviteExpired = Loc.tr("Errors", "errInviteExpired")
    /// Invite not found. Maybe it already rejected or accepted?
    public static let errInviteNotFound = Loc.tr("Errors", "errInviteNotFound")
    /// Language not supported yed
    public static let errLanguageNotSupported = Loc.tr("Errors", "errLanguageNotSupported")
    /// Locales metadata not found
    public static let errLocalesNotSet = Loc.tr("Errors", "errLocalesNotSet")
    /// Information metadata not found
    public static let errMetadataNotFound = Loc.tr("Errors", "errMetadataNotFound")
    /// Nickname already taken. Please choose anoser
    public static let errNicknameAlreadyTaken = Loc.tr("Errors", "errNicknameAlreadyTaken")
    /// Nickname already taken. Please choose anoser
    public static let errNicknameAlreadyUsed = Loc.tr("Errors", "errNicknameAlreadyUsed")
    /// No acces for requested operation
    public static let errNoAccess = Loc.tr("Errors", "errNoAccess")
    /// Not found information. Maybe relation not exists?
    public static let errNotFoundInviteAndRelation = Loc.tr("Errors", "errNotFoundInviteAndRelation")
    /// Profile info not found. Maybe you are not registered?
    public static let errProfileNotFound = Loc.tr("Errors", "errProfileNotFound")
    /// Session not provided. Are you logged out?
    public static let errSessionNotProvided = Loc.tr("Errors", "errSessionNotProvided")
    /// Not found teacher
    public static let errTeacherEmpty = Loc.tr("Errors", "errTeacherEmpty")
    /// Unknown error
    public static let errUnknown = Loc.tr("Errors", "errUnknown")
    /// User already exists
    public static let errUserAlreadyExists = Loc.tr("Errors", "errUserAlreadyExists")
    /// User identifier not provided. Are you logged out?
    public static let errUserIdNotProvided = Loc.tr("Errors", "errUserIdNotProvided")
    /// Invalid registration identifier
    public static let errVerificationInvalidRegID = Loc.tr("Errors", "errVerificationInvalidRegID")
    /// Registration not confirmed. Please provide confirmation code
    public static let errVerificationNotConfirmedRegID = Loc.tr("Errors", "errVerificationNotConfirmedRegID")
    /// User not found
    public static let errVerificationNotFoundUser = Loc.tr("Errors", "errVerificationNotFoundUser")
    /// Registration id not exists. Please register new user
    public static let errVerificationRegIdNotExists = Loc.tr("Errors", "errVerificationRegIdNotExists")
    /// Word not found. Maybe it already deleted?
    public static let errWordNotFound = Loc.tr("Errors", "errWordNotFound")
  }
  public enum Localizable {
    /// Accept
    public static let acceptInvite = Loc.tr("Localizable", "acceptInvite")
    /// Your account successfully created %
    public static let accountCreated = Loc.tr("Localizable", "accountCreated")
    /// Add
    public static let add = Loc.tr("Localizable", "add")
    /// New vocabulary
    public static let addGroupTitle = Loc.tr("Localizable", "addGroupTitle")
    /// Add to dictionary
    public static let addToDictionary = Loc.tr("Localizable", "addToDictionary")
    /// Add word
    public static let addWordAction = Loc.tr("Localizable", "addWordAction")
    /// Add word
    public static let addWordTitle = Loc.tr("Localizable", "addWordTitle")
    /// Everything is correct
    public static let allCorrect = Loc.tr("Localizable", "allCorrect")
    /// App version
    public static let appVersion = Loc.tr("Localizable", "appVersion")
    /// Asked you to become student
    public static let askedYouBecomeStudent = Loc.tr("Localizable", "askedYouBecomeStudent")
    /// Become student
    public static let becomeStudent = Loc.tr("Localizable", "becomeStudent")
    /// Cancel
    public static let cancel = Loc.tr("Localizable", "cancel")
    /// Cancel invite
    public static let cancelInvite = Loc.tr("Localizable", "cancelInvite")
    /// Change app icon
    public static let changeAppIcon = Loc.tr("Localizable", "changeAppIcon")
    /// Close
    public static let closeTitle = Loc.tr("Localizable", "closeTitle")
    /// A letter with a 6-digit code has been sent to your e-mail. To recover your password, enter the code from the letter
    public static let codeEmailSended = Loc.tr("Localizable", "codeEmailSended")
    /// Confrim password
    public static let confrimPasswordPlaceholder = Loc.tr("Localizable", "confrimPasswordPlaceholder")
    /// Copy
    public static let copy = Loc.tr("Localizable", "copy")
    /// Create
    public static let create = Loc.tr("Localizable", "create")
    /// Create invite link
    public static let createInviteLink = Loc.tr("Localizable", "createInviteLink")
    /// Come up with a new password to log in
    public static let createNewPasswordForLogin = Loc.tr("Localizable", "createNewPasswordForLogin")
    /// Current role:
    public static let currentRole = Loc.tr("Localizable", "currentRole")
    /// Delete
    public static let delete = Loc.tr("Localizable", "delete")
    /// Vocabularies
    public static let dictionaries = Loc.tr("Localizable", "dictionaries")
    /// Vocabulary
    public static let dictionary = Loc.tr("Localizable", "dictionary")
    /// Request sent. Wait for your teacher to accept it.
    public static let didSendRequestToBecomeStudent = Loc.tr("Localizable", "didSendRequestToBecomeStudent")
    /// Plural format key: "%#@VARIABLE@"
    public static func dWords(_ p1: Int) -> String {
      return Loc.tr("Localizable", "dWords", p1)
    }
    /// Update profile
    public static let editProfileAction = Loc.tr("Localizable", "editProfileAction")
    /// Update profile
    public static let editProfileTitle = Loc.tr("Localizable", "editProfileTitle")
    /// Edit word
    public static let editWordAction = Loc.tr("Localizable", "editWordAction")
    /// Edit word
    public static let editWordTitle = Loc.tr("Localizable", "editWordTitle")
    /// E-mail
    public static let emailPlaceholder = Loc.tr("Localizable", "emailPlaceholder")
    /// We have sent a confirmation code to your email. Enter the code in the box below to verify your account.
    public static let emailSendedToConfrim = Loc.tr("Localizable", "emailSendedToConfrim")
    /// You don't yet have any vocabulary.\nTap 'plus' to add
    public static let emptyGroupsPlaceholder = Loc.tr("Localizable", "emptyGroupsPlaceholder")
    /// You don't have any words yet.\nTap 'plus' above to add
    public static let emptyWordsPlaceholder = Loc.tr("Localizable", "emptyWordsPlaceholder")
    /// English
    public static let en = Loc.tr("Localizable", "en")
    /// Enter code
    public static let enterCode = Loc.tr("Localizable", "enterCode")
    /// Enter your e-mail
    public static let enterYourEmail = Loc.tr("Localizable", "enterYourEmail")
    /// Feedback
    public static let feedback = Loc.tr("Localizable", "feedback")
    /// Please fill all fields.
    public static let fillAllFields = Loc.tr("Localizable", "fillAllFields")
    /// You almost done. Fill info about you
    public static let fillInfoDescription = Loc.tr("Localizable", "fillInfoDescription")
    /// Welcome!
    public static let fillInfoWelcome = Loc.tr("Localizable", "fillInfoWelcome")
    /// First name
    public static let firstName = Loc.tr("Localizable", "firstName")
    /// Please enter your email address that you used to create your account and we will send you a link to recover your password.
    public static let forgotPasswordSubtitle = Loc.tr("Localizable", "forgotPasswordSubtitle")
    /// Forgot password?
    public static let forgotPasswordTitle = Loc.tr("Localizable", "forgotPasswordTitle")
    /// General
    public static let general = Loc.tr("Localizable", "general")
    /// Incoming invites
    public static let incomingInvites = Loc.tr("Localizable", "incomingInvites")
    /// Incorrect code
    public static let incorrectCode = Loc.tr("Localizable", "incorrectCode")
    /// Incorrect data
    public static let incorrectDataTitle = Loc.tr("Localizable", "incorrectDataTitle")
    /// Incorrect e-mail
    public static let incorrectEmail = Loc.tr("Localizable", "incorrectEmail")
    /// Incorrect password
    public static let incorrectPassword = Loc.tr("Localizable", "incorrectPassword")
    /// Info
    public static let info = Loc.tr("Localizable", "info")
    /// Enter word
    public static let inputTranslationPlacholder = Loc.tr("Localizable", "inputTranslationPlacholder")
    /// First name can't be empty
    public static let invalidFirstName = Loc.tr("Localizable", "invalidFirstName")
    /// Login can't be empty
    public static let invalidNickname = Loc.tr("Localizable", "invalidNickname")
    /// Invites
    public static let invites = Loc.tr("Localizable", "invites")
    /// Last name
    public static let lastName = Loc.tr("Localizable", "lastName")
    /// Updated
    public static let lastUpdateTime = Loc.tr("Localizable", "lastUpdateTime")
    /// Log In
    public static let loginButtonTitle = Loc.tr("Localizable", "loginButtonTitle")
    /// Login or create an account to get started.
    public static let loginOrRegisterAccountSubtitle = Loc.tr("Localizable", "loginOrRegisterAccountSubtitle")
    /// Log in to your account to return to our ranks!
    public static let loginToReturnTitle = Loc.tr("Localizable", "loginToReturnTitle")
    /// Log out
    public static let logoutAlertConfirmationAction = Loc.tr("Localizable", "logoutAlertConfirmationAction")
    /// Are you sure you want to log out?
    public static let logoutAlertConfirmationTitle = Loc.tr("Localizable", "logoutAlertConfirmationTitle")
    /// Logout
    public static let logoutButtonTitle = Loc.tr("Localizable", "logoutButtonTitle")
    /// Name
    public static let name = Loc.tr("Localizable", "name")
    /// New password
    public static let newPassword = Loc.tr("Localizable", "newPassword")
    /// Login
    public static let nickname = Loc.tr("Localizable", "nickname")
    /// Login already in use. Choose another
    public static let nicknameAlreadyUsed = Loc.tr("Localizable", "nicknameAlreadyUsed")
    /// No translation
    public static let noTranslation = Loc.tr("Localizable", "noTranslation")
    /// OK
    public static let ok = Loc.tr("Localizable", "ok")
    /// Outcoming invites
    public static let outcomingInvites = Loc.tr("Localizable", "outcomingInvites")
    /// Result here
    public static let outputTranslationPlacholder = Loc.tr("Localizable", "outputTranslationPlacholder")
    /// Password changed!
    public static let passwordChanged = Loc.tr("Localizable", "passwordChanged")
    /// Password mismatch.
    public static let passwordConfrimation = Loc.tr("Localizable", "passwordConfrimation")
    /// Passwords mismatch
    public static let passwordMismatch = Loc.tr("Localizable", "passwordMismatch")
    /// Password
    public static let passwordPlaceholder = Loc.tr("Localizable", "passwordPlaceholder")
    /// I agree to the terms of use and accept the Privacy Policy.
    public static let privacyPolicyTitle = Loc.tr("Localizable", "privacyPolicyTitle")
    /// Profile
    public static let profile = Loc.tr("Localizable", "profile")
    /// Provide info
    public static let provideInfo = Loc.tr("Localizable", "provideInfo")
    /// Rate app in AppStore
    public static let rateApp = Loc.tr("Localizable", "rateApp")
    /// Recent
    public static let recent = Loc.tr("Localizable", "recent")
    /// Register to get started.
    public static let registerToStartTitle = Loc.tr("Localizable", "registerToStartTitle")
    /// Registration
    public static let registrationButtonTitle = Loc.tr("Localizable", "registrationButtonTitle")
    /// Reject
    public static let rejectInvite = Loc.tr("Localizable", "rejectInvite")
    /// Remove student
    public static let removeStudent = Loc.tr("Localizable", "removeStudent")
    /// Remove teacher
    public static let removeTeacher = Loc.tr("Localizable", "removeTeacher")
    /// Request support
    public static let requestSupport = Loc.tr("Localizable", "requestSupport")
    /// Required field
    public static let requiredField = Loc.tr("Localizable", "requiredField")
    /// Reset password
    public static let resetPassword = Loc.tr("Localizable", "resetPassword")
    /// Russian
    public static let ru = Loc.tr("Localizable", "ru")
    /// Save
    public static let save = Loc.tr("Localizable", "save")
    /// Search students
    public static let searchStudents = Loc.tr("Localizable", "searchStudents")
    /// Search teachers
    public static let searchTeachers = Loc.tr("Localizable", "searchTeachers")
    /// Send
    public static let send = Loc.tr("Localizable", "send")
    /// Send code
    public static let sendCode = Loc.tr("Localizable", "sendCode")
    /// Send feedback via email
    public static let sendFeedbackViaMail = Loc.tr("Localizable", "sendFeedbackViaMail")
    /// Settings
    public static let settings = Loc.tr("Localizable", "settings")
    /// Share
    public static let share = Loc.tr("Localizable", "share")
    /// Bring your students and learn together!
    public static let shareProfileDescription = Loc.tr("Localizable", "shareProfileDescription")
    /// Invite student
    public static let shareProfileTitle = Loc.tr("Localizable", "shareProfileTitle")
    /// Do you want to delete vocabulary?\nThis cannot be undone.
    public static let shouldDeleteGroup = Loc.tr("Localizable", "shouldDeleteGroup")
    /// Do you want to delete word? This cannot be undone.
    public static let shouldDeleteWord = Loc.tr("Localizable", "shouldDeleteWord")
    /// You almost done!\nOne more last step left
    public static let shouldFinishInfoProviding = Loc.tr("Localizable", "shouldFinishInfoProviding")
    /// Student
    public static let student = Loc.tr("Localizable", "student")
    /// Students
    public static let students = Loc.tr("Localizable", "students")
    /// You don't have students yet.\nFond one and help him study better!
    public static let studentsEmptyPlaceholder = Loc.tr("Localizable", "studentsEmptyPlaceholder")
    /// Teacher
    public static let teacher = Loc.tr("Localizable", "teacher")
    /// You don't have a teacher yet.\nFind one and he will help you to study better!
    public static let teacherEmptyPlaceholder = Loc.tr("Localizable", "teacherEmptyPlaceholder")
    /// Teacher have not accept your invintation yet
    public static let teacherNotAcceptedInviteYet = Loc.tr("Localizable", "teacherNotAcceptedInviteYet")
    /// Find teacher
    public static let toSearchTeacher = Loc.tr("Localizable", "toSearchTeacher")
    /// Translation
    public static let translation = Loc.tr("Localizable", "translation")
    /// Type something in search field
    public static let typeSometingInSearchField = Loc.tr("Localizable", "typeSometingInSearchField")
    /// Type text here
    public static let typeText = Loc.tr("Localizable", "typeText")
    /// Unknown error
    public static let unknownError = Loc.tr("Localizable", "unknownError")
    /// Unnamed
    public static let unnamed = Loc.tr("Localizable", "unnamed")
    /// Update
    public static let update = Loc.tr("Localizable", "update")
    /// Username
    public static let usernamePlaceholder = Loc.tr("Localizable", "usernamePlaceholder")
    /// Verification
    public static let verification = Loc.tr("Localizable", "verification")
    /// Verify
    public static let verify = Loc.tr("Localizable", "verify")
    /// Welcome back
    public static let welcomeBackTitle = Loc.tr("Localizable", "welcomeBackTitle")
    /// Welcome
    public static let welcomeTitle = Loc.tr("Localizable", "welcomeTitle")
    /// Word
    public static let word = Loc.tr("Localizable", "word")
    /// Description
    public static let wordDescription = Loc.tr("Localizable", "wordDescription")
    /// Words
    public static let words = Loc.tr("Localizable", "words")
    /// You can become student.\nGood luck in learning!
    public static let youCanSendRequestToBecomeStudent = Loc.tr("Localizable", "youCanSendRequestToBecomeStudent")
    /// You already have a teacher or invited someone.
    public static let youCantBecomeStudent = Loc.tr("Localizable", "youCantBecomeStudent")
    /// You definitely should add something here
    public static let youShouldAddWordDescription = Loc.tr("Localizable", "youShouldAddWordDescription")
    /// Vocabulary is empty.
    public static let youShouldAddWordTitle = Loc.tr("Localizable", "youShouldAddWordTitle")
    /// Cant add empty word. Type something in first field
    public static let youShouldTypeText = Loc.tr("Localizable", "youShouldTypeText")
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension Loc {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.coreModule.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
