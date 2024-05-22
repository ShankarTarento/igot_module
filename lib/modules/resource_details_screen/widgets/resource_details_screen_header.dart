import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:igot_module/modules/data_models/gyaan_karmayogi_resource_details.dart';
import 'package:igot_module/modules/utils/constants.dart';
import 'package:igot_module/modules/utils/helper.dart';
import 'package:igot_module/modules/utils/module_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceDetailsScreenHeader extends StatefulWidget {
  final ResourceDetails resourceDetails;
  final Map<String, dynamic> translatedWords;

  const ResourceDetailsScreenHeader({
    Key key,
    @required this.resourceDetails,
    @required this.translatedWords,
  }) : super(key: key);

  @override
  State<ResourceDetailsScreenHeader> createState() =>
      _ResourceDetailsScreenHeaderState();
}

class _ResourceDetailsScreenHeaderState
    extends State<ResourceDetailsScreenHeader> {
  @override
  void initState() {
    htmlContent =
        html_parser.parse(widget.resourceDetails.instructions).body.text;
    var links = html_parser
        .parse(widget.resourceDetails.instructions)
        .querySelector('a');
    url = links == null ? null : links.attributes['href'];

    super.initState();
  }

  String url;

  String htmlContent;
  final int defaultLength = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff3A83CF), Color(0xff1B4CA1)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(
          //   height: 8,
          // ),
          Row(
            children: [
              widget.resourceDetails.sectorName != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                          color: ModuleColors.greys60,
                          border: Border.all(color: ModuleColors.primaryOne),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Text(
                            widget.resourceDetails.sectorName,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: ModuleColors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              widget.resourceDetails.subSectorName != null
                  ? Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                          color: ModuleColors.greys60,
                          border: Border.all(color: ModuleColors.primaryOne),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Text(
                            widget.resourceDetails.subSectorName,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: ModuleColors.white,
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
          Text(
            widget.resourceDetails.name,
            style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ModuleColors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          widget.resourceDetails.instructions != null
              ? InkWell(
                  onTap: () async {
                    if (htmlContent.length > defaultLength) {
                      debugPrint("length greater than default length");
                      if (url != null && await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    }
                  },
                  child: HtmlWidget(
                    (htmlContent.length > defaultLength)
                        ? '${htmlContent.substring(0, defaultLength)}...'
                        : widget.resourceDetails.instructions,
                    textStyle: (htmlContent.length > defaultLength)
                        ? GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ModuleColors.white,
                          )
                        : null,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 16,
          ),
          Text(
            "${widget.translatedWords["publishedOn"]} ${ModuleHelper.getDateTimeInFormat(dateTime: widget.resourceDetails.lastPublishedOn, desiredDateFormat: ModuleConstants.dateFormat2)}",
            style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ModuleColors.white),
          ),
          const SizedBox(
            height: 16,
          ),
          Wrap(
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,

            runSpacing: 20,
            spacing: 16,
            children: [
              titleSubtitle(
                  context: context,
                  title: widget.translatedWords["sector"] ?? "Sector",
                  subtitle: widget.resourceDetails.sectorName ?? "-"),
              titleSubtitle(
                  context: context,
                  title: widget.translatedWords["subSector"] ?? "Sub-Sector",
                  subtitle: widget.resourceDetails.subSectorName ?? "-"),
              titleSubtitle(
                  context: context,
                  title: widget.translatedWords["category"] ?? "Category",
                  subtitle: widget.resourceDetails.resourceCategory ?? "-"),
              titleSubtitle(
                  context: context,
                  title:
                      widget.translatedWords["resourceType"] ?? "Resource type",
                  subtitle: resourceType() ?? "-")
            ],
            //  List.generate(5, (index) => titleSubtitle(context: context)),
          )
        ],
      ),
    );
  }

  String resourceType() {
    if (widget.resourceDetails.mimeType == EMimeTypes.youtubeLink ||
        widget.resourceDetails.mimeType == EMimeTypes.externalLink) {
      return "Youtube";
    } else if (widget.resourceDetails.mimeType == EMimeTypes.mp4) {
      return "Video";
    } else if (widget.resourceDetails.mimeType == EMimeTypes.mp3) {
      return "Audio";
    } else {
      return "PDF";
    }
  }

  Widget titleSubtitle(
      {@required BuildContext context,
      @required String title,
      @required String subtitle}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ModuleColors.white),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ModuleColors.white),
          )
        ],
      ),
    );
  }
}
