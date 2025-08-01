import 'package:flutter/foundation.dart';
import 'package:frontend/models/clinical_data.dart';
import 'package:frontend/services/clinical_data_service.dart';

class ClinicalDataProvider with ChangeNotifier {
  List<ClinicalData> _clinicalData = [];
  bool _isLoading = false;
  String? _error;

  List<ClinicalData> get clinicalData => _clinicalData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ClinicalDataService _service;

  ClinicalDataProvider(this._service);

  Future<void> loadClinicalData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clinicalData = await _service.getClinicalData();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addClinicalData(ClinicalData data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newData = await _service.addClinicalData(data);
      _clinicalData.insert(0, newData); // Ajout en tête de liste
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}