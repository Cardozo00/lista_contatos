import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lista_contato/myapp.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '/Users/brunocardozo/lista_contato/.env');
  await path_provider.getApplicationCacheDirectory();
  runApp(const MyApp());
}
