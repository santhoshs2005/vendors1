import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //FUNCTION  TO STORE IMAGE IN FIREBASE

  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('storeimage').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  //FUNCTION TO STORE IMAGE IN FIREBASE STORAGE ENDS HERE

  //FUNCTION TO STORE IMAGE

  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No image selected');
    }
  }

  //FUNCTION TO STORE IMAGE END HERE

  //FUNCTIONS TO SAVE VENDOR DATA

  Future<String> RegisterVendor(
    String BussinessName,
    String Email,
    String PhoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxRegister,
    String taxnumber,
    Uint8List? image,
  ) async {
    String res = 'some error occured ';

    try {
      String storeImage = await _uploadVendorImageToStorage(image);
      // SAVE DATA TO CLOUD FIRESTORE

      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'bussinessName': BussinessName,
        'email': Email,
        'PhoneNumber': PhoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'taxRegister': taxRegister,
        'taxnumber': taxnumber,
        'storeImage': storeImage,
        'approved': false,
        'vendorId': _auth.currentUser!.uid,
      });
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //FUNCTIONS TO SAVE  VENDORS DATA ENDS HERE
}
