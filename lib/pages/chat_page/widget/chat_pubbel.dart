import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBubbel extends StatelessWidget {
  final String message;
  final bool isComming;
  final Color iscolor;
  final String time;
  final String status;
  final String imgUrl;
  final VoidCallback? onDelete;

  const ChatBubbel({
    super.key,
    required this.message,
    required this.isComming,
    required this.iscolor,
    required this.time,
    required this.status,
    required this.imgUrl,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isComming
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.primary;

    final textColor = isComming ? Colors.white : Colors.white;
    final hasImage = imgUrl.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Column(
        crossAxisAlignment:
            isComming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPress: onDelete,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isComming ? 0 : 12),
                  bottomRight: Radius.circular(isComming ? 12 : 0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imgUrl,
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
                  if (hasImage) const SizedBox(height: 8),
                  if (message.trim().isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(color: textColor),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment:
                isComming ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (!isComming) ...[
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
