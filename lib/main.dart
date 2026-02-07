import 'package:glowguide/core/layouts/auth_layout.dart';
import 'package:glowguide/core/services/service_locator.dart';
import 'package:glowguide/core/themes/app_theme.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glowguide/features/clinics/presentation/cubit/clinics_cubit.dart';
import 'package:glowguide/features/favorites/data/models/clinic_hive_model.dart';
import 'package:glowguide/features/locations/presentation/cubit/locations_cubit.dart';
import 'package:glowguide/features/offers/presentation/cubit/offers_cubit.dart';
import 'package:glowguide/features/password/presentation/cubit/password_cubit.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_clinic_i_d_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  await Hive.initFlutter();

  Hive.registerAdapter(ClinicHiveModelAdapter());
  await Hive.openBox<ClinicHiveModel>('favoriteClinics');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ClinicsCubit()..getAllClinics()),
        BlocProvider(
          create: (context) => AccountDetailsCubit()..fetchAccountDetails(),
        ),
        BlocProvider(create: (context) => ReviewsCubit()..getAllReviews()),
        BlocProvider(create: (context) => ReviewsClinicIDCubit()),
        BlocProvider(create: (context) => OffersCubit()..getAllOfferss()),
        BlocProvider(create: (context) => LocationsCubit()..getAllLocations()),
        BlocProvider(create: (context) => PasswordCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final CustomScaffoldMessenger _scaffoldMessenger = CustomScaffoldMessenger();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'glowguide',
          theme: appTheme,
          scaffoldMessengerKey: _scaffoldMessenger.messengerKey,
          home: child,
        );
      },
      child: const AuthLayout(),
    );
  }
}
