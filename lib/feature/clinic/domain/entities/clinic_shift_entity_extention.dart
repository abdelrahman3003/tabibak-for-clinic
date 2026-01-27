import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_type.dart';

extension ClinicShiftEntityX on ClinicShiftEntity {
  List<ShiftType> availableShiftTypes() {
    final List<ShiftType> result = [];

    if (start != null) {
      result.add(ShiftType.morning);
    }

    if (end != null) {
      result.add(ShiftType.evening);
    }

    return result;
  }
}
