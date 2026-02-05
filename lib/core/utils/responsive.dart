import 'package:flutter/widgets.dart';

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;
}

/// Device type enum
enum DeviceType { mobile, tablet, desktop, largeDesktop }

/// Responsive utility class for adaptive layouts
class Responsive {
  final BuildContext context;
  
  Responsive(this.context);
  
  /// Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;
  
  /// Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;
  
  /// Check if device is mobile (< 600px)
  bool get isMobile => screenWidth < Breakpoints.mobile;
  
  /// Check if device is tablet (600px - 900px)
  bool get isTablet => screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  
  /// Check if device is desktop (900px - 1200px)
  bool get isDesktop => screenWidth >= Breakpoints.tablet && screenWidth < Breakpoints.desktop;
  
  /// Check if device is large desktop (>= 1200px)
  bool get isLargeDesktop => screenWidth >= Breakpoints.desktop;
  
  /// Check if device is mobile or tablet
  bool get isMobileOrTablet => screenWidth < Breakpoints.tablet;
  
  /// Check if device is tablet or desktop
  bool get isTabletOrDesktop => screenWidth >= Breakpoints.mobile;
  
  /// Get current device type
  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    if (isDesktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }
  
  /// Get number of grid columns based on screen size
  int get gridColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    if (isDesktop) return 3;
    return 4; // largeDesktop
  }
  
  /// Get number of grid columns for dashboard cards
  int get dashboardColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }
  
  /// Get horizontal padding based on screen size
  double get horizontalPadding {
    if (isMobile) return 16;
    if (isTablet) return 24;
    if (isDesktop) return 32;
    return 48;
  }
  
  /// Get card width for popups/dialogs
  double get popupWidth {
    if (isMobile) return screenWidth * 0.9;
    if (isTablet) return 420;
    return 500;
  }
  
  /// Get dialog width
  double get dialogWidth {
    if (isMobile) return screenWidth * 0.9;
    if (isTablet) return 400;
    return 500;
  }
  
  /// Get bottom sheet max height percentage
  double get bottomSheetMaxHeightFactor {
    if (isMobile) return 0.9;
    if (isTablet) return 0.7;
    return 0.6;
  }
  
  /// Value based on device type
  T value<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }
}

/// Extension on BuildContext for easy access
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
  
  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  bool get isLargeDesktop => responsive.isLargeDesktop;
  bool get isMobileOrTablet => responsive.isMobileOrTablet;
  bool get isTabletOrDesktop => responsive.isTabletOrDesktop;
  
  DeviceType get deviceType => responsive.deviceType;
  int get gridColumns => responsive.gridColumns;
  int get dashboardColumns => responsive.dashboardColumns;
  double get horizontalPadding => responsive.horizontalPadding;
  double get popupWidth => responsive.popupWidth;
  double get dialogWidth => responsive.dialogWidth;
}

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Responsive responsive) builder;
  
  const ResponsiveBuilder({super.key, required this.builder});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, Responsive(context));
      },
    );
  }
}

/// Widget that shows different layouts based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = Responsive(context);
        
        if (responsive.isLargeDesktop && largeDesktop != null) {
          return largeDesktop!;
        }
        if (responsive.isDesktop && desktop != null) {
          return desktop!;
        }
        if (responsive.isTablet && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}

/// Responsive grid view that automatically adjusts columns
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  
  const ResponsiveGridView({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    int columns;
    if (responsive.isMobile) {
      columns = mobileColumns ?? 1;
    } else if (responsive.isTablet) {
      columns = tabletColumns ?? 2;
    } else {
      columns = desktopColumns ?? 3;
    }
    
    return GridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: _getAspectRatio(responsive, columns),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
  
  double _getAspectRatio(Responsive responsive, int columns) {
    // Adjust aspect ratio based on columns and device
    if (columns == 1) return 2.5;
    if (columns == 2) return 1.8;
    return 1.5;
  }
}

/// Sliver version of responsive grid
class SliverResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double? childAspectRatio;
  final double? mainAxisExtent;
  
  const SliverResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.childAspectRatio,
    this.mainAxisExtent,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    int columns;
    if (responsive.isMobile) {
      columns = mobileColumns ?? 1;
    } else if (responsive.isTablet) {
      columns = tabletColumns ?? 2;
    } else {
      columns = desktopColumns ?? 3;
    }
    
    return SliverGrid(
      gridDelegate: mainAxisExtent != null
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: runSpacing,
              mainAxisExtent: mainAxisExtent,
            )
          : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: runSpacing,
              childAspectRatio: childAspectRatio ?? _getAspectRatio(columns),
            ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => children[index],
        childCount: children.length,
      ),
    );
  }
  
  double _getAspectRatio(int columns) {
    if (columns == 1) return 2.2;
    if (columns == 2) return 1.6;
    return 1.4;
  }
}
