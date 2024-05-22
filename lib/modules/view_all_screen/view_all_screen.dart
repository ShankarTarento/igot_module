import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_resource_model.dart';
import 'package:igot_module/modules/resource_card/resource_card.dart';
import 'package:igot_module/modules/resource_details_screen/resource_details_screen.dart';
import 'package:igot_module/modules/skeleton_loading/card_skeleton_loading.dart';
import 'package:igot_module/modules/utils/constants.dart';
import 'package:igot_module/modules/utils/fade_route.dart';
import 'package:igot_module/modules/utils/module_colors.dart';
import 'package:igot_module/modules/view_all_screen/view_all_view_model.dart';
import 'package:igot_module/modules/view_all_screen/widgets/filter_bottom_bar.dart';
import 'widgets/search_field.dart';

class ViewAllScreen extends StatefulWidget {
  final String title;
  final String token;
  final String wid;
  final String apiKey;
  final String rootOrgId;
  final String apiUrl;
  final String baseUrl;
  final Map<String, dynamic> translatedWords;
  final Function(Map<String, dynamic>) contentShare;
  final Function(Map<String, dynamic> data) onTapViewAllButtonTelemetry;
  final Function(Map<String, dynamic> data) cardOnTapTelemetry;
  final Function(Map<String, dynamic> data) viewAllScreenTelemetry;
  final Function(Map<String, dynamic> data) detailsScreenTelemetry;
  final Function(Map<String, dynamic> data) contentStartTelemetry;
  final Function(Map<String, dynamic> data) contentEndTelemetry;
  final bool viewAllSectors;
  final List<String> selectedSector;
  final List<String> selectedSubSector;

  const ViewAllScreen({
    Key key,
    @required this.viewAllScreenTelemetry,
    @required this.translatedWords,
    @required this.contentShare,
    @required this.token,
    @required this.title,
    @required this.wid,
    @required this.apiKey,
    @required this.apiUrl,
    @required this.baseUrl,
    @required this.rootOrgId,
    @required this.cardOnTapTelemetry,
    @required this.contentEndTelemetry,
    @required this.contentStartTelemetry,
    @required this.detailsScreenTelemetry,
    @required this.onTapViewAllButtonTelemetry,
    this.selectedSector,
    this.selectedSubSector,
    this.viewAllSectors = false,
  }) : super(key: key);

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  void initState() {
    widget.viewAllScreenTelemetry({"type": widget.title.toLowerCase()});

    super.initState();
  }

