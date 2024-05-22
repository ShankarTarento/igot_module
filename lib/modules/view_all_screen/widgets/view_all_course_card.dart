import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_resource_model.dart';
import 'package:igot_module/modules/utils/constants.dart';
import 'package:igot_module/modules/utils/module_colors.dart';

class ViewAllCourseCard extends StatelessWidget {
  final GyaanKarmayogiResource resource;
  const ViewAllCourseCard({Key key, @required this.resource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 351,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            height: 217,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: resource.posterImage != null
                    ? NetworkImage(resource.posterImage)
                    : const AssetImage(
                        'assets/image_placeholder.jpg',
                        package: "igot_module",
                      ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.only(
                      top: 3, bottom: 3, left: 6, right: 6),
                  decoration: BoxDecoration(
                      color: ModuleColors.darkBlue,
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      checkContentTypeIcon(),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        checkContentType(),
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    resource.sector != null
                        ? Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 6, bottom: 6),
                            decoration: BoxDecoration(
                                color: const Color(0xffFEFAF4),
                                border:
                                    Border.all(color: ModuleColors.primaryOne),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                Text(
                                  resource.sector,
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                    resource.subSector != null
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 6, bottom: 6),
                            decoration: BoxDecoration(
                                color: const Color(0xffFEFAF4),
                                border:
                                    Border.all(color: ModuleColors.primaryOne),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                Text(
                                  resource.subSector,
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                resource.name != null
                    ? Text(
                        resource.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 8,
                ),
                resource.description != null
                    ? Text(
                        resource.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: ModuleColors.black16),
                      ),
                      child: Image.asset(
                        "assets/igot_creator_icon.png",
                        package: "igot_module",
                        fit: BoxFit.fill,
                      ),
                    ),
                    resource.source != null
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              "By ${resource.source}",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : const SizedBox()
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String checkContentType() {
    if (resource.mimeType == EMimeTypes.youtubeLink ||
        resource.mimeType == EMimeTypes.externalLink) {
      return "Youtube";
    } else if (resource.mimeType == EMimeTypes.mp4) {
      return "Video";
    } else if (resource.mimeType == EMimeTypes.pdf) {
      return "PDF";
    } else if (resource.mimeType == EMimeTypes.mp3) {
      return "Audio";
    } else {
      return resource.mimeType;
    }
  }

  Widget checkContentTypeIcon() {
    if (resource.mimeType == EMimeTypes.mp4 ||
        resource.mimeType == EMimeTypes.externalLink ||
        resource.mimeType == EMimeTypes.youtubeLink) {
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
    } else if (resource.mimeType == EMimeTypes.pdf) {
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
    } else if (resource.mimeType == EMimeTypes.mp3) {
      return SizedBox(
        width: 14,
        height: 14,
        child: SvgPicture.asset(
          'assets/audio.svg',
          package: "igot_module",
          alignment: Alignment.center,
          fit: BoxFit.cover,
          color: Colors.white,
        ),
      );
    }
    return const SizedBox();
  }
}
