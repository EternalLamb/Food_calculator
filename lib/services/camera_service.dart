import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CameraException implements Exception {
  final String message;
  CameraException(this.message);

  @override
  String toString() => message;
}

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      return photo?.path;
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied') {
        throw CameraException(
          'Permiso de cámara denegado. Actívalo en Ajustes del teléfono.',
        );
      }
      throw CameraException('No se pudo abrir la cámara (${e.code}).');
    } catch (_) {
      throw CameraException('Error inesperado al usar la cámara.');
    }
  }
}
