import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:igot_module/modules/utils/module_colors.dart';

class SearchField extends StatefulWidget {
  final Function(Map<String, dynamic>) applyFilter;
  final String token;
  final String wid;
  final String apiKey;
  final String apiUrl;
  final String rootOrgId;
  final String baseUrl;
  final String selectedCategory;
  final Map<String, dynamic> translatedWords;
  const SearchField(
      {Key key,
      @required this.translatedWords,
      @required this.applyFilter,
      @required this.token,
      @required this.wid,
      @required this.apiUrl,
      @required this.apiKey,
      @required this.baseUrl,
      @required this.selectedCategory,
      @required this.rootOrgId})
      : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width / 1.1,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(40.0),
              ),
              contentPadding: const EdgeInsets.only(left: 12, right: 12),
              hintText: widget.translatedWords["searchInGyaanKarmayogi"] ??
                  'Search in Gyaan Karmayogi',
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
            onSubmitted: (value) {
              //  searchFilter["query"] = value;
              if (value != null && value != "") {
                widget.applyFilter({"query": value});
              }
            },
          ),
        ),
      ],
    );
  }
}
