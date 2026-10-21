import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class DeleteClinicOfferUseCase {
  final ClinicRepo clinicRepo;

  DeleteClinicOfferUseCase({required this.clinicRepo});

  Future<Either<ApiErrorModel, void>> call({required int offerId}) async {
    return await clinicRepo.deleteClinicOffer(offerId: offerId);
  }
}
