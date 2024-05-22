import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_category_model.dart';
import 'package:igot_module/modules/utils/helper.dart';
import 'package:igot_module/modules/utils/module_colors.dart';

class FilterRadioButton extends StatefulWidget {
  final String title;
  final List<FilterModel> checkListItems;
  final ValueChanged<String> onChanged;
  final String searchHint;
  String selectedItem;

  FilterRadioButton({
    Key key,
    @required this.title,
    @required this.selectedItem,
    @required this.searchHint,
    @required this.checkListItems,
    @required this.onChanged,
  }) : super(key: key);

  @override
  State<FilterRadioButton> createState() => _FilterRadioButtonState();
}

class _FilterRadioButtonState extends State<FilterRadioButton> {
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
        const SizedBox(
          height: 16,
        ),
        Column(
          children: List.generate(
            filteredItems.length,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  widget.selectedItem = filteredItems[index].title;
                });
                widget.onChanged(widget.selectedItem);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 20,
                child: Row(
                  children: [
                    Radio(
                      value: filteredItems[index].title,
                      groupValue: widget.selectedItem,
                      onChanged: (value) {
                        setState(() {
                          widget.selectedItem = value;
                        });
                        widget.onChanged(value);
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return ModuleColors.darkBlue;
                          }
                          return ModuleColors.black40;
                        },
                      ),
                      //  ),                      //activeColor: AppColors.darkBlue,
                    ),
                    Text(
                      ModuleHelper.capitalize(filteredItems[index].title),
                      style: GoogleFonts.lato(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: ModuleColors.greys60,
                      ),
                    ),
                  ],
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
