import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glowguide/features/profile/presentation/cubit/account_details_cubit.dart';
import 'package:glowguide/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'features/clinics/presentation/cubit/clinics_cubit.dart';
import 'features/offers/presentation/cubit/offers_cubit.dart';
import 'features/locations/presentation/cubit/locations_cubit.dart';
import 'core/layouts/auth_layout.dart';

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();

    /// 🔑 هنا الحل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicsCubit>().getAllClinics();
      context.read<OffersCubit>().getAllOfferss();
      context.read<LocationsCubit>().getAllLocations();
      context.read<AccountDetailsCubit>().fetchAccountDetails();
      context.read<ReviewsCubit>().getAllReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AuthLayout();
  }
}
