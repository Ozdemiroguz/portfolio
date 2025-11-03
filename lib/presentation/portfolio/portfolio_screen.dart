import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../home/cubit/home_cubit.dart';
import '../home/cubit/home_state.dart';
import '../home/home_screen.dart';
import '../shared/widgets/phone_frame_widget.dart';
import '../shared/widgets/app_screen_wrapper_widget.dart';
import '../shared/widgets/folder_overlay_widget.dart';
import '../shared/widgets/language_overlay_widget.dart';
import 'widgets/portfolio_info_panel_widget.dart';

/// Portfolio screen
/// Main screen that displays the portfolio home or app screens
class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  void initState() {
    super.initState();
    // Load home data on init
    context.read<HomeCubit>().loadHomeData(AppStrings.defaultDomain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.backgroundGradient,
            ),
          ),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return _buildLoading();
              }

              if (state is HomeError) {
                return _buildError(state.message);
              }

              if (state is HomeLoaded) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Check for too small screen
                    if (constraints.maxWidth < 320) {
                      return _buildTooSmallScreen();
                    }

                    // Desktop mode with content panel (min 1200px)
                    final showContentPanel = constraints.maxWidth >= 1200;

                    if (showContentPanel) {
                      return _buildDesktopLayout(state);
                    } else {
                      return _buildPhoneOnlyLayout(state, constraints);
                    }
                  },
                );
              }

              return _buildLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppSizes.iconXl,
          ),
          const SizedBox(height: AppSizes.spacingMd),
          Text(
            tr('portfolio.error', namedArgs: {'message': message}),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingLg),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().loadHomeData(AppStrings.defaultDomain);
            },
            child: Text(tr('portfolio.retry')),
          ),
        ],
      ),
    );
  }

  Widget _buildTooSmallScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_android, size: 80, color: AppColors.accent),
            const SizedBox(height: 20),
            Text(
              tr('portfolio.screenTooSmall'),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              tr('portfolio.screenTooSmallDescription'),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(HomeLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Telefon boyutunu ekran genişliğine göre ayarla
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // Telefon genişliğini hesapla - maksimum 450px, minimum 380px
        final phoneWidth = (screenWidth * 0.25).clamp(380.0, 450.0);
        final phoneHeight = phoneWidth * 2; // 2:1 oranı

        // Telefon yüksekliği ekran yüksekliğini aşmasın
        final maxPhoneHeight = screenHeight * 0.85;
        final finalPhoneHeight =
            phoneHeight > maxPhoneHeight ? maxPhoneHeight : phoneHeight;
        final finalPhoneWidth = finalPhoneHeight / 2;

        return Row(
          children: [
            Spacer(),
            // Left side - Phone UI
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.paddingXl,
                  ),
                  child: SizedBox(
                    width: finalPhoneWidth,
                    height: finalPhoneHeight,
                    child: _buildPhoneContent(state, showFrame: true),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.spacingXxl),
            Expanded(
              flex: 1,
              child: PortfolioInfoPanelWidget(
                apps: [...state.homeApps, ...state.bottomApps],
              ),
            ),
            Spacer(),
          ],
        );
      },
    );
  }

  Widget _buildPhoneOnlyLayout(HomeLoaded state, BoxConstraints constraints) {
    // Calculate phone size based on screen size
    final isMobile = constraints.maxWidth < 768;

    if (isMobile) {
      // Mobile: FULL SCREEN - no padding, no center, just fill the screen
      return _buildPhoneContent(state, showFrame: false);
    }

    // Tablet: Larger size with frame
    double phoneWidth = (constraints.maxWidth * 0.6).clamp(400.0, 500.0);
    double phoneHeight = phoneWidth * 2;

    // Maximum height limit
    final maxHeight = constraints.maxHeight * 0.9;
    if (phoneHeight > maxHeight) {
      phoneHeight = maxHeight;
      phoneWidth = phoneHeight / 2;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXl),
        child: SizedBox(
          width: phoneWidth,
          height: phoneHeight,
          child: _buildPhoneContent(state, showFrame: true),
        ),
      ),
    );
  }

  Widget _buildPhoneContent(HomeLoaded state, {required bool showFrame}) {
    // If an app is open, show the app screen
    if (state.openApp != null) {
      final appScreen = PhoneFrameWidget(
        showFrame: showFrame,
        child: AppScreenWrapperWidget(
          app: state.openApp!,
          onBack: () => context.read<HomeCubit>().closeApp(),
        ),
      );

      // Build overlay stack
      final overlays = <Widget>[];
      
      if (state.openFolder != null) {
        overlays.add(
          FolderOverlayWidget(
            folder: state.openFolder!,
            apps: state.folderApps,
            onClose: () => context.read<HomeCubit>().closeFolder(),
            onAppTap: (app) => context.read<HomeCubit>().openApp(app, context),
          ),
        );
      }
      
      if (state.showLanguageOverlay) {
        overlays.add(
          LanguageOverlayWidget(
            onClose: () => context.read<HomeCubit>().closeLanguageOverlay(),
          ),
        );
      }

      if (overlays.isEmpty) {
        return appScreen;
      }

      return Stack(
        children: [
          appScreen,
          ...overlays,
        ],
      );
    }

    // Build the home screen content
    final homeContent = HomeScreen(
      homeApps: state.homeApps,
      bottomApps: state.bottomApps,
      folders: state.folders,
      onAppTap: (app) => context.read<HomeCubit>().openApp(app, context),
      onFolderTap: (folder) {
        context.read<HomeCubit>().openFolder(AppStrings.defaultDomain, folder);
      },
    );

    // Wrap in phone frame
    final phoneFrame = PhoneFrameWidget(
      showFrame: showFrame,
      child: homeContent,
    );

    // Build overlay stack
    final overlays = <Widget>[];
    
    if (state.openFolder != null) {
      overlays.add(
        FolderOverlayWidget(
          folder: state.openFolder!,
          apps: state.folderApps,
          onClose: () => context.read<HomeCubit>().closeFolder(),
          onAppTap: (app) => context.read<HomeCubit>().openApp(app, context),
        ),
      );
    }
    
    if (state.showLanguageOverlay) {
      overlays.add(
        LanguageOverlayWidget(
          onClose: () => context.read<HomeCubit>().closeLanguageOverlay(),
        ),
      );
    }

    if (overlays.isEmpty) {
      return phoneFrame;
    }

    return Stack(
      children: [
        phoneFrame,
        ...overlays,
      ],
    );
  }
}
