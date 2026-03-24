import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/data/models/esim_model.dart';
import 'package:saily_app/viewmodels/esim_details_viewmodel.dart';
import 'package:saily_app/views/esim_details/widgets/esim_controls_section.dart';
import 'package:saily_app/views/esim_details/widgets/esim_details_header.dart';

/// The main entry point for the eSIM Details feature.
/// Strictly View-only, wrapping logic in a [ChangeNotifierProvider].
class EsimDetailsScreen extends StatelessWidget {
  const EsimDetailsScreen({super.key, required this.esim});

  final ESimModel esim;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EsimDetailsViewModel(esim),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.homeBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              esim.title,
              style: const TextStyle(
                fontFamily: 'Fustat',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: AppColors.textBlack),
                onPressed: () {},
              ),
            ],
          ),
          body: Consumer<EsimDetailsViewModel>(
            builder: (context, vm, _) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    EsimDetailsHeader(vm: vm),
                    const SizedBox(height: 16),
                    EsimControlsSection(vm: vm),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
