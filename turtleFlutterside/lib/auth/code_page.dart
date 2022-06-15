import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../fade_route.dart';
import 'login_page.dart';
import 'signup_page.dart';

class CodePage extends StatefulWidget {
  final String phoneNumber;
  final bool isLogIn;
  final String verificationID;
  final void Function(String code) onTap;
  const CodePage({
    Key? key,
    required this.phoneNumber,
    required this.isLogIn,
    required this.verificationID,
    required this.onTap,
  }) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/fourhBg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 36.0, top: 18.0),
                            child: Text(
                              "Kodu Girin",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                height: 1.1,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 36.0, top: 18.0),
                            child: Image.asset(
                              "assets/images/codeDraw.png",
                              width: 140.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEBF4F7),
                              ),
                              text: widget.phoneNumber,
                            ),
                            const TextSpan(
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFEBF4F7),
                              ),
                              text:
                                  " numaralı telefona\n6 haneli kod gönderildi.",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      SizedBox(
                        width: 230.0,
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: "123456",
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                              fontWeight: FontWeight.w500,
                              fontSize: 24.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 12.0,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        width: 230.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(const Size(40, 40)),
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                            elevation: MaterialStateProperty.all(0),
                            overlayColor: MaterialStateProperty.all(
                                kPink.withOpacity(0.3)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Onayla",
                                  style: TextStyle(
                                    color: kPink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            widget.onTap(_codeController.text);
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFEBF4F7),
                              ),
                              text: "Kod gelmedi mi? ",
                            ),
                            TextSpan(
                              style: const TextStyle(
                                color: Color(0xFFEBF4F7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              text: "Tekrar İsteyin",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: widget.isLogIn
                                          ? const LogInPage()
                                          : const SignUpPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
