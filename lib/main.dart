import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database_helper.dart';
import 'repository/product_repository.dart';
import 'repository/settings_repository.dart';
import 'repository/survey_repository.dart';
import 'services/camera_service.dart';
import 'services/share_service.dart';
import 'theme/app_theme.dart';
import 'viewmodels/basket_viewmodel.dart';
import 'views/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Capa de datos
        Provider<ProductRepository>(
          create: (_) => ProductRepository(DatabaseHelper.instance),
        ),
        Provider<SettingsRepository>(create: (_) => SettingsRepository()),
        Provider<SurveyRepository>(create: (_) => SurveyRepository()),

        // Servicios del dispositivo
        Provider<CameraService>(create: (_) => CameraService()),
        Provider<ShareService>(create: (_) => ShareService()),

        // ViewModels
        ChangeNotifierProvider<BasketViewModel>(
          create: (context) => BasketViewModel(
            context.read<ProductRepository>(),
            context.read<SettingsRepository>(),
            context.read<CameraService>(),
          )..init(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeView(),
    );
  }
}
