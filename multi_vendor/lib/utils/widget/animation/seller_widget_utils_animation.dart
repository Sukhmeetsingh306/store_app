import 'package:flutter/material.dart';

enum SellerAnimationType {
  fadeSlide1,
  fadeSlide3,
  slide,
  fadeSlideScale2,
}

class SellerWidgetUtilsAnimation {
  final AnimationController controller1;
  final AnimationController controller2;
  final AnimationController controller3;
  final AnimationController controllerMain;

  late Animation<Offset> slide1;
  late Animation<double> fade1;

  late Animation<Offset> slide2;
  late Animation<double> fade2;
  late Animation<double> scale2;

  late Animation<double> fade3;
  late Animation<Offset> move3;

  late Animation<Offset> offset;

  SellerWidgetUtilsAnimation({required TickerProvider vsync})
      : controller1 = AnimationController(
          vsync: vsync,
          duration: const Duration(
            milliseconds: 1000,
          ),
        ),
        controller2 = AnimationController(
          vsync: vsync,
          duration: const Duration(
            milliseconds: 1000,
          ),
        ),
        controller3 = AnimationController(
          vsync: vsync,
          duration: const Duration(
            milliseconds: 500,
          ),
        ),
        controllerMain = AnimationController(
          vsync: vsync,
          duration: const Duration(
            milliseconds: 1200,
          ),
        ) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    slide1 =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: controller1, curve: Curves.easeOut),
    );

    fade1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller1, curve: Curves.easeIn),
    );

    slide2 =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: controller2, curve: Curves.easeInOut),
    );

    fade2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller2, curve: Curves.easeInOut),
    );

    scale2 = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: controller2, curve: Curves.easeInOut),
    );

    fade3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller1, curve: Curves.easeInOut),
    );

    move3 =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: controller1, curve: Curves.easeInOut),
    );

    offset =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: controllerMain, curve: Curves.easeOutCubic),
    );

    // Start animations
    controller1.forward();
    Future.delayed(const Duration(milliseconds: 50), () {
      controller2.forward();
      controller3.forward();
    });
    controllerMain.forward();
  }

  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controllerMain.dispose();
  }

  /// Returns animated widget wrapper
  Widget buildAnimated({
    required SellerAnimationType type,
    required Widget child,
  }) {
    switch (type) {
      case SellerAnimationType.fadeSlide1:
        return SlideTransition(
          position: slide1,
          child: FadeTransition(
            opacity: fade1,
            child: child,
          ),
        );
      case SellerAnimationType.fadeSlide3:
        return FadeTransition(
          opacity: fade3,
          child: SlideTransition(
            position: move3,
            child: child,
          ),
        );
      case SellerAnimationType.slide:
        return SlideTransition(
          position: offset,
          child: child,
        );
      case SellerAnimationType.fadeSlideScale2:
        return FadeTransition(
          opacity: fade2,
          child: SlideTransition(
            position: slide2,
            child: ScaleTransition(
              scale: scale2,
              child: child,
            ),
          ),
        );
    }
  }
}
