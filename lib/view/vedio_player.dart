import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VedioPlayer_live extends StatefulWidget {
  const VedioPlayer_live({super.key});

  @override
  State<VedioPlayer_live> createState() => _VedioPlayer_liveState();
}

class _VedioPlayer_liveState extends State<VedioPlayer_live> {
  // URL of the YouTube video
  final vedioURL = "https://youtu.be/4VQdzTv8E-g?si=MBbe-JOsU8Wix2rb";

  // Controller to manage the YouTube video
  late YoutubePlayerController playerController;

  // Track play/pause state
  bool isPlaying = false;

  @override
  void initState() {
    final vedioId = YoutubePlayer.convertUrlToId(vedioURL);
    // Initialize the YouTube player controller with video ID
    playerController = YoutubePlayerController(
      initialVideoId: vedioId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false, // Do not autoplay the video
      ),
    );
    super.initState();
  }

  // Method to seek forward 10 seconds
  void seekforward() {
    final currentPosition = playerController.value.position;
    final duration = playerController.value.metaData.duration;
    if (currentPosition.inSeconds + 10 < duration.inSeconds) {
      playerController.seekTo(currentPosition + const Duration(seconds: 10));
    }
  }

  // Method to seek backward 10 seconds
  void seekbackward() {
    final currentPosition = playerController.value.position;
    if (currentPosition.inSeconds - 10 > 0) {
      playerController.seekTo(currentPosition - const Duration(seconds: 10));
    }
  }

  void togglePlayPause() {
    setState(() {
      if (playerController.value.isPlaying) {
        playerController.pause();
        isPlaying = false;
      } else {
        playerController.play();
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          "Live Video",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            YoutubePlayer(controller: playerController),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: seekbackward,
                        icon: Icon(
                          Icons.replay_10,
                          size: 40,
                          color: Colors.redAccent,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.redAccent,
                        child: IconButton(
                          onPressed: togglePlayPause,
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: isPlaying ? Colors.white : Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: seekforward,
                        icon: Icon(
                          Icons.forward_10,
                          size: 40,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Your Live vedio here",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
