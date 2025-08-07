import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playNotificationSound() async {
    try {
      await _player.setAsset('assets/sounds/notification.mp3');
      await _player.play();
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }
}
