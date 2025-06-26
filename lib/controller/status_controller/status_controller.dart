import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatusController extends GetxController with WidgetsBindingObserver {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getStatus(true); // عند بدء التطبيق
  }

  /// يتم استدعاؤه عندما تتغير حالة التطبيق (نشط، بالخلفية، مغلق...)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState: $state');
    if (state == AppLifecycleState.resumed) {
      // عاد المستخدم للتطبيق
      getStatus(true);
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // خرج المستخدم أو التطبيق بالخلفية
      getStatus(false);
    }
  }

  Future<void> getStatus(bool status) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('save_users').update({
        'status': status,
      }).eq('id', user.id);
      print(' 😱 Updated status to: $status');
    } catch (e) {
      print('😱 Error updating status: $e');
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    getStatus(false); // عند غلق التطبيق
    super.onClose();
  }
}
