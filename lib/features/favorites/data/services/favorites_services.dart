import 'package:hive/hive.dart';
import '../models/clinic_hive_model.dart';

class FavoritesService {
  final Box<ClinicHiveModel> _box = Hive.box('favoriteClinics');

  Future<void> addFavorite(ClinicHiveModel clinic) async {
    await _box.put(clinic.clinicId, clinic);
  }

  Future<void> removeFavorite(String clinicId) async {
    await _box.delete(clinicId);
  }

  bool isFavorite(String clinicId) {
    return _box.containsKey(clinicId);
  }

  List<ClinicHiveModel> getFavorites() {
    return _box.values.toList();
  }
}
