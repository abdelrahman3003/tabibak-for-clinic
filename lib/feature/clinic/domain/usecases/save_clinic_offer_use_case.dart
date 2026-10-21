import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/offer_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class SaveClinicOfferUseCase {
  final ClinicRepo clinicRepo;

  SaveClinicOfferUseCase({required this.clinicRepo});

  Future<Either<ApiErrorModel, void>> call({required OfferEntity offerEntity}) async {
    return await clinicRepo.saveClinicOffer(offerEntity: offerEntity);
  }
}
