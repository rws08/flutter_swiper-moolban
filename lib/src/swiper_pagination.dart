import 'package:flutter/material.dart';
import 'package:flutter_swiper_moolban/flutter_swiper_moolban.dart';

class FractionPaginationBuilder extends SwiperPlugin {
  ///color ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///color when active,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ////font size
  final double fontSize;

  ///font size when active
  final double activeFontSize;

  final Key? key;

  const FractionPaginationBuilder({
    this.color,
    this.fontSize = 20.0,
    this.key,
    this.activeColor,
    this.activeFontSize = 35.0,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    int itemCount = config.itemCount;
    if (itemCount <= 1) {
      return Container();
    }

    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    if (Axis.vertical == config.scrollDirection) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${config.activeIndex + 1}",
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          Text(
            "/",
            style: TextStyle(color: color, fontSize: fontSize),
          ),
          Text(
            "$itemCount",
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${config.activeIndex + 1}",
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          Text(
            " / $itemCount",
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    }
  }
}

class RectSwiperPaginationBuilder extends SwiperPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  /// Space between rects
  final double space;

  final Key? key;

  const RectSwiperPaginationBuilder({
    this.activeColor,
    this.color,
    this.key,
    this.size = const Size(10.0, 3.0),
    this.activeSize = const Size(10.0, 3.0),
    this.space = 2.0,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    int itemCount = config.itemCount;
    if (itemCount <= 1) {
      return Container();
    }

    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    List<Widget> list = [];

    int activeIndex = config.activeIndex;
    if (itemCount > 20) {
      debugPrint(
          "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this situation");
    }

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      Size size = active ? activeSize : this.size;
      list.add(Container(
        width: size.width,
        height: size.height,
        key: Key("pagination_$i"),
        margin: EdgeInsets.all(space),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.5),
          color: active ? activeColor : color,
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}

class DotSwiperPaginationBuilder extends SwiperPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the dot when activate
  final double activeSize;

  ///Size of the dot
  final double size;

  /// Space between dots
  final double space;

  final Key? key;

  const DotSwiperPaginationBuilder({
    this.activeColor,
    this.color,
    this.key,
    this.size = 10.0,
    this.activeSize = 10.0,
    this.space = 3.0,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    int itemCount = config.itemCount;
    if (itemCount <= 1) {
      return Container();
    }

    if (config.itemCount > 20) {
      debugPrint(
          "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
    }
    Color? activeColor = this.activeColor;
    Color? color = this.color;

    if (activeColor == null || color == null) {
      ThemeData themeData = Theme.of(context);
      activeColor = this.activeColor ?? themeData.primaryColor;
      color = this.color ?? themeData.scaffoldBackgroundColor;
    }

    if (config.indicatorLayout != PageIndicatorLayout.NONE &&
        config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: config.itemCount,
        controller: config.pageController!,
        layout: config.indicatorLayout,
        size: size,
        activeColor: activeColor,
        color: color,
        space: space,
      );
    }

    List<Widget> list = [];

    int? activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      list.add(Container(
        key: Key("pagination_$i"),
        margin: EdgeInsets.all(space),
        child: ClipOval(
          child: Container(
            color: active ? activeColor : color,
            width: active ? activeSize : size,
            height: active ? activeSize : size,
          ),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}

typedef SwiperPaginationBuilder = Widget Function(
    BuildContext context, SwiperPluginConfig config);

class SwiperCustomPagination extends SwiperPlugin {
  final SwiperPaginationBuilder builder;

  const SwiperCustomPagination({required this.builder});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return builder(context, config);
  }
}

class SwiperPagination extends SwiperPlugin {
  /// dot style pagination
  static const SwiperPlugin dots = DotSwiperPaginationBuilder();

  /// fraction style pagination
  static const SwiperPlugin fraction = FractionPaginationBuilder();

  /// round rect style pagination
  static const SwiperPlugin rect = RectSwiperPaginationBuilder();

  /// Alignment.bottomCenter by default when scrollDirection== Axis.horizontal
  /// Alignment.centerRight by default when scrollDirection== Axis.vertical
  final Alignment? alignment;

  /// Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  /// Build the widget
  final SwiperPlugin builder;

  final Key? key;

  const SwiperPagination({
    this.alignment,
    this.key,
    this.margin = const EdgeInsets.all(10.0),
    this.builder = SwiperPagination.dots,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    Alignment defaultAlignment = config.scrollDirection == Axis.horizontal
        ? Alignment.bottomCenter
        : Alignment.centerRight;
    Widget child = Container(
      margin: margin,
      child: builder.build(context, config),
    );
    if (!config.outer!) {
      child = Align(
        key: key,
        alignment: alignment ?? defaultAlignment,
        child: child,
      );
    }
    return child;
  }
}
