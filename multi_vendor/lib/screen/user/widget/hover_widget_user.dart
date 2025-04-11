import 'package:flutter/material.dart';

class HoverWidgetUser extends StatefulWidget {
  const HoverWidgetUser({super.key});

  @override
  State<HoverWidgetUser> createState() => _HoverWidgetUserState();
}

class _HoverWidgetUserState extends State<HoverWidgetUser> {
  bool _isHovered = false;

  void _onEnter(PointerEvent details) {
    setState(() => _isHovered = true);
  }

  void _onExit(PointerEvent details) {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hover Me',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          AnimatedOpacity(
            opacity: _isHovered ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: _isHovered
                ? MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              print("Item 1 clicked");
                            },
                            child: Text("Dropdown Item 1"),
                          ),
                          TextButton(
                            onPressed: () {
                              print("Item 2 clicked");
                            },
                            child: Text("Dropdown Item 2"),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
