import 'package:flutter/material.dart';
import 'package:multi_vendor/utils/fonts/google_fonts_utils.dart';
import 'package:multi_vendor/utils/widget/button_widget_utils.dart';
import '../../../utils/routes/navigation_routes.dart';
import '../../../utils/theme/color/color_theme.dart';

class HoverWidgetUser extends StatefulWidget {
  const HoverWidgetUser({super.key});

  @override
  State<HoverWidgetUser> createState() => _HoverWidgetUserState();
}

class _HoverWidgetUserState extends State<HoverWidgetUser> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool _isHoveringText = false;
  bool _isHoveringDropdown = false;

  void _showDropdown() {
    if (_overlayEntry != null) return; // Already showing
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _checkShouldHide() {
    if (!_isHoveringText && !_isHoveringDropdown) {
      _hideDropdown();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        child: MouseRegion(
          onEnter: (_) {
            _isHoveringDropdown = true;
          },
          onExit: (_) {
            _isHoveringDropdown = false;
            Future.delayed(Duration(milliseconds: 100), _checkShouldHide);
          },
          child: Material(
            elevation: 4,
            child: Container(
              width: 180,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorTheme.color.whiteColor,
                border: Border.all(color: ColorTheme.color.whiteColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  googleInterText(
                    "Hello User",
                    fontWeight: FontWeight.w500,
                  ),
                  Divider(),
                  textButton(
                    'Sign In',
                    () {
                      materialRouteNavigatorRepNamed(
                        context,
                        '/loginPage',
                      );
                    },
                    fontWeight: FontWeight.w400,
                  ),
                  Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      textButton("My Order", fontWeight: FontWeight.w400, () {
                        print("My Order clicked");
                        _hideDropdown();
                      }),
                    ],
                  ),
                  Divider(),
                  textButton(
                    'Delete Account',
                    () {
                      print("Sign In clicked");
                      _hideDropdown();
                    },
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isHoveringText = true;
        _showDropdown();
      },
      onExit: (_) {
        _isHoveringText = false;
        Future.delayed(Duration(milliseconds: 100), _checkShouldHide);
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            googleInterText(
              'Sign In',
              fontSize: 15,
              color: ColorTheme.color.textWhiteColor,
              fontWeight: FontWeight.w400,
            ),
            googleInterTextWeight4Font14(
              "Account",
              color: ColorTheme.color.textWhiteColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }
}
