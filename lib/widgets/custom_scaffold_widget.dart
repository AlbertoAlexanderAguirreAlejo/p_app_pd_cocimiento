import 'package:app_pd_cocimiento/widgets/custom_appbar_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_sliver_appbar_widget.dart';
import 'package:flutter/material.dart';

class CustomScaffoldWidget extends StatefulWidget {
  const CustomScaffoldWidget({
    super.key,
    this.appBar,
    required this.title,
    required this.children,
    this.spacing,
    this.bottom,
    this.floatingActionButton,
    this.drawer,
  });

  final PreferredSizeWidget? appBar;
  final String title;
  final List<Widget> children;
  final double? spacing;
  final Widget? bottom;
  final Widget? floatingActionButton;
  final Widget? drawer;

  @override
  State<CustomScaffoldWidget> createState() => _CustomScaffoldWidgetState();
}

class _CustomScaffoldWidgetState extends State<CustomScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar?? const CustomAppBarWidget(),
      drawer: widget.drawer,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBarWidget(titleScreen: widget.title),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: widget.spacing?? 10,
                children: widget.children,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottom,
    );
  }
}