class AppString {
  static const String signUp = "Sign up";

  // Section titles
  static const String personalInformation = "Personal Information";
  static const String clinicInformation = "Clinic Information";
  static const String specializationInformation = "Specialization Information";
  static const String documentsVerification = "Documents Verification";
  static const String reviewAndSubmit = "Review & Submit";

  // Personal info
  static const String firstName = "First name";
  static const String lastName = "Last name";
  static const String email = "Email";
  static const String phoneNumber = "Phone number";
  static const String verifyOtp = "Verify OTP";
  static const String password = "Password";
  static const String confirmPassword = "Confirm password";

  // Clinic info
  static const String clinicName = "Clinic name";
  static const String clinicAddress = "Clinic address";
  static const String governorate = "Governorate";
  static const String area = "Area";
  static const String clinicLocation = "Clinic location";
  static const String pickOnMap = "Pick on map";
  static const String workingHours = "Working hours";
  static const String daysAndTimeSlots = "Days & Time Slots";
  static const String landlineNumber = "Landline number (optional)";

  // Specialization info
  static const String mainSpecialization = "Main specialization";
  static const String subSpecializations = "Sub specializations (optional)";
  static const String consultationFee = "Consultation fee";
  static const String consultationDuration = "Consultation duration";

  // Documents
  static const String uploadDocuments = "Upload documents";
  static const String nationalId = "National ID";
  static const String medicalLicense = "Medical license";
  static const String profilePhoto = "Profile photo";
  static const String medicalSyndicateNumber =
      "Medical syndicate number (optional)";

  // Review and submission
  static const String submit = "Submit";
  static const String reviewData = "Review your data before submitting";
  static const String pendingApproval = "Pending approval";
  static const String approvalNotification = "Approval notification";

  // Onboarding
  static const String welcomeDoctor = "Welcome, Doctor!";
  static const String manageAppointments = "Manage your appointments";
  static const String managePatients = "Track your patients";
  static const String manageRevenue = "Monitor your revenue";
  static const String getStarted = "Get started";
  static const String next = "Next";
  static const String back = "Back";
  static const String finish = "Finish";

  // OTP
  static const String otpSent = "OTP has been sent to your phone number";
  static const String resendOtp = "Resend OTP";
  static const String enterOtp = "Enter OTP";
  static const String pleaseWait = "Please wait...";

  // Upload
  static const String upload = "Upload";
  static const String chooseFile = "Choose file";
  static const String takePhoto = "Take photo";
  static const String gallery = "Gallery";
  static const String camera = "Camera";

  // schedule
  static const String weeklyOverview = "Weekly Overview";
  static String weeklyDays(int daysCount) =>
      "This week has $daysCount days scheduled";
  static String weeklyShiftHours(String startMorning, String endMorning,
          String startEvening, String endEvening) =>
      "Note: Morning shifts are from $startMorning to $endMorning, Evening shifts are from $startEvening to $endEvening";
  static const scheduleHours = "Schedule hours";
  static const day = "Day";
  static const morning = "Morning";
  static const evening = "Evening";
}
