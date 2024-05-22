import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_resource_model.dart';
import 'package:igot_module/modules/resource_card/resource_card.dart';
import 'package:igot_module/modules/resource_details_screen/resource_details_screen.dart';
import 'package:igot_module/modules/utils/constants.dart';
import 'package:igot_module/modules/utils/fade_route.dart';
import 'package:igot_module/modules/utils/module_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ResourceCardCarousel extends StatefulWidget {
  final String title;
  final String apiKey;
  final String apiUrl;
  final String authToken;
  final String baseUrl;
  final String deptId;
  final String wid;
  final Function(Map<String, dynamic>) contentShare;
  final Map<String, dynamic> translatedWords;
  final Function(Map<String, dynamic> data) onTapViewAllButtonTelemetry;
  final Function(Map<String, dynamic> data) cardOnTapTelemetry;
  final Function(Map<String, dynamic> data) viewAllScreenTelemetry;
  final Function(Map<String, dynamic> data) detailsScreenTelemetry;
  final Function(Map<String, dynamic> data) contentStartTelemetry;
  final Function(Map<String, dynamic> data) contentEndTelemetry;
  final List<GyaanKarmayogiResource> resources;
  const ResourceCardCarousel({
    Key key,
    @required this.wid,
    @required this.contentShare,
    @required this.title,
    @required this.apiKey,
    @required this.translatedWords,
    @required this.authToken,
    @required this.baseUrl,
    @required this.apiUrl,
    @required this.deptId,
    @required this.resources,
    @required this.cardOnTapTelemetry,
    @required this.contentEndTelemetry,
    @required this.contentStartTelemetry,
    @required this.detailsScreenTelemetry,
    @required this.onTapViewAllButtonTelemetry,
    @required this.viewAllScreenTelemetry,
  }) : super(key: key);

  @override
  State<ResourceCardCarousel> createState() => _ResourceCardCarouselState();
}

class _ResourceCardCarouselState extends State<ResourceCardCarousel> {
  PageController pageController = PageController();
  int currentIndex = 0;
  final int maxCountToShowNavIcon = 1;
  Future karmayogiResources;

  @override
  void initState() {
    currentIndex = 0;

    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page.round();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 381,
          margin: const EdgeInsets.only(left: 0, top: 0, bottom: 15),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount:
                      widget.resources.length > 5 ? 4 : widget.resources.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: ResourceCard(
                        creatorLogo: Image.asset(
                          "assets/igot_creator_icon.png",
                          package: "igot_module",
                          fit: BoxFit.fill,
                        ),
                        creator: widget.resources[index].source,
                        mimeType: checkContentType(
                            mimeType: widget.resources[index].mimeType),
                        mimeTypeIcon: checkContentTypeIcon(
                            mimeType: widget.resources[index].mimeType),
                        onTapCallBack: () {
                          widget.cardOnTapTelemetry({
                            "type": widget.resources[index].resourceCategory,
                            "courseId": widget.resources[index].identifier,
                            "categoryType":
                                widget.resources[index].resourceCategory
                          });

                          Navigator.push(
                            context,
                            FadeRoute(
                              page: ResourceDetailsScreen(
                                cardOnTapTelemetry: widget.cardOnTapTelemetry,
                                contentEndTelemetry: widget.contentEndTelemetry,
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
                                authToken: widget.authToken,
                                baseUrl: widget.baseUrl,
                                deptId: widget.deptId,
                                resourceId: widget.resources[index].identifier,
                                wid: widget.wid,
                                contentShare: (share) {
                                  widget.contentShare(share);
                                },
                              ),
                            ),
                          );
                        },
                        posterImage: widget.resources[index].posterImage,
                        resourceDescription:
                            widget.resources[index].description,
                        resourceName: widget.resources[index].name,
                        tags: [
                          widget.resources[index].sector,
                          widget.resources[index].subSector
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SmoothPageIndicator(
                controller: pageController,
                count:
                    widget.resources.length > 5 ? 4 : widget.resources.length,
                effect: const ExpandingDotsEffect(
                    activeDotColor: ModuleColors.orangeTourText,
                    dotColor: ModuleColors.profilebgGrey20,
                    dotHeight: 4,
                    dotWidth: 4,
                    spacing: 4),
              )
            ],
          ),
        ),
        Visibility(
            visible: widget.resources.length > maxCountToShowNavIcon,
            child: Positioned(
              top: 160,
              left: 0,
              child: InkWell(
                onTap: () {
                  if (currentIndex > 0) {
                    pageController.animateToPage(
                      currentIndex - 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 16,
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
        Visibility(
            visible: widget.resources.length > maxCountToShowNavIcon,
            child: Positioned(
              top: 160,
              right: 0,
              child: InkWell(
                onTap: () {
                  if (currentIndex < 3) {
                    pageController.animateToPage(
                      currentIndex + 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 16,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
      ],
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
