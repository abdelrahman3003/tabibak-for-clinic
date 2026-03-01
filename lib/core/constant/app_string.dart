import 'package:easy_localization/easy_localization.dart';

class AppString {
  static String get signUp => "Sign up".tr();
  static String get personalInformation => "Personal Information".tr();
  static String get clinicInformation => "Clinic Information".tr();
  static String get specializationInformation =>
      "Specialization Information".tr();
  static String get documentsVerification => "Documents Verification".tr();
  static String get reviewAndSubmit => "Review & Submit".tr();
  static String get firstName => "First name".tr();
  static String get lastName => "Last name".tr();
  static String get email => "Email".tr();
  static String get phoneNumber => "Phone number".tr();
  static String get verifyOtp => "Verify OTP".tr();
  static String get password => "Password".tr();
  static String get confirmPassword => "Confirm password".tr();
  static String get clinicName => "Clinic name".tr();
  static String get clinicAddress => "Clinic address".tr();
  static String get governorate => "Governorate".tr();
  static String get area => "Area".tr();
  static String get clinicLocation => "Clinic location".tr();
  static String get pickOnMap => "Pick on map".tr();
  static String get workingHours => "Working hours".tr();
  static String get daysAndTimeSlots => "Days & Time Slots".tr();
  static String get landlineNumber => "Landline number (optional)".tr();
  static String get mainSpecialization => "Main specialization".tr();
  static String get subSpecializations => "Sub specializations (optional)".tr();
  static String get consultationFee => "Consultation fee".tr();
  static String get consultationDuration => "Consultation duration".tr();
  static String get uploadDocuments => "Upload documents".tr();
  static String get nationalId => "National ID".tr();
  static String get medicalLicense => "Medical license".tr();
  static String get profilePhoto => "Profile photo".tr();
  static String get medicalSyndicateNumber =>
      "Medical syndicate number (optional)".tr();
  static String get submit => "Submit".tr();
  static String get reviewData => "Review your data before submitting".tr();
  static String get pendingApproval => "Pending approval".tr();
  static String get approvalNotification => "Approval notification".tr();
  static String get welcomeDoctor => "Welcome, Doctor!".tr();
  static String get manageAppointments => "Manage your appointments".tr();
  static String get managePatients => "Track your patients".tr();
  static String get manageRevenue => "Monitor your revenue".tr();
  static String get getStarted => "Get started".tr();
  static String get next => "Next".tr();
  static String get back => "Back".tr();
  static String get finish => "Finish".tr();
  static String get otpSent => "OTP has been sent to your phone number".tr();
  static String get resendOtp => "Resend OTP".tr();
  static String get enterOtp => "Enter OTP".tr();
  static String get pleaseWait => "Please wait...".tr();
  static String get upload => "Upload".tr();
  static String get chooseFile => "Choose file".tr();
  static String get takePhoto => "Take photo".tr();
  static String get gallery => "Gallery".tr();
  static String get camera => "Camera".tr();
  static String get weeklyOverview => "Weekly Overview".tr();
  static String weeklyDays(int daysCount) =>
      "This week has $daysCount days scheduled".tr();
  static String weeklyShiftHours(String startMorning, String endMorning,
          String startEvening, String endEvening) =>
      "Note: Morning shifts are from $startMorning to $endMorning, Evening shifts are from $startEvening to $endEvening"
          .tr();
  static String get scheduleHours => "Schedule hours".tr();
  static String get day => "Day".tr();
  static String get morning => "Morning".tr();
  static String get evening => "Evening".tr();
  static String get checkEmail => "Check your email".tr();
  static String get verificationEmailSent =>
      "We have sent a verification email to your email address. Please check your inbox and follow the instructions to verify your account."
          .tr();
  static String get backToLogin => "Back to Sign In".tr();
  static String get forgotPassword => "Forgot Password".tr();
  static String get forgotPasswordSubtitle =>
      "Enter your email address and we will send you a code to reset your password."
          .tr();
  static String get sendCode => "Send Code".tr();
  static String get verifyCode => "Verify Code".tr();
  static String get resendCode => "Resend Code".tr();
  static String get createNewPassword => "Create New Password".tr();
  static String get resetPasswordSubtitle =>
      "Your new password must be different from previous used passwords.".tr();
  static String get newPassword => "New Password".tr();
  static String get confirmNewPassword => "Confirm New Password".tr();
  static String get resetPassword => "Reset Password".tr();
  static String get passwordResetSuccess => "Password Reset Successful".tr();
  static String get passwordResetSuccessSubtitle =>
      "Your password has been successfully reset. You can now sign in with your new password."
          .tr();
  static String get resendAfter => "Resend after".tr();
  static String get seconds => "seconds".tr();
  static String get hello => "Hello,".tr();
  static String get sendingCode => "Sending code...".tr();