  List<GyaanKarmayogiResource> resources = [];
  Map<String, dynamic> filter;
  String resourceCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModuleColors.gyaanKarmayogiScaffoldBackground,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: ModuleColors.greys60,
            weight: 700,
          ),
        ),
        title: Row(children: [
          Text(
            "${widget.translatedWords["viewAll"]} ${resourceCategory ?? widget.title}" ??
                "View all ${resourceCategory ?? widget.title}",
            style: GoogleFonts.montserrat(
              color: ModuleColors.greys87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ]),
      ),
      bottomNavigationBar: FilterBottomBar(
        selectedSector: widget.selectedSector,
        selectedSubsector: widget.selectedSubSector,
        translatedWords: widget.translatedWords,
        selectedCategory:
            widget.viewAllSectors ? "event" : widget.title.toLowerCase(),
        applyFilter: (value) {
          filter = value;
          resourceCategory = filter["category"];

          debugPrint("applied filters------------$value");
          setState(() {});
        },
        apiUrl: widget.apiUrl,
        baseUrl: widget.baseUrl,
        apiKey: widget.apiKey,
        rootOrgId: widget.rootOrgId,
        token: widget.token,
        wid: widget.wid,
        showAllSectors: widget.viewAllSectors,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            SearchField(
                translatedWords: widget.translatedWords,
                selectedCategory: widget.title.toLowerCase(),
                applyFilter: (value) {
                  if (filter == null) {
                    filter = value;
                  } else {
                    filter["query"] = value["query"];
                  }
                  //  resourceCategory = filter["category"];

                  debugPrint("applied filters------------$filter");
                  setState(() {});
                },
                apiUrl: widget.apiUrl,
                baseUrl: widget.baseUrl,
                apiKey: widget.apiKey,
                rootOrgId: widget.rootOrgId,
                token: widget.token,
                wid: widget.wid),
            const SizedBox(
              height: 16,
            ),
            FutureBuilder<List<GyaanKarmayogiResource>>(
                future: filter != null
                    ? getResources(
                        query: filter["query"] ?? "",
                        sectors: filter["sectors"] ?? [],
                        subSectors: filter["subSectors"] ?? [],
                        resourceCategories: filter["category"] ?? null)
                    : widget.viewAllSectors
                        ? getResources()
                        : getResources(
                            resourceCategories: widget.title.toLowerCase()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                        children: List.generate(
                            3, (index) => const CardSkeletonLoading()));
                  }
                  if (snapshot.data != null) {
                    if (snapshot.data.isNotEmpty) {
                      return Column(
                        children: List.generate(
                          snapshot.data.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ResourceCard(
                              creatorLogo: Image.asset(
                                "assets/igot_creator_icon.png",
                                package: "igot_module",
                                fit: BoxFit.fill,
                              ),
                              creator: snapshot.data[index].source,
                              mimeType: checkContentType(
                                  mimeType: snapshot.data[index].mimeType),
                              mimeTypeIcon: checkContentTypeIcon(
                                  mimeType: snapshot.data[index].mimeType),
                              onTapCallBack: () {
                                widget.cardOnTapTelemetry({
                                  "type": snapshot.data[index].resourceCategory,
                                  "courseId": snapshot.data[index].identifier,
                                  "categoryType":
                                      snapshot.data[index].resourceCategory
                                });

                                Navigator.push(
                                    context,
                                    FadeRoute(
                                        page: ResourceDetailsScreen(
                                      cardOnTapTelemetry:
                                          widget.cardOnTapTelemetry,
                                      contentEndTelemetry:
                                          widget.contentEndTelemetry,
                                      contentStartTelemetry:
                                          widget.contentStartTelemetry,
                                      detailsScreenTelemetry:
                                          widget.detailsScreenTelemetry,
                                      onTapViewAllButtonTelemetry:
                                          widget.onTapViewAllButtonTelemetry,
                                      viewAllScreenTelemetry:
                                          widget.viewAllScreenTelemetry,
                                      translatedWords: widget.translatedWords,
                                      apiKey: widget.apiKey,
                                      apiUrl: widget.apiUrl,
                                      authToken: widget.token,
                                      baseUrl: widget.baseUrl,
                                      deptId: widget.rootOrgId,
                                      resourceId:
                                          snapshot.data[index].identifier,
                                      wid: widget.wid,
                                      contentShare: (share) {
                                        widget.contentShare(share);
                                      },
                                    )));
                              },
                              posterImage: snapshot.data[index].posterImage,
                              resourceDescription:
                                  snapshot.data[index].description,
                              resourceName: snapshot.data[index].name,
                              tags: [
                                snapshot.data[index].sector,
                                snapshot.data[index].subSector
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          widget.translatedWords["noResourcesFound"] ??
                              "No resources found",
                          style: GoogleFonts.lato(fontSize: 14),
                        ),
                      );
                    }
                  }
                  if (snapshot.data == null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        widget.translatedWords["noResourcesFound"] ??
                            "No resources found",
                        style: GoogleFonts.lato(fontSize: 14),
                      ),
                    );
                  }

                  return const SizedBox();
                }),
          ]),
        ),
      ),
    );
  }

  Future<List<GyaanKarmayogiResource>> getResources(
      {List<String> sectors,
      List<String> subSectors,
      String query,
      String resourceCategories}) async {
    return await ViewAllScreenViewModel.getGyaanKarmaYogiResources(
      apiKey: widget.apiKey,
      apiUrl: widget.apiUrl,
      authToken: widget.token,
      baseUrl: widget.baseUrl,
      deptId: widget.rootOrgId,
      requestBody: {
        "request": {
          "query": query,
          "filters": {
            "mimeType": [
              "application/pdf",
              "video/mp4",
              'text/x-url',
              'video/x-youtube',
              'audio/mpeg'
            ],
            "status": ["Live"],
            "sectorName": sectors ?? widget.selectedSector,
            "subSectorName": subSectors ?? widget.selectedSubSector,
            "resourceCategory": resourceCategories
          },
          "sort_by": {"lastUpdatedOn": "desc"},
          "facets": [
            "resourceCategory",
            "sector",
          ]
        }
      },
      wid: widget.wid,
    );
  }

  String checkContentType({String mimeType}) {
    if (mimeType == EMimeTypes.youtubeLink ||
        mimeType == EMimeTypes.externalLink) {
      return "Youtube";
    } else if (mimeType == EMimeTypes.mp4) {
      return "Video";
    } else if (mimeType == EMimeTypes.pdf) {
      return "PDF";
    } else if (mimeType == EMimeTypes.mp3) {
      return "Audio";
    } else {
      return mimeType;
    }
  }

  Widget checkContentTypeIcon({String mimeType}) {
    if (mimeType == EMimeTypes.mp4 ||
        mimeType == EMimeTypes.externalLink ||
        mimeType == EMimeTypes.youtubeLink) {
      return SizedBox(
        width: 14,
        height: 14,
        child: SvgPicture.asset(
          'assets/play.svg',
          package: "igot_module",
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      );
    } else if (mimeType == EMimeTypes.pdf) {
      return SizedBox(
        width: 14,
        height: 14,
        child: SvgPicture.asset(
          'assets/pdf.svg',
          package: "igot_module",
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      );
    } else if (mimeType == EMimeTypes.mp3) {
      return SizedBox(
        width: 14,
        height: 14,
        child: SvgPicture.asset(
          'assets/audio.svg',
          color: Colors.white,
          package: "igot_module",
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const SizedBox(
        width: 14,
        height: 14,
        child: Icon(Icons.error),
      );
    }
  }
}
