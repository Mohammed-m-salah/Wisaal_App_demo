import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showChatSnackbar({
  required String senderName,
  required String messageTitle,
}) {
  Get.snackbar(
    senderName,
    messageTitle,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.black.withOpacity(0.8),
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(12),
    borderRadius: 10,
  );
}
