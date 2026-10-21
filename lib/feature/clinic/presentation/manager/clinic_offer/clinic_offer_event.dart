import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/offer_entity.dart';

abstract class ClinicOfferEvent extends Equatable {
  const ClinicOfferEvent();

  @override
  List<Object?> get props => [];
}

class GetClinicOfferEvent extends ClinicOfferEvent {
  final int clinicId;

  const GetClinicOfferEvent({required this.clinicId});

  @override
  List<Object?> get props => [clinicId];
}

class SaveClinicOfferEvent extends ClinicOfferEvent {
  final OfferEntity offerEntity;

  const SaveClinicOfferEvent({required this.offerEntity});

  @override
  List<Object?> get props => [offerEntity];
}

class DeleteClinicOfferEvent extends ClinicOfferEvent {
  final int offerId;

  const DeleteClinicOfferEvent({required this.offerId});

  @override
  List<Object?> get props => [offerId];
}
