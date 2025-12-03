import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/camera_reo_imp.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository _repo;

  CameraCubit(this._repo) : super(CameraState());

  CameraController? get controller => (_repo as CameraRepImp).controller;

  Future<void> openCamera() async {
    emit(state.copyWith(isInitializing: true));
    await _repo.openCamera();
    emit(
      state.copyWith(
        isOpened: true,
        isInitializing: false,
        controller: (_repo as CameraRepImp).controller,
      ),
    );
  }

  Future<void> capturePhoto() async {
    emit(state.copyWith(isProcessing: true));
    
    final photo = await _repo.capturePhoto();
    
    await Future.delayed(const Duration(seconds: 3));
    
    emit(state.copyWith(
      photo: photo,
      hasCaptured: true,
      isProcessing: false,
      showResult: true,
    ));
  }

  void retakePhoto() {
    emit(state.copyWith(
      photo: null,
      hasCaptured: false,
      showResult: false,
    ));
  }

  @override
  Future<void> close() {
    controller?.dispose();
    return super.close();
  }
}