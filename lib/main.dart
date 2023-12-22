import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
late final InputImage inputImage;
void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ImagePicker imagePicker;
  File? _image;
  String result = 'results will be shown here';
  dynamic barcodeScanner;
  //TODO declare scanner

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
     barcodeScanner = BarcodeScanner(formats: formats);
    //TODO initialize scanner

  }

  @override
  void dispose() {
    super.dispose();

  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doBarcodeScanning();
    });
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doBarcodeScanning();
      });
    }
  }

  //TODO barcode scanning code here
  doBarcodeScanning() async {

    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      final Rect boundingBox = barcode.boundingBox;
      final String? displayValue = barcode.displayValue;
      final String? rawValue = barcode.rawValue;

      // See API reference for complete list of supported types
      switch (type) {
        case BarcodeType.wifi:
          BarcodeWifi? barcodeWifi = barcode.value as BarcodeWifi;
          result="wifi: "+barcodeWifi.password!;
          break;
        case BarcodeType.url:
          BarcodeUrl? barcodeUrl = barcode.value as BarcodeUrl;
          result="Url: "+barcodeUrl.url!+"\n"+"title"+barcodeUrl.title! ;
          break;
        case BarcodeType.unknown:
          result="unknown the barcode";
          // TODO: Handle this case.
          break;
        case BarcodeType.contactInfo:
          // TODO: Handle this case.
        BarcodeContactInfo barcodeContactInfo=barcode.value as BarcodeContactInfo;
        result="contact address: "+barcodeContactInfo.addresses.toString()!+"\n"+"contact email"+barcodeContactInfo.emails.toString()!;
          break;
        case BarcodeType.email:
          BarcodeEmail barcodeEmail=barcode.value as BarcodeEmail;
          result="Email Address:"+barcodeEmail.address!;
          // TODO: Handle this case.
          break;
        case BarcodeType.phone:
          BarcodePhone barcodePhone=barcode.value as BarcodePhone;
          result="phone: "+barcodePhone.number!.toString();
          break;
        case BarcodeType.sms:
          BarcodeSMS barcodePhone=barcode.value as BarcodeSMS;
          result="Message: "+barcodePhone.message!.toString();
          break;
        case BarcodeType.text:
          BarcodeAddress barcodePhone=barcode.value as BarcodeAddress;
          result="text: "+barcodePhone!.addressLines.toString();
          break;
        case BarcodeType.geoCoordinates:
          BarcodeGeoPoint barcodePhone=barcode.value as BarcodeGeoPoint;
          result="latitude: "+barcodePhone.latitude!.toString();
          break;
        case BarcodeType.calendarEvent:
          BarcodeCalenderEvent barcodePhone=barcode.value as BarcodeCalenderEvent;
          result="description: "+barcodePhone.description!.toString();
          break;
        case BarcodeType.driverLicense:
          BarcodeDriverLicense barcodePhone=barcode.value as BarcodeDriverLicense;
          result="driver license expiry date: "+barcodePhone.expiryDate!.toString();
          break;
      }
      setState(() {
        result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          body:  SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: 100,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Stack(children: <Widget>[
                    Stack(children: <Widget>[
                      Center(
                        child: Image.asset(
                          'images/frame.jpg',
                          height: 350,
                          width: 350,
                        ),
                      ),
                    ]),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent),
                        onPressed: _imgFromGallery,
                        onLongPress: _imgFromCamera,
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: _image != null
                              ? Image.file(
                            _image!,
                            width: 325,
                            height: 325,
                            fit: BoxFit.fill,
                          )
                              : Container(
                            width: 340,
                            height: 330,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
