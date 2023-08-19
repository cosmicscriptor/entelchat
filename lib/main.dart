import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDxtiKVjwKEfiFk2K5mLBlE_coKd-9AV2I",
      authDomain: "entelcat.firebaseapp.com",
      projectId: "entelcat",
      storageBucket: "entelcat.appspot.com",
      messagingSenderId: "937162497052",
      appId: "1:937162497052:web:36020d7c09c70964b4d3d9",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EntelCat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Jost',
        colorScheme: lightColorScheme,
        appBarTheme: AppBarTheme(
          color: lightColorScheme.primary,
        ),
      ),
      home: IntroPage(),
    );
  }
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF93000A),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFF3BF48),
  onPrimaryContainer: Color(0xFF261900),
  secondary: Color(0xFFFFFBFF),
  onSecondary: Color(0xFFE6E971),
  secondaryContainer: Color(0xFF00363E),
  onSecondaryContainer: Color(0xFF410003),
  tertiary: Color(0xFF51D7EF),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF8AF8C5),
  onTertiaryContainer: Color(0xFF002114),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF311300),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF311300),
  surfaceVariant: Color(0xFFEDE1CF),
  onSurfaceVariant: Color(0xFF4D4639),
  outline: Color(0xFF7F7667),
  onInverseSurface: Color(0xFFFFEDE4),
  inverseSurface: Color(0xFF512400),
  inversePrimary: Color(0xFFF3BF48),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF795900),
  outlineVariant: Color(0xFFD0C5B4),
  scrim: Color(0xFF000000),
);
