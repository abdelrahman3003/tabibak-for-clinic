import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_day_shift.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/signup/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/clinic_section.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/decument_section.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/personal_section.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/register_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/specialise_section.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/university_section.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/work_day_section.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

// Controllers
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController bioController = TextEditingController();
final TextEditingController clinicNameController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController consultationFeeController = TextEditingController();
final TextEditingController clinicPhoneController = TextEditingController();
final TextEditingController universityNameController = TextEditingController();
final TextEditingController graduationYearController = TextEditingController();
String? selectedNationalIdPath;
String? selectedMedicalLicensePath;
String? selectedProfilePhotoPath;
List<WorkDayShift> workDayShifts = [];
int? selectedSpecialization;
bool isRegistered = false;
final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    emailController.text = "doctor@example.com";
    passwordController.text = "123456";
    nameController.text = "Dr. Ahmed Ali";
    phoneController.text = "01012345678";

    bioController.text = "دكتور متخصص في الأمراض الجلدية والتجميل.";
    clinicNameController.text = "عيادة الشفاء";
    addressController.text = "شارع التحرير، القاهرة";
    consultationFeeController.text = "250";
    clinicPhoneController.text = "0223456789";
    universityNameController.text = "جامعة القاهرة";
    graduationYearController.text = "2018";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Form(
          key: signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.hBox,
              Center(
                child: Text(
                  AppString.signUp,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              30.hBox,
              PersonalSection(
                  nameController: nameController,
                  emailController: emailController,
                  phoneController: phoneController,
                  passwordController: passwordController),
              30.hBox,
              UniversitySection(
                  universityNameController: universityNameController,
                  graduationYearController: graduationYearController),
              30.hBox,
              SpecialiseSection(
                bioController: bioController,
                onChanged: (value) {
                  selectedSpecialization = value;
                },
                isRegistered: isRegistered,
              ),
              30.hBox,
              ClinicSection(
                clinicNameController: clinicNameController,
                clinicPhoneController: clinicPhoneController,
                addressController: addressController,
                consultationFeeController: consultationFeeController,
              ),
              30.hBox,
              WorkDaySection(
                onScheduleChanged: (workDayShift) {
                  workDayShifts = workDayShift;
                },
              ),
              30.hBox,
              DecumentSection(
                onNaionalIdSelected: (file) {
                  selectedNationalIdPath = file?.path;
                },
                onMedicalLicenseSelected: (file) {
                  selectedMedicalLicensePath = file?.path;
                },
                onProfilePhotoSelected: (file) {
                  selectedProfilePhotoPath = file?.path;
                },
                isRegistered: isRegistered,
              ),
              20.hBox,
              RegisterButton(
                onPressed: () {
                  setState(() {
                    isRegistered = true;
                  });
                  if (signupFormKey.currentState!.validate() &&
                      selectedProfilePhotoPath != null &&
                      selectedNationalIdPath != null &&
                      selectedMedicalLicensePath != null &&
                      selectedSpecialization != null) {
                    BlocProvider.of<SignupBloc>(context).add(SignupRequested(
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      password: passwordController.text,
                      image: selectedProfilePhotoPath ?? '',
                      bio: bioController.text,
                      specialty: selectedSpecialization ?? 1,
                      clinicName: clinicNameController.text,
                      address: addressController.text,
                      consultationFee: double.tryParse(
                              consultationFeeController.text.trim()) ??
                          0.0,
                      clinicPhone: clinicPhoneController.text,
                      universityName: universityNameController.text,
                      graduationYear: int.parse(graduationYearController.text),
                      workDayShifts: workDayShifts,
                      medicalLiecense: selectedMedicalLicensePath ?? "",
                      nationalId: selectedNationalIdPath ?? "",
                    ));
                  }
                },
              ),
              50.hBox
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    clinicNameController.dispose();
    addressController.dispose();
    consultationFeeController.dispose();
    clinicPhoneController.dispose();
  }
}
