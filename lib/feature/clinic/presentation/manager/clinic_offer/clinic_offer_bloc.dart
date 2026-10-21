import 'package:bloc/bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/delete_clinic_offer_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_offer_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_offer_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_offer/clinic_offer_event.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_offer/clinic_offer_state.dart';

class ClinicOfferBloc extends Bloc<ClinicOfferEvent, ClinicOfferState> {
  final GetClinicOfferUseCase getClinicOfferUseCase;
  final SaveClinicOfferUseCase saveClinicOfferUseCase;
  final DeleteClinicOfferUseCase deleteClinicOfferUseCase;

  ClinicOfferBloc({
    required this.getClinicOfferUseCase,
    required this.saveClinicOfferUseCase,
    required this.deleteClinicOfferUseCase,
  }) : super(ClinicOfferInitial()) {
    on<GetClinicOfferEvent>((event, emit) async {
      emit(ClinicOfferLoading());
      final result = await getClinicOfferUseCase.call(clinicId: event.clinicId);
      result.fold(
        (error) => emit(ClinicOfferError(
            errorMessage: error.message ?? 'Failed to load clinic offer')),
        (offer) => emit(ClinicOfferLoaded(offer: offer)),
      );
    });

    on<SaveClinicOfferEvent>((event, emit) async {
      emit(ClinicOfferSaving());
      final result =
          await saveClinicOfferUseCase.call(offerEntity: event.offerEntity);
      result.fold(
        (error) => emit(ClinicOfferError(
            errorMessage: error.message ?? 'Failed to save clinic offer')),
        (_) => emit(const ClinicOfferSaveSuccess()),
      );
    });

    on<DeleteClinicOfferEvent>((event, emit) async {
      emit(ClinicOfferDeleting());
      final result =
          await deleteClinicOfferUseCase.call(offerId: event.offerId);
      result.fold(
        (error) => emit(ClinicOfferError(
            errorMessage: error.message ?? 'Failed to delete clinic offer')),
        (_) => emit(const ClinicOfferDeleteSuccess()),
      );
    });
  }
}
