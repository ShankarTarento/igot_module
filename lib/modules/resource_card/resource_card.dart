import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:igot_module/modules/utils/module_colors.dart';

class ResourceCard extends StatelessWidget {
  final String resourceName;
  final String posterImage;
  final String mimeType;
  final Widget mimeTypeIcon;
  final List<String> tags;
  final String resourceDescription;
  final String creator;
  final Widget creatorLogo;
  final Function() onTapCallBack;

  const ResourceCard({
    Key key,
    this.resourceName,
    this.creator,
    this.creatorLogo,
    this.mimeType,
    this.mimeTypeIcon,
    this.tags,
    this.posterImage,
    this.resourceDescription,
    this.onTapCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCallBack,
      child: Container(
        height: 361,
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
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: posterImage != null
                      ? NetworkImage(posterImage)
                      : const AssetImage(
                          'assets/image_placeholder.jpg',
                          package: "igot_module",
                        ),
                ),
              ),
              child: mimeType != null
                  ? Column(
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
                              SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: mimeTypeIcon ?? const SizedBox()),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                mimeType,
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
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12,
                top: 8,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: tags != null
                            ? List.generate(tags.length, (index) {
                                return tags[index] != null
                                    ? Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 6,
                                            bottom: 6),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffFEFAF4),
                                            border: Border.all(
                                                color: ModuleColors.primaryOne),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Row(
                                          children: [
                                            Text(
                                              tags[index],
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox();
                              })
                            : [const SizedBox()],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  resourceName != null
                      ? Text(
                          resourceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 12,
                  ),
                  resourceDescription != null
                      ? Text(
                          resourceDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 12,
                  ),
                  creator != null
                      ? Row(
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              padding: const EdgeInsets.all(3),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: ModuleColors.black16),
                              ),
                              child: creatorLogo ??
                                  Image.asset(
                                    "assets/igot_creator_icon.png",
                                    package: "igot_module",
                                    fit: BoxFit.fill,
                                  ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                creator,
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
