import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class AudioSound {
  static AudioPlayer player = AudioPlayer();
  static int type = 0;
  static List<Duration> delays = [
    const Duration(milliseconds: 4000), // 1.5 seconds
    const Duration(seconds: 1500),         // 1 second
    const Duration(milliseconds: 1000)   // 0.7 seconds
  ];
  static Timer? delayTimer; // Timer to change delay types
  static Timer? afterType; // Timer to change delay types
  static int counter = 0;
  static Future<void> loadAudio() async {
    player = AudioPlayer();
    _startTimer();
  }

  static void changeType(){
     afterType = Timer.periodic(const Duration(seconds: 10), (timer) async{
      type = type+1;
      _restartAudioTimer();
    });
  }

  static void _startTimer() async{
    delayTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await player.play(AssetSource('sound/bip.mp3'));
    });  
  }

  static Future<void> stopAudio() async {
    await player.stop(); // Stop audio playback
  }

  static void _restartAudioTimer() {
    delayTimer?.cancel(); // Cancel the existing timer
    _startTimer(); // Start a new timer with the updated delay
  }

  static Future<void> dispose() async {
    delayTimer?.cancel(); // Cancel the timer
    await player.dispose(); // Dispose of the audio player
  }
}
