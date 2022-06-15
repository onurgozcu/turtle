import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:turtle/api_helper.dart';
import 'package:turtle/constants.dart';
import 'package:turtle/fade_route.dart';
import 'package:turtle/main.dart';
import 'package:turtle/map_page.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key, required this.userId}) : super(key: key);
  final int userId;

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late QRViewController controller;
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          SafeArea(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 144.0),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/camerasquare.png',
                scale: 3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/dialogbubble.png',
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 14.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Text(
                            'If you have a problem with the QR code, you can enter the code on the door.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: FittedBox(
                    child: RawMaterialButton(
                      fillColor: const Color(0x8800DA74),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Text(
                          "Enter Code",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        controller.pauseCamera();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      setState(() {
                                        _codeController.clear();
                                        controller.resumeCamera();
                                      });
                                      Navigator.pop(context);
                                      return true;
                                    },
                                    child: AlertDialog(
                                      backgroundColor: kDarkBlue,
                                      title: const Text(
                                        'Enter Code',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      content: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          TextField(
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            autofocus: true,
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            controller: _codeController,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 32.0),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (_codeController.text !=
                                                    "") {
                                                  String rentType = "";
                                                  showModalBottomSheet(
                                                    context: navigatorKey
                                                        .currentContext!,
                                                    builder: (BuildContext bc) {
                                                      return Wrap(
                                                        children: <Widget>[
                                                          ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .arrow_right),
                                                            title: const Text(
                                                                'Rent daily'),
                                                            onTap: () async {
                                                              rentType =
                                                                  "daily";
                                                              if (!_codeController
                                                                      .text
                                                                      .contains(
                                                                          "-") &&
                                                                  int.tryParse(_codeController
                                                                          .text
                                                                          .split(
                                                                              "-")
                                                                          .first) ==
                                                                      null) {
                                                                showDialog(
                                                                    context:
                                                                        navigatorKey
                                                                            .currentContext!,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Please be sure entering the code correctly.'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              controller.resumeCamera();
                                                                              Navigator.pop(navigatorKey.currentContext!);

                                                                              Navigator.pop(navigatorKey.currentContext!);
                                                                            },
                                                                            child:
                                                                                const Text('Ok'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                              } else {
                                                                ApiHelper.rentHouse(
                                                                        userId: widget
                                                                            .userId,
                                                                        houseId: int.parse(_codeController
                                                                            .text
                                                                            .split(
                                                                                "-")
                                                                            .first),
                                                                        rentType:
                                                                            rentType)
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.pop(
                                                                      navigatorKey
                                                                          .currentContext!);
                                                                  Navigator.pop(
                                                                      navigatorKey
                                                                          .currentContext!);
                                                                  if (value) {
                                                                    Navigator
                                                                        .pushReplacement(
                                                                      context,
                                                                      FadeRoute(
                                                                        page:
                                                                            const MapPage(),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    showDialog(
                                                                        context:
                                                                            navigatorKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text('Please be sure entering the code correctly.'),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  controller.resumeCamera();

                                                                                  Navigator.pop(navigatorKey.currentContext!);
                                                                                },
                                                                                child: const Text('Ok'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                  }
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: const Icon(
                                                              Icons.arrow_right,
                                                            ),
                                                            title: const Text(
                                                                'Rent monthly'),
                                                            onTap: () async {
                                                              rentType =
                                                                  "monthly";
                                                              if (!_codeController
                                                                      .text
                                                                      .contains(
                                                                          "-") &&
                                                                  int.tryParse(_codeController
                                                                          .text
                                                                          .split(
                                                                              "-")
                                                                          .first) ==
                                                                      null) {
                                                                showDialog(
                                                                    context:
                                                                        navigatorKey
                                                                            .currentContext!,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Please be sure entering the code correctly.'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              controller.resumeCamera();

                                                                              Navigator.pop(navigatorKey.currentContext!);
                                                                              Navigator.pop(navigatorKey.currentContext!);
                                                                            },
                                                                            child:
                                                                                const Text('Ok'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                              } else {
                                                                ApiHelper.rentHouse(
                                                                        userId: widget
                                                                            .userId,
                                                                        houseId: int.parse(_codeController
                                                                            .text
                                                                            .split(
                                                                                "-")
                                                                            .first),
                                                                        rentType:
                                                                            rentType)
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.pop(
                                                                      navigatorKey
                                                                          .currentContext!);
                                                                  Navigator.pop(
                                                                      navigatorKey
                                                                          .currentContext!);
                                                                  if (value) {
                                                                    Navigator
                                                                        .pushReplacement(
                                                                      context,
                                                                      FadeRoute(
                                                                        page:
                                                                            const MapPage(),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    showDialog(
                                                                        context:
                                                                            navigatorKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text('Please be sure entering the code correctly.'),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  controller.resumeCamera();

                                                                                  Navigator.pop(navigatorKey.currentContext!);
                                                                                },
                                                                                child: const Text('Ok'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                  }
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Okay',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) async {
      this.controller.pauseCamera();

      if (result == scanData) {
        this.controller.resumeCamera();
      } else {
        result = scanData;
        if (scanData.code != null) {
          String rentType = "";
          showModalBottomSheet(
            context: navigatorKey.currentContext!,
            builder: (BuildContext bc) {
              return Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.arrow_right),
                    title: const Text('Rent daily'),
                    onTap: () async {
                      rentType = "daily";
                      if (!scanData.code!.contains("-") &&
                          int.tryParse(scanData.code!.split("-").first) ==
                              null) {
                        showDialog(
                            context: navigatorKey.currentContext!,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                    'Please be sure scanning the code correctly.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      controller.resumeCamera();
                                      Navigator.pop(
                                          navigatorKey.currentContext!);
                                      Navigator.pop(
                                          navigatorKey.currentContext!);
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            });
                      } else {
                        ApiHelper.rentHouse(
                                userId: widget.userId,
                                houseId:
                                    int.parse(scanData.code!.split("-").first),
                                rentType: rentType)
                            .then((value) {
                          if (value) {
                            Navigator.pop(navigatorKey.currentContext!);
                            Navigator.pushReplacement(
                              context,
                              FadeRoute(
                                page: const MapPage(),
                              ),
                            );
                          } else {
                            showDialog(
                                context: navigatorKey.currentContext!,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Please be sure scanning the code correctly.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          controller.resumeCamera();
                                          Navigator.pop(
                                              navigatorKey.currentContext!);
                                          Navigator.pop(
                                              navigatorKey.currentContext!);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.arrow_right),
                    title: const Text('Rent monthly'),
                    onTap: () async {
                      rentType = "monthly";
                      if (!scanData.code!.contains("-") &&
                          int.tryParse(scanData.code!.split("-").first) ==
                              null) {
                        showDialog(
                            context: navigatorKey.currentContext!,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                    'Please be sure scanning the code correctly.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      controller.resumeCamera();
                                      Navigator.pop(
                                          navigatorKey.currentContext!);
                                      Navigator.pop(
                                          navigatorKey.currentContext!);
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            });
                      } else {
                        ApiHelper.rentHouse(
                                userId: widget.userId,
                                houseId:
                                    int.parse(scanData.code!.split("-").first),
                                rentType: rentType)
                            .then((value) {
                          if (value) {
                            Navigator.pop(navigatorKey.currentContext!);

                            Navigator.pushReplacement(
                              context,
                              FadeRoute(
                                page: const MapPage(),
                              ),
                            );
                          } else {
                            showDialog(
                                context: navigatorKey.currentContext!,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Please be sure scanning the code correctly.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          controller.resumeCamera();
                                          Navigator.pop(
                                              navigatorKey.currentContext!);

                                          Navigator.pop(
                                              navigatorKey.currentContext!);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      }
                    },
                  ),
                ],
              );
            },
          );
        } else {
          this.controller.resumeCamera();
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
