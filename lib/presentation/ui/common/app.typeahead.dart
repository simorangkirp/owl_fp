// lib/widgets/app_type_ahead_field.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart' as ft;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTypeAheadField<T> extends StatelessWidget {
  final TextEditingController? controller;

  /// Sesuaikan dengan typedef versi 5.x
  final FutureOr<List<T>?> Function(String pattern) suggestionsCallback;

  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T) onSuggestionSelected;

  // final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool enabled;
  final Widget Function(BuildContext)? noItemsFoundBuilder;
  final double suggestionsBoxMaxHeight;

  const AppTypeAheadField({
    super.key,
    this.controller,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    // this.labelText,
    this.hintText,
    this.validator,
    this.decoration,
    this.keyboardType,
    this.enabled = true,
    this.noItemsFoundBuilder,
    this.suggestionsBoxMaxHeight = 280,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final InputDecoration effectiveDecoration = decoration ??
        InputDecoration(
          // labelText: labelText,
          hintText: hintText,
          labelStyle: theme.inputDecorationTheme.labelStyle,
          border: theme.inputDecorationTheme.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
          enabledBorder: theme.inputDecorationTheme.enabledBorder,
          focusedBorder: theme.inputDecorationTheme.focusedBorder,
          filled: theme.inputDecorationTheme.filled,
          fillColor: theme.inputDecorationTheme.fillColor,
          contentPadding: theme.inputDecorationTheme.contentPadding ??
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        );

    return ft.TypeAheadField<T>(
      controller: controller,
      builder: (BuildContext ctx, TextEditingController textController,
          FocusNode focusNode) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8.r),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26,
            //     blurRadius: 6.r,
            //     offset: Offset(0, 3.h),
            //   ),
            // ],
          ),
          child: TextFormField(
            controller: textController,
            focusNode: focusNode,
            decoration: effectiveDecoration.copyWith(border: InputBorder.none),
            keyboardType: keyboardType,
            enabled: enabled,
            validator: validator,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        );
      },

      // Sesuaikan return type List<T>? sesuai versi 5.x
      suggestionsCallback: (pattern) async {
        final result = await suggestionsCallback(pattern);
        return result ?? <T>[]; // fallback biar ga null
      },

      itemBuilder: (ctx, suggestion) => itemBuilder(ctx, suggestion),
      onSelected: (s) => onSuggestionSelected(s),

      emptyBuilder: noItemsFoundBuilder ??
          (ctx) => Padding(
                padding: EdgeInsets.all(12.w),
                child: Text(
                  'Tidak ditemukan',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
                ),
              ),
      constraints: BoxConstraints(
        maxHeight: suggestionsBoxMaxHeight.h,
      ),
    );
  }
}
