import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  final ImagePicker picker = ImagePicker();

  Future<String> pickImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path ?? "";
  }

  Future<String> pickImageFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image?.path ?? "";
  }
}
