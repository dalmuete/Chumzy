import 'package:chumzy/app.dart';
import 'package:chumzy/data/providers/flashcard_provider.dart';
import 'package:chumzy/data/providers/message_bot_provider.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/data/providers/theme_provider.dart';
import 'package:chumzy/data/providers/topic_provider.dart';
import 'package:chumzy/core/firebase/firebase_options.dart';
import 'package:chumzy/features/01-auth/controller/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SubjectProvider()),
        ChangeNotifierProvider(create: (context) => TopicProvider()),
        ChangeNotifierProvider(create: (context) => MessageBotProvider()),
        ChangeNotifierProvider(create: (context) => CardProvider()),
      ],
      child: ChumzyApp(),
    ),
  );
}
