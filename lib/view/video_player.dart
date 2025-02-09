import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // Import GetX

class Video_Player extends StatefulWidget {
  final int keyParam; // Rename to keyParam to avoid conflicts

  const Video_Player(this.keyParam, {Key? key}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video_Player> {
  bool _isPlaying = true;
  late final VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Generate URL dynamically using the key parameter
    String videoUrl = "rtmp://3.109.91.102/live/${widget.keyParam}";

    _controller = VlcPlayerController.network(
      videoUrl,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _controller.stopRendererScanning();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
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
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 225,
            child: VlcPlayer(
              aspectRatio: 16 / 9,
              controller: _controller,
              placeholder: const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _togglePlayPause,
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}