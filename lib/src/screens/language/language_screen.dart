import 'package:ads_tracking_plugin/ads_manager.dart';
import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/base_widget.dart';
import 'package:flutter_template/core/config/ad_config.dart';
import 'package:flutter_template/core/constants/app_spacing.dart';
import 'package:flutter_template/core/enums/language_enum.dart';
import 'package:flutter_template/core/extensions/language_ext.dart';
import 'package:flutter_template/core/navigation/navigation_manager.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/utils/locator_support.dart';
import 'package:flutter_template/src/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_template/src/view_models/app_view_model.dart';
import 'package:flutter_template/src/view_models/language_view_model.dart';
import 'package:flutter_template/src/widgets/app_bar/app_app_bar.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends BaseStatefulWidget {
  final bool fromSetting;

  const LanguageScreen({super.key, this.fromSetting = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends BaseState<LanguageScreen> {
  bool _showDoneButton = false;
  bool _isShowLanguageClick = false;

  @override
  bool get keepAlive => true;

  @override
  void onInitSync() {
    // TODO: init không cần context (controller/di/stream...)
    if (!widget.fromSetting) {
      _preloadOnboardingAds();
    }
  }

  @override
  void onReady() {
    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)
  }

  void _preloadOnboardingAds() {
    try {
      Future.wait([
        AdsManager.instance.preload(name: AdName.nativeOnboardingPage1Ad),
        AdsManager.instance.preload(name: AdName.nativeOnboardingPage4Ad),
      ]);
    } catch (e) {
      debugPrint("preload native onboard error: $e");
    }
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Language',
        actions: [
          if(_showDoneButton)
            InkWell(
              onTap: () {
                context.read<LanguageViewModel>().saveLanguage();
                NavigationManager.instance.navigateTo(OnboardingScreen());
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  context.locale.done,
                  style: AppTypography.subheadline,
                ),
              ),
            ),
        ],
      ),
      body: Consumer<LanguageViewModel>(
        builder: (context, value, child) {
          return ListView.separated(
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final language = LanguageEnum.values[index];
              return Material(
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  highlightColor: value.selectedLanguage == language
                      ? AppColors.primaryColor.withValues(alpha: 0.2)
                      : Colors.grey.shade200,
                  onTap: () {
                    context.read<LanguageViewModel>().selectLanguage(language);
                    if(!_isShowLanguageClick){
                      print("[LanguageScreen] - show language click ad");
                      setState(() {
                        _isShowLanguageClick = true;
                      });
                    }
                    setState(() {
                      _showDoneButton = true;
                    });
                  },
                  child: Ink(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: value.selectedLanguage == language
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: value.selectedLanguage == language
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      spacing: 12,
                      children: [
                        language.getFlag,
                        Text(
                          language.displayName,
                          style: AppTypography.callout,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => AppSpacing.h10,
            itemCount: LanguageEnum.values.length,
          );
        },
      ),
      bottomNavigationBar: Consumer<AppViewModel>(builder: (context, value, child) {
        final adName = _isShowLanguageClick
            ? AdName.nativeLanguageClickAd
            : AdName.nativeLanguageAd;
        return NativeAdWidget(
          key: ValueKey(adName),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom + 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(11)),
            border: Border.all(color: Colors.grey.shade300),
          ),
          adName: adName,
          onAdLoaded: (value) {
            debugPrint("LanguageScreen: $adName");
          },
          disabled: !value.shouldShowAds,
        );
      },),
    );
  }
}
