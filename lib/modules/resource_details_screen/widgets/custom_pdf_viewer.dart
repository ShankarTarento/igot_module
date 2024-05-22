import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_resource_details.dart';
import 'package:igot_module/modules/utils/module_colors.dart';

import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class CustomPdfPlayer extends StatefulWidget {
  final String pdfUrl;
  final ResourceDetails resourceDetails;
  final Map<String, dynamic> translatedWords;

  final Function(Map<String, dynamic> data) contentStartTelemetry;
  final Function(Map<String, dynamic> data) contentEndTelemetry;

  const CustomPdfPlayer({
    this.pdfUrl,
    @required this.resourceDetails,
    @required this.translatedWords,
    @required this.contentEndTelemetry,
    @required this.contentStartTelemetry,
  });

  @override
  _CustomPdfPlayerState createState() => _CustomPdfPlayerState();
}

class _CustomPdfPlayerState extends State<CustomPdfPlayer> {
  bool _isLoading = true;
  PdfController _pdfController;

  List<String> current = [];

  ValueNotifier<int> _currentPage = ValueNotifier(-1);
  int _totalPages;

  String userId;
  String userSessionId;
  String messageIdentifier;
  String departmentId;
  Timer _timer;
  int _start = 0;
  String pageIdentifier;
  String telemetryType;
  String pageUri;
  List allEventsData = [];
  String deviceIdentifier;
  String env;
  ValueNotifier<bool> isCompleted = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  @override
  void didUpdateWidget(CustomPdfPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    loadDocument();
  }

  triggerTelemetryEvent() {
    if (_start == 0) {
      pageUri =
          'viewer/pdf/${widget.resourceDetails.identifier}?primaryCategory=Learning%20Resource&collectionId=${widget.resourceDetails.identifier}&collectionType=Course&batchId=';
      widget.contentStartTelemetry({"pageUri": pageUri});
    }

    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _start++;
      },
    );
  }

  loadDocument() async {
    try {
      var pdfData = await InternetFile.get(widget.pdfUrl);
      _pdfController = PdfController(
        document: PdfDocument.openData(pdfData),
      );
    } catch (e) {
    } finally {}
    if (mounted) {
      setState(() => _isLoading = false);
    }
    triggerTelemetryEvent();
  }

  @override
  void dispose() async {
    widget.contentEndTelemetry({"pageUri": pageUri, "time": _start});
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ModuleColors.scaffoldBackground,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: ModuleColors.appBarBackground,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: ModuleColors.greys60,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  // expandedHeight: 112,
                  flexibleSpace: Center(
                    child: Text(
                      "PDF",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          color: ModuleColors.greys87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.25),
                    ),
                  ),
                ),
              ];
            },
            body: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          PdfView(
                            controller: _pdfController,
                            scrollDirection: Axis.vertical,
                            //  onDocumentError: (error) => ErrorPage(),
                            onDocumentLoaded: (document) {
                              setState(() => _isLoading = true);
                              _totalPages = document.pagesCount;

                              _pdfController.initialPage = 1;

                              _currentPage.value = _pdfController.initialPage;

                              setState(() => _isLoading = false);
                            },
                            builders:
                                const PdfViewBuilders<DefaultBuilderOptions>(
                                    options: DefaultBuilderOptions(
                                        loaderSwitchDuration:
                                            Duration(milliseconds: 500))),
                            onPageChanged: (value) async {
                              _currentPage.value = value;
                              if (_currentPage.value == _totalPages) {
                                isCompleted.value = true;
                              }
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: ModuleColors.appBarBackground,
                              height: 60,
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ValueListenableBuilder(
                                      valueListenable: _currentPage,
                                      builder: (BuildContext context,
                                          int currentPage, Widget child) {
                                        return Expanded(
                                            flex: 1,
                                            child: _currentPage.value != 1
                                                ? InkWell(
                                                    onTap: () {
                                                      // jumpToPage(page: page - 2);
                                                      _pdfController.jumpToPage(
                                                          _currentPage.value -
                                                              1);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      child: Text(
                                                        widget.translatedWords[
                                                                "previous"] ??
                                                            "Previous",
                                                        style: GoogleFonts.lato(
                                                            color: ModuleColors
                                                                .darkBlue,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 14,
                                                            letterSpacing: 0.25,
                                                            height: 1.429),
                                                      ),
                                                    ))
                                                : const SizedBox());
                                      }),
                                  ValueListenableBuilder(
                                      valueListenable: _currentPage,
                                      builder: (BuildContext context,
                                          int currentPage, Widget child) {
                                        return Expanded(
                                            flex: 1,
                                            child: _currentPage.value !=
                                                    _totalPages
                                                ? Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                        onTap: () async {
                                                          _pdfController
                                                              .jumpToPage(
                                                                  _currentPage
                                                                          .value +
                                                                      1);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          child: Text(
                                                            widget.translatedWords[
                                                                    "next"] ??
                                                                "Next",
                                                            style: GoogleFonts.lato(
                                                                color:
                                                                    ModuleColors
                                                                        .darkBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0.25,
                                                                height: 1.429),
                                                          ),
                                                        )),
                                                  )
                                                : Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          child: Text(
                                                            widget.translatedWords[
                                                                    "finish"] ??
                                                                "Finish",
                                                            style: GoogleFonts.lato(
                                                                color:
                                                                    ModuleColors
                                                                        .darkBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0.25,
                                                                height: 1.429),
                                                          ),
                                                        )),
                                                  ));
                                      }),
                                ],
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                              valueListenable: _currentPage,
                              builder: (context, value, child) {
                                return Visibility(
                                  visible: _currentPage.value != null &&
                                      _totalPages != null,
                                  child: Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      margin: const EdgeInsets.all(16),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          color: ModuleColors.greys60),
                                      child: Text(
                                        '${_currentPage.value} of $_totalPages',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                            color:
                                                ModuleColors.appBarBackground,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.25),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      )),
          ),
        ));
  }
}
