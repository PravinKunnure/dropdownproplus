import 'package:dropdownproplus/src/common_utils.dart';
import 'package:dropdownproplus/src/dropdownpainter.dart';
import 'package:dropdownproplus/src/helper_widgets.dart';
import 'package:flutter/material.dart';

class DropdownPlus extends StatefulWidget {
  final dynamic value;
  final String dropdownLabel;
  final bool isMandatory;
  final bool isEnabled;
  final bool applyPagination;
  final bool enableSearchBar;
  final String callBackKey;
  final dynamic dropdownItems;
  final bool enableMultiSelect;
  final bool customItemWidget;
  final int skip;
  final Function(dynamic) onItemSelected;
  // final Function(dynamic,StateSetter,bool,bool,bool,int)? onLoadMore;
  final Function(dynamic)? onLoadMore;
  final Function(dynamic, dynamic)? funCustomWidget;

  const DropdownPlus({
    super.key,
    required this.value,
    this.dropdownLabel = '',
    this.isMandatory = false,
    this.enableSearchBar = false,
    required this.onItemSelected,
    required this.callBackKey,
    required this.dropdownItems,
    this.isEnabled = false,
    this.applyPagination = false,
    this.enableMultiSelect = false,
    this.customItemWidget = false,
    this.funCustomWidget,
    this.onLoadMore,
    this.skip = 1,
  });

  @override
  State<DropdownPlus> createState() => _DropdownPlusState();
}

class _DropdownPlusState extends State<DropdownPlus>
    with SingleTickerProviderStateMixin {
  final globalKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isOpen = false;

  String dropdownSelectedItem = '';

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    dropdownSearchController.text = '';
    dropdownSelectedItem = widget.value ?? '';

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || globalKey.currentContext == null) return;

        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
        _animationController.forward();
        isOpen = true;
      });
    }
    FocusScope.of(context).unfocus();
  }

  OverlayEntry _createOverlayEntry() {
    List<dynamic> dropDownItems = [];
    final RenderBox renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox;
    final Size fieldSize = renderBox.size;
    final Offset fieldOffset = renderBox.localToGlobal(Offset.zero);
    final Rect sectionRect = Rect.fromLTWH(
      fieldOffset.dx,
      fieldOffset.dy + 20,
      fieldSize.width,
      fieldSize.height - 20,
    );
    return OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleDropdown,
                  behavior: HitTestBehavior.translucent,
                  child: CustomPaint(
                    painter: DDHighlighter(sectionRect: sectionRect),
                  ),
                ),
              ),

              StatefulBuilder(
                builder: (context, setState_) {
                  double itemHeight = 300;
                  if (widget.dropdownItems is Future) {
                    Future.value(widget.dropdownItems).then((value) {
                      dropDownItems = value as List;
                    });
                    setState_(() {
                      itemHeight = 350;
                    });
                  } else if (widget.enableMultiSelect) {
                    itemHeight = 421;
                  } else {
                    dropDownItems = widget.dropdownItems ?? [];
                    itemHeight = widget.enableSearchBar
                        ? 320
                        : dropDownItems.length <= 2
                        ? 100
                        : dropDownItems.length <= 4
                        ? 170
                        : dropDownItems.length <= 6
                        ? 250
                        : 350; // Adjust per item widget
                  }

                  final Size screenSize = MediaQuery.of(context).size;
                  final keyboardHeight = MediaQuery.of(
                    context,
                  ).viewInsets.bottom;

                  final double spaceBelow =
                      screenSize.height - (fieldOffset.dy + fieldSize.height);
                  final double spaceAbove = fieldOffset.dy;
                  final bool showAbove =
                      spaceBelow < itemHeight && spaceAbove > spaceBelow;
                  final double maxAvailableHeight = showAbove
                      ? spaceAbove
                      : spaceBelow;
                  final double overlayHeight = itemHeight < maxAvailableHeight
                      ? itemHeight + keyboardHeight
                      : maxAvailableHeight + keyboardHeight;
                  final double dx = 0;
                  final double dy = showAbove
                      ? -overlayHeight
                      : fieldSize.height;

                  return CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(dx, dy),
                    child: SizeTransition(
                      sizeFactor: _expandAnimation,
                      axisAlignment: -1,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: overlayHeight,
                          minWidth: renderBox.size.width,
                          maxWidth: renderBox.size.width,
                        ),
                        child: Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: _DropdownContent(
                            keyU: UniqueKey(),
                            toggleDD: (val) {
                              if (!widget.customItemWidget) {
                                setState(() {
                                  dropdownSelectedItem = val;
                                });
                              }
                              _toggleDropdown();
                            },
                            widget: widget,
                            maxHeight: overlayHeight,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
      key: globalKey,
      link: _layerLink,
      child: InkWell(
        onTap: widget.isEnabled ? _toggleDropdown : null,
        child: dropdownTextField(
          widget.dropdownLabel,
          TextEditingController(text: dropdownSelectedItem.capitalize()),
          widget.isEnabled,
          isMandatory: widget.isMandatory,
          providedIcon: Icons.arrow_drop_down_circle_outlined,
          isDropDown: true,
          // maxLines: widget.dropDownType == 'product' ? -1 : 1,
          maxLines: -1,
        ),
      ),
    );
  }
}

