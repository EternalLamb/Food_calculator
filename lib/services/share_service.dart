import 'package:share_plus/share_plus.dart';

class ShareException implements Exception {
  final String message;
  ShareException(this.message);

  @override
  String toString() => message;
}

class ShareService {
  Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (_) {
      throw ShareException('No se pudo abrir el selector de compartir.');
    }
  }
}
