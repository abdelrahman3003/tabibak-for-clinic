import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/offer_entity.dart';

abstract class ClinicOfferState extends Equatable {
  const ClinicOfferState();

  @override
  List<Object?> get props => [];
}

class ClinicOfferInitial extends ClinicOfferState {}

class ClinicOfferLoading extends ClinicOfferState {}

class ClinicOfferLoaded extends ClinicOfferState {
  final OfferEntity? offer;

  const ClinicOfferLoaded({this.offer});

  @override
  List<Object?> get props => [offer];
}

class ClinicOfferSaving extends ClinicOfferState {}

class ClinicOfferSaveSuccess extends ClinicOfferState {
  const ClinicOfferSaveSuccess();
}

class ClinicOfferDeleting extends ClinicOfferState {}

class ClinicOfferDeleteSuccess extends ClinicOfferState {
  const ClinicOfferDeleteSuccess();
}

class ClinicOfferError extends ClinicOfferState {
  final String errorMessage;

  const ClinicOfferError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
