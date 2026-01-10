import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/Data/local_data_soruce/auth_state_model.dart';

class AuthStateService {
  static const String _boxName = 'auth_state_box';
  static const String _stateKey = 'auth_state';
  
  late Box<AuthStateModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<AuthStateModel>(_boxName);
    
    if (!_box.containsKey(_stateKey)) {
      await _box.put(_stateKey, AuthStateModel());
    }
  }

  AuthStateModel _getState() {
    return _box.get(_stateKey) ?? AuthStateModel();
  }

  Future<void> _saveState(AuthStateModel state) async {
    await _box.put(_stateKey, state);
  }

  Future<bool> hasCompletedOCR() async {
    return _getState().hasCompletedOCR;
  }

  Future<bool> hasRegistered() async {
    return _getState().hasRegistered;
  }

  Future<bool> isLoggedIn() async {
    return _getState().isLoggedIn;
  }

  Future<String?> getUserRole() async {
    return _getState().userRole;
  }

  Future<void> markOCRComplete() async {
    final state = _getState();
    state.hasCompletedOCR = true;
    await _saveState(state);
  }

  Future<void> markRegistrationComplete(String userRole) async {
    final state = _getState();
    state.hasRegistered = true;
    state.isLoggedIn = true;
    state.userRole = userRole;
    await _saveState(state);
  }

  Future<void> clearAuthState() async {
    final state = _getState();
    state.clearAuthOnly();
    await _saveState(state);
  }

  Future<void> clearAll() async {
    final state = _getState();
    state.reset();
    await _saveState(state);
  }

  Future<void> close() async {
    await _box.close();
  }
}
