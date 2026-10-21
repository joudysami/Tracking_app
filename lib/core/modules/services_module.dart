import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ServicesModule {
  @lazySingleton
  FlutterSecureStorage provideFlutterSecureStorage() =>
      const FlutterSecureStorage();

  @lazySingleton
  ImagePicker provideImagePicker() => ImagePicker();
}
