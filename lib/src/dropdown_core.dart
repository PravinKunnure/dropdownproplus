import 'package:dropdownproplus/src/common_utils.dart';
import 'package:dropdownproplus/src/dropdownpainter.dart';
import 'package:dropdownproplus/src/helper_widgets.dart';
import 'package:flutter/material.dart';

class DropdownPlus extends StatefulWidget {
  final String dropdownLabel;
  final bool isMandatory;
  final bool isEnabled;
  final bool applyPagination;
  final bool enableSearchBar;
  final String callBackKey;
  final dynamic dropdownItems;
  final dynamic defaultItem;
  final bool enableMultiSelect;
  final bool customItemWidget;
  final Function(dynamic) onItemSelected;
  final Function(dynamic, StateSetter)? onLoadMore;
  final Function(dynamic, dynamic)? funCustomWidget;

  const DropdownPlus({
    super.key,
    this.dropdownLabel = '',
    this.isMandatory = false,
    this.enableSearchBar = false,
    required this.onItemSelected,
    this.callBackKey = '',
    required this.dropdownItems,
    this.defaultItem,
    this.isEnabled = true,
    this.applyPagination = false,
    this.enableMultiSelect = false,
    this.customItemWidget = false,
    this.funCustomWidget,
    this.onLoadMore,
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
    dropdownSelectedItem = widget.defaultItem ?? '';

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
          // color: Colors.blueGrey.shade900.withValues(alpha: 0.5),
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
                  //final double itemHeight = MediaQuery.heightOf(context)/2;
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

                  final double dx = 0; // adjust if needed horizontally
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
                              setState(() {
                                dropdownSelectedItem = val;
                              });
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
  int skip = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels >=
              controller.position.maxScrollExtent - 80 &&
          !isLoading &&
          hasMore &&
          widget.widget.applyPagination) {
        _fetchItems();
        // widget.widget.onLoadMore();
      }
    });

    if (widget.widget.dropdownItems is Future) {
      Future.value(widget.widget.dropdownItems).then((value) {
        items = value as List;
        itemsKeepForSearchOp = items;
        setState(() {});
        // setState(() {
        //   widget.maxHeight = widget.widget.enableSearchBar?320:items.length<=2?100:items.length<=4?170:items.length<=6?250:350; // Adjust per item widget
        // });
      });
    } else {
      items = widget.widget.dropdownItems;
      itemsKeepForSearchOp = items;
    }
  }

  /// -------- UI BUILDER --------
  @override
  Widget build(BuildContext context) {
    //print("SEARCH_VALUE --123> $itemsSearchKeep");

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Card(
          color: Colors.grey.shade100,
          elevation: 0,
          child: SizedBox(
            height: widget.maxHeight - 10,
            child: Column(
              children: [
                // if ((items.length >= 5 || isSearchDone) && widget.widget.isSearchBarRequired)
                if (widget.widget.enableSearchBar)
                  dropdownSearchBar(
                    widget.widget.enableSearchBar,
                    widget.widget.dropdownLabel,
                    (searchedValue) {
                      if (searchedValue.isNotEmpty &&
                          searchedValue.length >= 3) {
                        List<dynamic> tempItems = [];
                        // print("SEARCH_ITEMS -items-> $items");

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

                // items.isEmpty && isSearchDone?
                // Text("Not found")
                //     :
                Expanded(
                  child:
                      //isAPICall?Center(child: appCircularIndicator,) :
                      ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.all(5),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return widget.widget.enableMultiSelect
                              ?
                                ///If Type Is Product - For Filter Case Only
                                InkWell(
                                  onTap: () {},
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
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
                                )
                              : InkWell(
                                  onTap: () {
                                    widget.widget.onItemSelected({
                                      widget.widget.callBackKey:
                                          '${items[index]}',
                                      'tapped_index': index,
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
  Future<void> _fetchItems({String filter = ""}) async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
      isAPICall = true;
    });

    widget.widget.onLoadMore({'skip': skip, 'items_list': items}, setState);
  }
}

///-- String Extension To Capitalise The First Letter Of String
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return '';
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
