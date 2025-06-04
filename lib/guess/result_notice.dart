import 'package:flutter/material.dart';

class ResultNotice extends StatefulWidget {
  final Color color;
  final String info;

  const ResultNotice({
    Key? key,
    required this.color,
    required this.info,
  }) : super(key: key);

  @override
  State<ResultNotice> createState() => _ResultNoticeState();
}

class _ResultNoticeState extends State<ResultNotice> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(ResultNotice oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 只要当前需要显示提示（info 非空），就重新播放动画
    if (widget.info.isNotEmpty) {
      controller
        ..reset()
        ..forward();
    } else {
      controller.reset();
    }
    // if (widget.info.isNotEmpty && oldWidget.info.isEmpty) {
    //   controller.forward(from: 0); // 从 0 开始播放动画
    // } else if (widget.info.isEmpty) {
    //   controller.reset(); // 重置动画
    // }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: widget.color,
      child: AnimatedBuilder(
          animation: controller,
          builder: (_,child) =>Text(
            widget.info,
            style: TextStyle(
                fontSize: 54 * (controller.value),
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
      )
    );
  }
}
