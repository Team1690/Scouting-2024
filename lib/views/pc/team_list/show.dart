import "package:flutter/material.dart";

DataCell show(final num value, [final bool isPercent = false]) => DataCell(
      Text(
        value.isNaN || value.isInfinite || value == -1
            ? "No data"
            : "${value.toStringAsFixed(2)}${isPercent ? "%" : ""}",
      ),
    );
