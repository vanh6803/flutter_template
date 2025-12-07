import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/base_widget.dart';
import 'package:flutter_template/core/config/ad_config.dart';
import 'package:flutter_template/core/constants/app_spacing.dart';
import 'package:flutter_template/core/navigation/navigation_manager.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/utils/app_size.dart';
import 'package:flutter_template/core/utils/locator_support.dart';
import 'package:flutter_template/src/screens/home/home_screen.dart';
import 'package:flutter_template/src/view_models/app_view_model.dart';
import 'package:flutter_template/src/widgets/button/solid_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

extension _OnboadingExtension on int {
  String get title {
    final locale = NavigationManager.instance.context?.locale;
    switch (this) {
      case 0:
        return "Title 1";
      case 1:
        return "Title 2";
      case 2:
        return "Title 3";
      case 3:
        return "Title 4";
      default:
        return "";
    }
  }

  String get description {
    final locale = NavigationManager.instance.context?.locale;
    switch (this) {
      case 0:
        return "Description 1";
      case 1:
        return "Description 2";
      case 2:
        return "Description 3";
      case 3:
        return "Description 4";
      default:
        return "";
    }
  }
}

class OnboardingScreen extends BaseStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends BaseState<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _showApplyLanguageOverlay = true;

  final List<Widget> _pages = [
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  @override
  bool get keepAlive => true;

  @override
  void onInitSync() {
    // TODO: init không cần context (controller/di/stream...)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showApplyLanguageOverlay = false;
        });
      }
    });
  }

  @override
  void onReady() {
    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    context.read<AppViewModel>().setFirstLaunch(false);
    NavigationManager.instance.navigateTo(HomeScreen());
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return page;
              },
            ),
          ),
          AppSpacing.h12,
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.primaryColor,
              dotColor: Colors.grey.shade400,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 2.5,
              spacing: 6,
            ),
          ),
          AppSpacing.h12,
          Text(_currentPage.title, style: AppTypography.title3SemiBold),
          AppSpacing.h6,
          Text(
            _currentPage.description,
            style: AppTypography.callout,
            textAlign: TextAlign.center,
          ),
          AppSpacing.h12,
          SolidButton(
            child: Center(
              child: Text(
                "Next",
                style: AppTypography.body.copyWith(color: Colors.white),
              ),
            ),
            onTap: () {
              if (_currentPage < 3) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else {
                _finishOnboarding(context);
              }
            },
          ),
          AppSpacing.h12,
          Consumer<AppViewModel>(
            builder: (context, value, asyncSnapshot) {
              return Container(
                height: 220,
                decoration: BoxDecoration(
                  border: _currentPage == 0 || _currentPage == 3
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Offstage(
                      offstage: _currentPage != 0,
                      child: NativeAdWidget(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewPadding.bottom + 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(11),
                          ),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        adName: AdName.nativeOnboardingPage1Ad,
                        onAdLoaded: (value) {
                          debugPrint(
                            "LanguageScreen: ${AdName.nativeOnboardingPage1Ad}",
                          );
                        },
                        disabled: !value.shouldShowAds,
                      ),
                    ),
                    Offstage(
                      offstage: _currentPage != 3,
                      child: NativeAdWidget(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewPadding.bottom + 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(11),
                          ),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        adName: AdName.nativeOnboardingPage4Ad,
                        onAdLoaded: (value) {
                          debugPrint(
                            "LanguageScreen: ${AdName.nativeOnboardingPage4Ad}",
                          );
                        },
                        disabled: !value.shouldShowAds,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
