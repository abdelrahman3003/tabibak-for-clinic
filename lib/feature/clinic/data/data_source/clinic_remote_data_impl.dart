import 'package:dio/dio.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';

class ClinicRemoteDataImpl implements ClinicRemoteData {
  final Dio dio;

  ClinicRemoteDataImpl({required this.dio});

  @override
  Future<int> createClinicInfo(ClinicInfoModel clinicInfoModel) async {
    final response = await dio.post(
      '/clinics',
      data: clinicInfoModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['id'];
    } else {
      throw Exception('Failed to create clinic');
    }
  }
}
