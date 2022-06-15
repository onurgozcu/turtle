import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle/firebase_options.dart';
import 'package:turtle/map_page.dart';
import 'package:turtle/marker_converter.dart';

import 'api_helper.dart';
import 'auth/login_page.dart';
import 'auth/signup_page.dart';
import 'constants.dart';
import 'fade_route.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MarkerConverter().convertMarker();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/firstBg.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 44.0,
                        right: 44.0,
                        top: 48.0,
                        bottom: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rent Your Dream Eaisly",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
                            child: Image.asset(
                              "assets/images/codeDraw.png",
                              height: 120,
                            ),
                          ),
                          const Text(
                            "Pellentesque nec mattis ipsum, nec finibus odio. In condimentum risus vitae ex elementum consectetur. Aenean cursus tellus augue, at eleifend turpis facilisis nec.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              height: 1.2,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(40, 40)),
                                    backgroundColor: MaterialStateProperty.all(
                                      kPurpleBlue,
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      FadeRoute(
                                        page: const LogInPage(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Rent Now!",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return FutureBuilder<Map>(
                future: ApiHelper.getUserByFirebaseId(),
                builder: (context, userInfoSnapshot) {
                  if (!userInfoSnapshot.hasData) {
                    return const Scaffold(
                      backgroundColor: kDarkBlue,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (userInfoSnapshot.data!.isEmpty) {
                    return const SignUpPage();
                  } else {
                    return const MapPage();
                  }
                },
              );
            }
          }
          return const Scaffold(
            backgroundColor: kDarkBlue,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        });
  }
}
