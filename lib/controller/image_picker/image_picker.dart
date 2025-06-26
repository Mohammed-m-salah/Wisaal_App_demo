import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  final ImagePicker picker = ImagePicker();
  bool _isPicking = false;

  Future<String> pickImageFromGallery() async {
    if (_isPicking) return "";
    _isPicking = true;

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path ?? "";
    } catch (e) {
      print("Error picking image from gallery: $e");
      return "";
    } finally {
      _isPicking = false;
    }
  }

  Future<String> pickImageFromCamera() async {
    if (_isPicking) return "";
    _isPicking = true;

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      return image?.path ?? "";
    } catch (e) {
      print("Error picking image from camera: $e");
      return "";
    } finally {
      _isPicking = false;
    }
  }
}
