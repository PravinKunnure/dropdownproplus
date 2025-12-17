library;

import 'package:flutter/material.dart';

class DropdownProPlus extends StatefulWidget {
  final String label;
  final bool isEnabled;
  final List<String> items;
  final Function(String) onItemSelected;

  const DropdownProPlus({
    super.key,
    this.label = "",
    this.isEnabled = true,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<DropdownProPlus> createState() => _DropdownProPlusState();
}

class _DropdownProPlusState extends State<DropdownProPlus>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isOpen = false;

  String selectedValue = "";

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  final GlobalKey _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedValue = "";

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (isOpen) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
      isOpen = true;
    }
  }

  OverlayEntry _createOverlay() {
    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: _toggleDropdown,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height,
                width: size.width,
                child: Material(
                  elevation: 5,
                  child: SizeTransition(
                    axisAlignment: -1,
                    sizeFactor: _expandAnimation,
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              selectedValue = item;
                              widget.onItemSelected(item);
                              _toggleDropdown();
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _fieldKey,
        onTap: widget.isEnabled ? _toggleDropdown : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedValue.isEmpty ? widget.label : selectedValue,
                style: TextStyle(fontSize: 16),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
