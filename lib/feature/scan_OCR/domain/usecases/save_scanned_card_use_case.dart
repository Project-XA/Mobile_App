// feature/scan_OCR/domain/usecases/save_scanned_card_usecase.dart

import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';

class SaveScannedCardUseCase {
  final UserLocalDataSource _dataSource;

  SaveScannedCardUseCase(this._dataSource);

  Future<void> execute(Map<String, String> ocrData) async {
    

    String getOcrValue(List<String> possibleKeys, {String defaultValue = 'N/A'}) {
      for (final key in possibleKeys) {
        final value = ocrData[key];
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
      return defaultValue;
    }

    final userModel = UserModel(
      nationalId: getOcrValue(
        ['national_id', 'nid', 'id', 'nationalId', 'idNumber'],
        defaultValue: 'UNKNOWN_${DateTime.now().millisecondsSinceEpoch}',
      ),
      
      firstNameAr: getOcrValue(
        ['first_name_ar', 'first_name', 'firstName', 'name_ar'],
        defaultValue: ocrData['name']?.split(' ').firstOrNull ?? 'N/A',
      ),
      
      lastNameAr: getOcrValue(
        ['last_name_ar', 'last_name', 'lastName'],
        defaultValue: ocrData['name']?.split(' ').lastOrNull ?? 'N/A',
      ),
      
      address: getOcrValue(['address', 'addr', 'location'], defaultValue: 'Helwan'),
      
      birthDate: getOcrValue(
        ['birth_date', 'dob', 'birthDate', 'date_of_birth', 'dateOfBirth'],
        defaultValue: '0102/21',
      ),
      idCardImage: ocrData['photo'],
      email: null,
      firstNameEn: null,
      lastNameEn: null,
      organizations: null,
      profileImage: null,
    );

    await _dataSource.saveLocalUserData(userModel);
  }
}