///---------DropDown Widget And Operations
class _DropdownContent extends StatefulWidget {
  final dynamic widget;
  final keyU;
  final double maxHeight;
  final Function(dynamic) toggleDD;

  const _DropdownContent({
    required this.widget,
    required this.maxHeight,
    required this.toggleDD,
    this.keyU,
  });

  @override
  State<_DropdownContent> createState() => _DropdownContentState();
}

class _DropdownContentState extends State<_DropdownContent> {
  final ScrollController controller = ScrollController();
  List<dynamic> items = [];
  List<dynamic> itemsKeepForSearchOp = [];
  bool isLoading = false;
  bool hasMore = true;
  bool isAPICall = false;
  int skip = 1;

  List multiSelected = [];

  @override
  void initState() {
    super.initState();
    skip = widget.widget.skip;
    controller.addListener(() {
      if (controller.position.pixels >=
              controller.position.maxScrollExtent - 80 &&
          !isLoading &&
          hasMore &&
          widget.widget.applyPagination) {
        _fetchItems();
      }
    });
    if (widget.widget.dropdownItems is Future) {
      Future.value(widget.widget.dropdownItems).then((value) {
        items = value as List;
        itemsKeepForSearchOp = items;
        setState(() {});
      });
    } else {
      items = widget.widget.dropdownItems;
      itemsKeepForSearchOp = items;
    }
  }

  /// -------- UI BUILDER --------
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Card(
          color: Colors.grey.shade100,
          elevation: 0,
          child: SizedBox(
            // height:widget.widget.enableMultiSelect?widget.maxHeight+70:widget.maxHeight-10,
            height: widget.maxHeight - 10,
            child: Column(
              children: [
                if (widget.widget.enableSearchBar)
                  dropdownSearchBar(
                    widget.widget.enableSearchBar,
                    widget.widget.dropdownLabel,
                    (searchedValue) {
                      if (searchedValue.isNotEmpty &&
                          searchedValue.length >= 3) {
                        List<dynamic> tempItems = [];
                        for (var itm in items) {
                          String prodName = itm.toString().toLowerCase();
                          String sVal = searchedValue.toString().toLowerCase();
                          if (prodName.toLowerCase().contains(sVal) ||
                              prodName.startsWith(sVal) ||
                              prodName == sVal) {
                            tempItems.add(itm);
                          }
                        }
                        setState(() {
                          if (tempItems.isNotEmpty) {
                            items = tempItems;
                          }
                        });
                      }
                    },
                    (value) {
                      setState(() {
                        items = itemsKeepForSearchOp;
                      });
                    },
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    padding: const EdgeInsets.all(5),
                    itemCount:
                        items.length +
                        (hasMore && widget.widget.applyPagination ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == items.length &&
                          widget.widget.applyPagination) {
                        return hasMore
                            ? Center(
                                child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox.shrink();
                      }

                      return widget.widget.enableMultiSelect
                          ?
                            ///If Multi-Select Enabled
                            StatefulBuilder(
                              builder: (context, setState_) {
                                return InkWell(
                                  onTap: () {
                                    setState_(() {
                                      if (multiSelected.contains(
                                        items[index],
                                      )) {
                                        multiSelected.remove(items[index]);
                                      } else {
                                        multiSelected.add(items[index]);
                                      }
                                      //widget.widget.onItemSelected({widget.widget.callBackKey:'${items[index]}','tapped_index':index,'items':items});
                                      //widget.toggleDD('${items[index]}');
                                    });
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            multiSelected.contains(items[index])
                                                ? Icons.check_box_rounded
                                                : Icons
                                                      .check_box_outline_blank_rounded,
                                            color: Colors.pinkAccent,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              items[index] ?? '-',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : InkWell(
                              onTap: () {
                                widget.widget.onItemSelected({
                                  widget.widget.callBackKey: '${items[index]}',
                                  'tapped_index': index,
                                  'items': items,
                                });
                                widget.toggleDD('${items[index]}');
                              },

                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: widget.widget.customItemWidget
                                      ? widget.widget.funCustomWidget(
                                          index,
                                          items,
                                        )
                                      : Text(
                                          '${items[index]}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                            );
                    },
                  ),
                ),

                if (widget.widget.enableMultiSelect) SizedBox(height: 7),
                if (widget.widget.enableMultiSelect)
                  InkWell(
                    onTap: () {
                      String result = multiSelected
                          .map((e) => e.toString())
                          .join(' | ');

                      widget.toggleDD(result.toString());

                      widget.widget.onItemSelected({
                        widget.widget.callBackKey: 'multikey',
                        'tapped_index': -1,
                        'items': multiSelected,
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      //padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// -------- FETCH API ITEMS CLEANLY --------
  Future<void> _fetchItems() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    final List newData = await widget.widget.onLoadMore!(skip);

    if (!mounted) return;

    setState(() {
      items.addAll(newData);
      itemsKeepForSearchOp = items;
      skip += 1;
      isLoading = false;

      if (newData.length < 20) {
        hasMore = false;
      }
    });
  }
}
