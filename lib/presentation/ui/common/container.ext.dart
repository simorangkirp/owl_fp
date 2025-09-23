import 'package:flutter/material.dart';

extension ContainerButtonStyle on BuildContext {
  BoxDecoration get outlinedButtonBox {
    final style = Theme.of(this).outlinedButtonTheme.style;

    final side = style?.side?.resolve({});
    // final shape = style?.shape?.resolve({}) as RoundedRectangleBorder?;
    final bgColor = style?.backgroundColor?.resolve({});

    return BoxDecoration(
      color: bgColor, // 🎨 fill color
      border: side != null
          ? Border.all(color: side.color, width: side.width)
          : null,
      borderRadius: BorderRadius.circular(4),
    );
  }

  EdgeInsetsGeometry? get outlinedButtonPadding {
    return Theme.of(this).outlinedButtonTheme.style?.padding?.resolve({});
  }

  TextStyle? get outlinedButtonTextStyle {
    return Theme.of(this).outlinedButtonTheme.style?.textStyle?.resolve({});
  }
}
