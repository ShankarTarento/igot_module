import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_category_model.dart';
import 'package:igot_module/modules/utils/helper.dart';
import 'package:igot_module/modules/utils/module_colors.dart';

class FilterCheckbox extends StatefulWidget {
  final String title;
  final List<FilterModel> checkListItems;
  final ValueChanged<List<String>> onChanged;
  final String searchHint;
  List<String> selectedItems;

  FilterCheckbox({
    Key key,
    @required this.title,
    @required this.selectedItems,
    @required this.searchHint,
    @required this.checkListItems,
    @required this.onChanged,
  }) : super(key: key);

  @override
  State<FilterCheckbox> createState() => _FilterCheckboxState();
}

class _FilterCheckboxState extends State<FilterCheckbox> {
  List<FilterModel> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.checkListItems;
  }

  void _filterList(String query) {
    setState(() {
      filteredItems = widget.checkListItems
          .where(
              (item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void didUpdateWidget(covariant FilterCheckbox oldWidget) {
    if (oldWidget.checkListItems != widget.checkListItems) {
      filteredItems = widget.checkListItems;
    }
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          widget.title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: TextField(
            onChanged: _filterList,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: ModuleColors.grey08, width: 1),
                borderRadius: BorderRadius.circular(40.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: ModuleColors.grey08, width: 1),
                borderRadius: BorderRadius.circular(40.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: ModuleColors.grey08, width: 1),
                borderRadius: BorderRadius.circular(40.0),
              ),
              contentPadding: const EdgeInsets.only(left: 12, right: 12),
              hintText: widget.searchHint,
              prefixIcon: const Icon(
                Icons.search,
                color: ModuleColors.greys87,
              ),
              hintStyle: GoogleFonts.lato(
                fontSize: 12,
                color: ModuleColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Column(
          children: List.generate(
            filteredItems.length,
            (index) => InkWell(
              onTap: () {
                ///check this logic
                filteredItems[index].isSelected =
                    !filteredItems[index].isSelected;

                setState(() {
                  if (widget.selectedItems
                      .contains(filteredItems[index].title)) {
                    widget.selectedItems.remove(filteredItems[index].title);
                  } else {
                    widget.selectedItems.add(filteredItems[index].title);
                  }
                });
                widget.onChanged(widget.selectedItems);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 20,
                child: CheckboxListTile(
                  activeColor: ModuleColors.darkBlue,
                  side: const BorderSide(color: ModuleColors.black40),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    ModuleHelper.capitalize(filteredItems[index].title),
                    style: GoogleFonts.lato(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: ModuleColors.greys60,
                    ),
                  ),
                  enabled: true,
                  value: filteredItems[index].isSelected,
                  onChanged: (value) {
                    setState(() {
                      filteredItems[index].isSelected = value;
                      if (widget.selectedItems
                              .contains(filteredItems[index].title) &&
                          !filteredItems[index].isSelected) {
                        widget.selectedItems.remove(filteredItems[index].title);
                      } else if (filteredItems[index].isSelected == true) {
                        widget.selectedItems.add(filteredItems[index].title);
                      }
                    });
                    widget.onChanged(widget.selectedItems);
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}
