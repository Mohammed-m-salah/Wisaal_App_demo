import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wissal_app/controller/image_picker/image_picker.dart';
import 'package:wissal_app/controller/profile_controller/profile_controller.dart';
import 'package:wissal_app/controller/profile_controller/update_profile_controller.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  // Register or retrieve your controllers safely
  final ProfileController profileController =
      Get.put(ProfileController(), permanent: true);
  final UpdateProfileController updateProfileController =
      Get.put(UpdateProfileController(), permanent: true);
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController(), permanent: true);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  final RxBool isEdit = false.obs;
  final RxString imagePath = "".obs;

  @override
  void initState() {
    super.initState();
    _loadAndInitControllers();
  }

  Future<void> _loadAndInitControllers() async {
    await profileController.getUserDetails();
    final user = profileController.currentUser.value;

    if (user != null) {
      nameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phonenumber ?? '';
      aboutController.text = user.about ?? '';
      imagePath.value = user.profileimage?.isNotEmpty == true
          ? user.profileimage!
          : "https://i.ibb.co/V04vrTtV/blank-profile-picture-973460-1280.png";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(() {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Profile Image
              InkWell(
                onTap: isEdit.value
                    ? () async {
                        final picked =
                            await imagePickerController.pickImageFromGallery();
                        if (picked.isNotEmpty) {
                          imagePath.value = picked;
                        }
                      }
                    : null,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: imagePath.value.startsWith("http")
                        ? Image.network(
                            imagePath.value,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.error),
                          )
                        : File(imagePath.value).existsSync()
                            ? Image.file(
                                File(imagePath.value),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.error),
                              )
                            : const Icon(Icons.error),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Input Fields
              _buildTextField(
                controller: nameController,
                label: "Name",
                icon: Icons.account_circle_sharp,
                isEdit: isEdit.value,
                context: context,
              ),
              _buildTextField(
                controller: aboutController,
                label: "About",
                icon: Icons.info,
                isEdit: isEdit.value,
                context: context,
              ),
              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.alternate_email_outlined,
                isEdit: false,
                context: context,
              ),
              _buildTextField(
                controller: phoneController,
                label: "Phone",
                icon: Icons.call,
                isEdit: isEdit.value,
                context: context,
              ),

              const SizedBox(height: 10),

              profileController.isloading.value
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 120,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (isEdit.value) {
                              await updateProfileController.updateProfile(
                                imagePath.value,
                                nameController.text,
                                aboutController.text,
                                phoneController.text,
                              );
                            }
                            isEdit.toggle();
                          },
                          icon: Icon(isEdit.value ? Icons.save : Icons.edit),
                          label: Text(isEdit.value ? 'Save' : 'Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(45),
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 10),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isEdit,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        enabled: isEdit,
        controller: controller,
        style: TextStyle(
          color: isEdit ? Colors.white : Colors.grey.shade500,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          labelText: label,
          filled: true,
          fillColor: isEdit
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.primaryContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
