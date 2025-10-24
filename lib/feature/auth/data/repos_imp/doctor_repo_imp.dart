import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/doctor_data_source.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/clinic_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/shift_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/unversity_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/workday_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_day_shift.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/time_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/university_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/doctor_repo.dart';

class DoctorRepoImp implements DoctorRepo {
  final DoctorDataSource doctorDataSource;

  DoctorRepoImp({required this.doctorDataSource});
  // @override
  // Future<Either<ApiErrorModel, int>> addClinic(ClinicEntity clinicEntity,
  //     {required int doctorId}) async {
  //   final clinicModel = ClinicModel(
  //       doctorId: doctorId,
  //       clinicName: clinicEntity.clinicName,
  //       address: clinicEntity.address,
  //       isBooking: clinicEntity.isBooking,
  //       consultationFee: clinicEntity.consultationFee,
  //       phoneNumber: clinicEntity.phoneNumber);
  //   try {
  //     final result = await doctorDataSource.addClinic(clinicModel);
  //     return right(result);
  //   } catch (e) {
  //     return left(ErrorHandler.handle(e));
  //   }
  // }

  // @override
  // Future<Either<ApiErrorModel, int>> addDoctor(
  //     DoctorEntity doctorEntity) async {
  //   final doctorModel = DotcorModel(
  //       name: doctorEntity.name,
  //       phone: doctorEntity.phone,
  //       image: doctorEntity.image,
  //       specialty: doctorEntity.specialty,
  //       isVerified: doctorEntity.isVerified,
  //       bio: doctorEntity.bio);
  //   try {
  //     final result = await doctorDataSource.addDoctor(doctorModel);
  //     return right(result);
  //   } catch (e) {
  //     return left(ErrorHandler.handle(e));
  //   }
  // }

  // @override
  // Future<Either<ApiErrorModel, int>> addTime(TimeEntity timeEntity) async {
  //   final timeModel = TimeModel(start: timeEntity.start, end: timeEntity.end);
  //   try {
  //     final result = await doctorDataSource.addTime(timeModel);
  //     return right(result);
  //   } catch (e) {
  //     return left(ErrorHandler.handle(e));
  //   }
  // }

  // @override
  // Future<Either<ApiErrorModel, int>> addShift(ShiftEntity shiftEntity,
  //     {required int workdayId}) async {
  //   final shiftModel = ShiftModel(
  //       morning: shiftEntity.morning,
  //       evening: shiftEntity.evening,
  //       workingDayId: workdayId);
  //   try {
  //     final result = await doctorDataSource.addShift(shiftModel);
  //     return right(result);
  //   } catch (e) {
  //     return left(ErrorHandler.handle(e));
  //   }
  // }

  // @override
  // Future<Either<ApiErrorModel, int>> addWorkDay(WorkDayEntity workDayEntity,
  //     {required int clinicId}) async {
  //   final workingDayModel = WorkingDayModel(
  //     day: workDayEntity.day,
  //     clinicId: workDayEntity.clinicId,
  //   );
  //   try {
  //     final result = await doctorDataSource.addWorkDay(workingDayModel);
  //     return right(result);
  //   } catch (e) {
  //     return left(ErrorHandler.handle(e));
  //   }
  // }

  // @override
  // Future<Either<ApiErrorModel, int>> addUniversity(
  //     UniversityEntity universityEntity,
  //     {required int doctorId}) async {
  //   final unversityModel = UnversityModel(
  //       doctorId: doctorId,
  //       universityName: universityEntity.universityName,
  //       graduationYear: universityEntity.graduationYear);
  //   try {
  //     final result = await doctorDataSource.addUniversity(unversityModel);
  //     return right(result);
  //   } catch (e) {
  //     return left(ErrorHandler.handle(e));
  //   }
  // }

  @override
  Future<Either<ApiErrorModel, void>> addDoctorData({
    required DoctorEntity doctorEntity,
    required ClinicEntity clinicEntity,
    required UniversityEntity universityEntity,
    required List<WorkDayShift> workDayShifts,
  }) async {
    log('Adding doctor data...');
    try {
      log('Adding doctor data... 12112');

      final profilePhotoUrl =
          await doctorDataSource.uploadFile(doctorEntity.image);
      log('Uploaded profile photo: $profilePhotoUrl');

      final nationalIdUrl =
          await doctorDataSource.uploadFile(doctorEntity.nationalId);
      log('Uploaded national ID: $nationalIdUrl');
      final medicalLicenseUrl =
          await doctorDataSource.uploadFile(doctorEntity.medicalLiecense);
      log("--------------------3");
      final doctorModel = DotcorModel(
        name: doctorEntity.name,
        phone: doctorEntity.phone,
        image: profilePhotoUrl,
        specialty: doctorEntity.specialty,
        bio: doctorEntity.bio,
        nationalId: nationalIdUrl,
        medicalLiecense: medicalLicenseUrl,
      );
      final doctorId = await doctorDataSource.addDoctor(doctorModel);
      log("--------------------4");

      final unversityModel = UnversityModel(
          doctorId: doctorId,
          universityName: universityEntity.universityName,
          graduationYear: universityEntity.graduationYear);
      await doctorDataSource.addUniversity(unversityModel);
      log("--------------------5");

      final clinicModel = ClinicModel(
          doctorId: doctorId,
          clinicName: clinicEntity.clinicName,
          address: clinicEntity.address,
          isBooking: clinicEntity.isBooking,
          consultationFee: clinicEntity.consultationFee,
          phoneNumber: clinicEntity.phoneNumber);
      final clinicId = await doctorDataSource.addClinic(clinicModel);
      log("--------------------6");

      for (var workDayShift in workDayShifts) {
        final workingDayModel =
            WorkingDayModel(day: workDayShift.day, clinicId: clinicId);
        final workdayId = await doctorDataSource.addWorkDay(workingDayModel);
        log("--------------------7");

        final shiftModel = ShiftModel(
          morning: TimeEntity(
            start: formatTimeOfDay(workDayShift.morningStart),
            end: formatTimeOfDay(workDayShift.morningEnd),
          ),
          evening: TimeEntity(
            start: formatTimeOfDay(workDayShift.eveningStart),
            end: formatTimeOfDay(workDayShift.eveningEnd),
          ),
          workingDayId: workdayId,
        );

        await doctorDataSource.addShift(shiftModel);
        log("--------------------8");
      }

      return right(null);
    } catch (e) {
      log('Error adding doctor data: $e');
      return left(ErrorHandler.handle(e));
    }
  }
}

String formatTimeOfDay(TimeOfDay? time) {
  if (time == null) return '';
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