  // Appointments Localization
  static String get appointments => "Appointments".tr();
  static String get appointmentsToday => "Appointments Today".tr();
  static String get seeAll => "See All".tr();
  static String get noUpcomingAppointments => "No Upcoming Appointments".tr();
  static String get noCanceledAppointments => "No Canceled Appointments".tr();
  static String get noFinishedAppointments => "No Finished Appointments".tr();
  static String get noAppointmentsToday => "No Appointments Today".tr();
  static String get upcoming => "Upcoming".tr();
  static String get completed => "Completed".tr();
  static String get cancelled => "Cancelled".tr();
  static String get finished => "Finished".tr();
  static String get appointmentEmptySubtitle =>
      "You have a clear schedule for now. \nEnjoy your free time!".tr();

  // Clinic Localization
  static String get addressNotAvailable => "Address Not Available".tr();
  static String get knownName => "Known Name".tr();
  static String get clinicOffer => "Clinic Offer".tr();
  static String get knownOffer => "Known Offer".tr();
  static String get featureUnavailableMessage =>
      "This section is currently unavailable. We are working on enhancing this feature to provide you with a better experience."
          .tr();
  static String get schedule => "Schedule".tr();
  static String get edit => "Edit".tr();
  static String get shiftTimes => "Shift Times".tr();
  static String get clinicWorkingDays => "Clinic Working Days".tr();
  static String get selectWorkingDays => "Select working days".tr();
  static String get selectWorkingDaysSubtitle =>
      "Tap on the cards to select the days your clinic is open for patients."
          .tr();
  static String get continueButton => "Continue".tr();
  static String get clinicDirections => "Clinic Directions".tr();
  static String get enableOnlineBookingSubtitle =>
      "Enable this option if you want patients to book appointments online."
          .tr();
  static String get onlineBooking => "Online Booking".tr();
  static String get createClinic => "Create Clinic".tr();
  static String get setupYourClinic => "Setup Your Clinic".tr();
  static String get setupClinicSubtitle =>
      "Add your clinic details, working days and schedule to get started.".tr();
  static String get egyptianPound => "EGP".tr();
  static String get startTime => "Start Time".tr();
  static String get endTime => "End Time".tr();
  static String get selectTime => "Select Time".tr();
  static String get save => "Save".tr();
  static String get clinic => "Clinic".tr();
  static String get profile => "Profile".tr();

  // Profile Localization
  static String get doctorInformation => "Doctor Information".tr();
  static String get specialty => "Specialty".tr();
  static String get notSpecified => "Not Specified".tr();
  static String get education => "Education".tr();
  static String get educationIsEmpty => "Education is empty".tr();
  static String get setting => "Setting".tr();
  static String get aboutUs => "About Us".tr();
  static String get privacy => "Privacy".tr();
  static String get logOut => "LogOut".tr();
  static String get cancel => "Cancel".tr();
  static String get close => "Close".tr();
  static String get ok => "OK".tr();
  static String get notice => "Notice".tr();
  static String get unknownError => "UnKnown error".tr();
  static String get unknown => "UnKnown".tr();
  static String get logOutSubtitle => "Are you sure you want to log out?".tr();

  // Auth Localization
  static String get login => "Log in".tr();
  static String get loggingIn => "Logging in...".tr();
  static String get signIn => "Sign In".tr();
  static String get welcomeBack => "Welcome Back".tr();
  static String get signinSubtitle =>
      "Sign in to continue to Tabibak Clinic".tr();
  static String get forgotPasswordQuestion => "Forgot Password?".tr();
  static String get or => "OR".tr();
  static String get dontHaveAccount => "Don't have an account?".tr();
  static String get createAccount => "Create Account".tr();
  static String get signupSubtitle =>
      "Sign up to continue to Tabibak Clinic".tr();
  static String get alreadyHaveAccount => "Already have an account?".tr();
  static String get signinWithGoogle => "Sign in with Google".tr();
  static String get fullName => "Full Name".tr();
  static String get required => "Required".tr();
  static String get professionalPracticeLicense =>
      "Professional Practice License".tr();
  static String get uploadLicense =>
      "Upload your professional practice license".tr();
  static String get uploadLicenseDescription =>
      "Please provide a clear image of your valid license to verify your professional status."
          .tr();
  static String get enterCodeSentTo => "Enter the code sent to ".tr();
  static String get confirm => "Confirm".tr();
  static String get tapToUploadLicense => "Tap to upload license".tr();
  static String get selectSpecialty => "Select Specialty".tr();
  static String get selectSpecialtyValidator =>
      "Please select a specialty".tr();
  static String get universityInformation => "University Information".tr();
  static String get universityName => "University Name".tr();
  static String get graduationYear => "Graduation Year".tr();
  static String get clinicNumber => "Clinic number".tr();
  static String get uploadImageFile => "Upload Image / File".tr();
  static String get saturday => "Saturday".tr();
  static String get sunday => "Sunday".tr();
  static String get monday => "Monday".tr();
  static String get tuesday => "Tuesday".tr();
  static String get wednesday => "Wednesday".tr();
  static String get thursday => "Thursday".tr();
  static String get friday => "Friday".tr();
  static String get morningShift => "Morning Shift".tr();
  static String get eveningShift => "Evening Shift".tr();
  static String get passwordChangedSuccess =>
      "Password has been changed successfully".tr();
  static String get passwordsNotMatching => "Not Matching Password".tr();
  static String get clinicWorkingDaysAndTime =>
      "Clinic Working Days & Time".tr();
}
