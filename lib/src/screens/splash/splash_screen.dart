import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/base_widget.dart';
import 'package:flutter_template/core/constants/app_spacing.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/utils/app_size.dart';
import 'package:flutter_template/core/utils/locator_support.dart';
import 'package:flutter_template/src/widgets/scaffold/app_scaffold.dart';

class SplashScreen extends BaseStatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {
  @override
  bool get keepAlive => true;

  @override
  void onInitSync() {
    // TODO: init không cần context (controller/di/stream...)
  }

  @override
  void onReady() {
    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)
  }

  @override
  Widget buildView(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              AppSpacing.h56,
              AppSpacing.h56,
              AppSpacing.h20,
              Container(
                height: AppSize.instance.width * 0.29,
                width: AppSize.instance.width * 0.29,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(17),
                ),
                // child: Assets.images.splash.image(),
              ),
              AppSpacing.h32,
              Text(
                "App name",
                style: AppTypography.caption1.copyWith(
                  // color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              CircularProgressIndicator.adaptive(),
              Text(
                context.locale.just_waiting_a_few_seconds,
                style: AppTypography.caption1.copyWith(
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}