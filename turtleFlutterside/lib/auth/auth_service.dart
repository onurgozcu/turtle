import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turtle/auth/signup_page.dart';
import 'package:turtle/main.dart';
import 'package:turtle/map_page.dart';

import '../api_helper.dart';
import '../fade_route.dart';
import 'code_page.dart';

class AuthService {
  static login(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Please fill the phone number area first.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(navigatorKey.currentContext!);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
      return;
    }
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.transparent,
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        await _firebaseAuth
            .signInWithCredential(phoneAuthCredential)
            .then((result) async {
          await ApiHelper.getUserByFirebaseId().then((value) {
            if (value.isEmpty) {
              Navigator.pop(navigatorKey.currentContext!);
              Navigator.push(
                navigatorKey.currentContext!,
                FadeRoute(
                  page: const SignUpPage(),
                ),
              );
            } else {
              Navigator.pop(navigatorKey.currentContext!);
              Navigator.push(
                navigatorKey.currentContext!,
                FadeRoute(
                  page: const MapPage(),
                ),
              );
            }
          });
        }).catchError((e) async {
          if (e.code == 'too-many-requests') {
            showDialog(
                context: navigatorKey.currentContext!,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Too many requests. Please try again later.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(navigatorKey.currentContext!);
                          Navigator.pop(navigatorKey.currentContext!);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                });
          }
        });
      },
      verificationFailed: (FirebaseAuthException firebaseAuthException) {
        if (firebaseAuthException.code == 'too-many-requests') {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Too many requests. Please try again later.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(navigatorKey.currentContext!);
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
        } else if (firebaseAuthException.code == 'invalid-phone-number') {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Please enter a valid phone number.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(navigatorKey.currentContext!);
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
        }
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        Navigator.pop(navigatorKey.currentContext!);
        Navigator.push(
          navigatorKey.currentContext!,
          FadeRoute(
            page: CodePage(
              phoneNumber: phoneNumber,
              isLogIn: true,
              verificationID: verificationId,
              onTap: (String code) {
                verifySmsCode(code, verificationId);
              },
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static verifySmsCode(String code, String verificationId) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.transparent,
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth
        .signInWithCredential(
      PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code),
    )
        .then((credential) async {
      await ApiHelper.getUserByFirebaseId().then((value) {
        if (value.isEmpty) {
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.push(
            navigatorKey.currentContext!,
            FadeRoute(
              page: const SignUpPage(),
            ),
          );
        } else {
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.push(
            navigatorKey.currentContext!,
            FadeRoute(
              page: const MapPage(),
            ),
          );
        }
      });
    }).catchError((Object e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-phone-number' ||
            e.code == 'missing-phone-number') {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                      'Please be sure enter the Phone number correctly.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(navigatorKey.currentContext!);
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
        } else if (e.code == 'invalid-verification-code' ||
            e.code == 'missing-verification-code' ||
            e.code == 'invalid-verification-ıd') {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                      'Please be sure enter the SMS code correctly.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(navigatorKey.currentContext!);
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
        } else if (e.code == 'session-expired') {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Please try again.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(navigatorKey.currentContext!);
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
        } else if (e.code == 'too-many-requests') {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Too many requests. Please try again later.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(navigatorKey.currentContext!);
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
        }
      }
    });
  }

  static logOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.push(
        navigatorKey.currentContext!,
        FadeRoute(
          page: const WelcomePage(),
        ),
      );
    });
  }
}
