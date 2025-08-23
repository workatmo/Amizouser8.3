import 'dart:async';
import 'dart:io';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/sign_in/sign_in_view.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  final bool fromResetPassword;
  const SignInScreen(
      {super.key,
      required this.exitFromApp,
      required this.backFromThis,
      this.fromResetPassword = false});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
          }
        } else {
          if (Get.find<AuthController>().isOtpViewEnable) {
            Get.find<AuthController>().enableOtpView(enable: false);
          } else {
            Get.back();
          }
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context)
            ? null
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () {
                        if (Get.find<AuthController>().isOtpViewEnable) {
                          Get.find<AuthController>()
                              .enableOtpView(enable: false);
                        } else {
                          Get.back(result: false);
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    elevation: 0,
                    backgroundColor: Theme.of(context).cardColor)
                : null,
        body: SafeArea(
            child: Align(
          alignment: Alignment.center,
          child: Container(
            width: context.width > 700 ? 500 : context.width,
            padding: context.width > 700
                ? const EdgeInsets.all(50)
                : const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge),
            margin: context.width > 700
                ? const EdgeInsets.all(50)
                : EdgeInsets.zero,
            decoration: context.width > 700
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: ResponsiveHelper.isDesktop(context)
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                  )
                : null,
            child: SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                ResponsiveHelper.isDesktop(context)
                    ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.clear),
                        ),
                      )
                    : const SizedBox(),
                Image.asset(
                  Images.logoName,
                  height: 160,
                  width: 600,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: Dimensions.paddingSizeOverLarge),
                SignInView(
                  exitFromApp: widget.exitFromApp,
                  backFromThis: widget.backFromThis,
                  fromResetPassword: widget.fromResetPassword,
                  isOtpViewEnable: (v) {},
                ),
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.security,
                        size: 14,
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Your data is protected with end-to-end encryption',
                        style: robotoRegular.copyWith(
                          fontSize: 10,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .color!
                              .withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        'https://www.instagram.com/workatmo_technologies_pvt_ltd/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      showCustomSnackBar('Could not open Instagram profile');
                    }
                  },
                  child: Text(
                    'Amizotix Technologies Private Limited\nDeveloped by Workatmo Technologies Private Limited',
                    style: robotoRegular.copyWith(
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .color!
                          .withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
            ),
          ),
        )),
      ),
    );
  }
}
