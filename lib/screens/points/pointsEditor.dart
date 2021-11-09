import 'package:easy_localization/easy_localization.dart';
import 'package:eckit/services/points_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../validator.dart';

class PointsEditor extends StatefulWidget {
  @override
  _PointsEditorState createState() => _PointsEditorState();
}

class _PointsEditorState extends State<PointsEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController points = new TextEditingController();
  TextEditingController uid = new TextEditingController();
  bool _isCredit = true;
  bool isLoading = false;

//  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode result;
//   QRViewController controller;

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller.resumeCamera();
//     }
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

  var loadingKit = Center(
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SpinKitSquareCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ],
    ),
  );

  save() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      await PointsServices.addPointsToClient(
        uid: uid.text,
        amount: points.text,
        type: _isCredit ? "credit" : "debit",
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: save,
        child: Container(
          child: Center(
            child: isLoading
                ? loadingKit
                : Text(
                    "save".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
          ),
          height: 80.0,
          decoration: BoxDecoration(
            color: const Color(0xff1e272e),
          ),
        ),
      ),
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Image.asset(
            "assets/images/logo.png",
            height: 40,
          )),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "points".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                CustomeTextField(
                  controller: points,
                  validator: Validator.notEmpty,
                  hintTxt: "amount_hint_points".tr(),
                  labelTxt: "amount_label_points".tr(),
                ),

                CustomeTextField(
                  controller: uid,
                  validator: Validator.notEmpty,
                  hintTxt: "uid_hint_points".tr(),
                  labelTxt: "uid_label_points".tr(),
                ),

                SizedBox(
                  height: 10,
                ),

                //   CustomeButton(title: "scan_client_code",icon: FontAwesomeIcons.qrcode,handler: () async {
                //                 String qrResult = await MajaScan.startScan(
                //             title: "قم بتصوير كود العميل",
                //             barColor: Colors.black,
                //             titleColor: Colors.white,
                //             qRCornerColor: Colors.yellow,
                //             qRScannerColor: Colors.yellow,
                //             flashlightEnable: true,
                //             scanAreaScale: 0.8 /// value 0.0 to 1.0
                //         );

                //         setState(() {
                //           uid.text = qrResult;
                //         });
                // },),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    CupertinoSwitch(
                      value: _isCredit,
                      onChanged: (value) {
                        setState(() {
                          _isCredit = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(_isCredit ? "credit".tr() : "debit".tr())
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                //       Expanded(child: QRView(
                //     key: qrKey,
                //     onQRViewCreated: _onQRViewCreated,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomeTextField extends StatelessWidget {
  String hintTxt;
  String labelTxt;
  TextEditingController controller;
  dynamic validator;
  bool obscureTextbool;

  CustomeTextField({this.hintTxt, this.labelTxt, this.controller, this.validator, this.obscureTextbool = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTextbool,
      validator: validator,
      controller: controller,
      decoration: new InputDecoration(
          hintText: hintTxt,
          labelText: labelTxt,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          )),
    );
  }
}
