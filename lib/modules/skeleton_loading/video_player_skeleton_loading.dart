import 'package:flutter/material.dart';
import 'package:igot_module/modules/utils/module_colors.dart';

class VideoPlayerSkeleton extends StatefulWidget {
  const VideoPlayerSkeleton({Key key}) : super(key: key);

  @override
  _VideoPlayerSkeletonState createState() => _VideoPlayerSkeletonState();
}

class _VideoPlayerSkeletonState extends State<VideoPlayerSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    animation = TweenSequence<Color>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: ModuleColors.grey08,
            end: ModuleColors.grey16,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: ModuleColors.grey08,
            end: ModuleColors.grey16,
          ),
        ),
      ],
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ModuleColors.grey16, width: 1),
        color: animation.value,
      ),
    );
  }
}
