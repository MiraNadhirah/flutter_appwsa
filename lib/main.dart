import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wsa/dashboard.dart';

import 'package:flutter_wsa/registerLogin/first_view.dart';
import 'package:flutter_wsa/registerLogin/sign_up_view.dart';
import 'package:flutter_wsa/services/auth_service.dart';
import 'package:flutter_wsa/services/custom_colors.dart';
import 'package:flutter_wsa/widget/provider_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  var colors = CustomColors(WidgetsBinding.instance.window.platformBrightness);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      colors = CustomColors(WidgetsBinding.instance.window.platformBrightness);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "WSA",
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signUp': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signIn),
          '/home': (BuildContext context) => HomeController(),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Dashboard() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

// Future sendMessage(String message) async {
//   var resp = FirebaseDatabase.instance
//       .reference()
//       .child('Contacts')
//       .orderByChild('name');

//   var data = await resp.once();
//   List<String> number =
//       data.value.values.map((value) => value["number"]).toList().cast<String>();

//   SmsSender smsSender = SmsSender();
//   for (var item in number) {
//     SmsMessage smsMessage = SmsMessage(item, message);

//     smsMessage.onStateChanged.listen((state) {
//       if (state == SmsMessageState.Sent) {
//         print("SMS is sent!");
//       } else if (state == SmsMessageState.Delivered) {
//         print("SMS is delivered!");
//       }
//     });
//     await smsSender.sendSms(smsMessage);
//   }

//   return null;
// }
