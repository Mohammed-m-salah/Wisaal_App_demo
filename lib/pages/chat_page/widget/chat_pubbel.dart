import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatBubbel extends StatefulWidget {
  final String message;
  final bool isComming;
  final Color iscolor;
  final String time;
  final String status;
  final String imgUrl;
  final String audioUrl;
  final String senderName;
  final VoidCallback? onDelete;

  const ChatBubbel({
    super.key,
    required this.message,
    required this.isComming,
    required this.iscolor,
    required this.time,
    required this.status,
    required this.imgUrl,
    required this.audioUrl,
    required this.senderName,
    this.onDelete,
  });

  @override
  State<ChatBubbel> createState() => _ChatBubbelState();
}

class _ChatBubbelState extends State<ChatBubbel> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  late final StreamSubscription _stateSub;
  late final StreamSubscription _positionSub;
  late final StreamSubscription _durationSub;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _stateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _playerState = state);
      }
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) {
        setState(() => _position = pos);
      }
    });

    _durationSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() => _duration = dur);
      }
    });
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _positionSub.cancel();
    _durationSub.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_playerState == PlayerState.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = widget.isComming
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.primary;

    final textColor = Colors.white;
    final hasImage = widget.imgUrl.trim().isNotEmpty;
    final hasAudio = widget.audioUrl.trim().isNotEmpty;
    final hasText = widget.message.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Column(
        crossAxisAlignment: widget.isComming
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPress: widget.onDelete,
            child: IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                  minWidth: 60,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(widget.isComming ? 0 : 12),
                    bottomRight: Radius.circular(widget.isComming ? 12 : 0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🧑‍🦱 Sender Info Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              widget.isComming ? Colors.blueGrey : Colors.white,
                          child: Text(
                            widget.senderName.trim().isNotEmpty
                                ? widget.senderName.characters.first
                                    .toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: widget.isComming
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.senderName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isComming
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (hasImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.imgUrl,
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text(
                            'Image not found',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    if (hasImage)
                      const SizedBox(
                        height: 8,
                      ),

                    if (hasAudio)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _playerState == PlayerState.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: (_duration.inMilliseconds == 0)
                                      ? 0
                                      : _position.inMilliseconds /
                                          _duration.inMilliseconds,
                                  backgroundColor: Colors.white24,
                                  color: Colors.white,
                                  minHeight: 4,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_position),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      _formatDuration(_duration),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (hasAudio) const SizedBox(height: 8),

                    if (hasText)
                      Text(
                        widget.message,
                        style: TextStyle(color: textColor),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: widget.isComming
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Text(
                widget.time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (!widget.isComming) ...[
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/icons/Vector (2).svg',
                  width: 18,
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
