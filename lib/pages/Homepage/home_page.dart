import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wissal_app/controller/contact_controller/contact_controller.dart';
import 'package:wissal_app/controller/image_picker/image_picker.dart';
import 'package:wissal_app/pages/Homepage/widgets/call_list_page.dart';
import 'package:wissal_app/pages/Homepage/widgets/chat_list_page.dart';
import 'package:wissal_app/pages/Homepage/widgets/groups_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ImagePickerController imagepickercontroller =
        Get.put(ImagePickerController());
    ContactController contactcontroller = Get.put(ContactController());
    return DefaultTabController(
      length: 3, // عدد التبويبات
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Get.toNamed('contactpage');
            },
            child: Icon(
              Icons.add,
            )),
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          leading: IconButton(
            onPressed: () {
              // Open drawer or menu
            },
            icon: SvgPicture.asset(
              'assets/icons/Vector.svg',
              width: 30,
              height: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            'Wesaal App',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                contactcontroller.getChatRoomList();
              },
              icon: const Icon(Icons.search, color: Colors.white),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                Get.toNamed('/profilepage');
              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Groups'),
              Tab(text: 'Calls'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            //chats
            Center(
              child: ChatListPage(),
            ),
            //groups
            Center(child: GroupListPage()),
            //calls
            Center(child: CallListPage()),
          ],
        ),
      ),
    );
  }
}
