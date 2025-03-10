import 'package:flutter/material.dart';

/// Decoration track if switch in ON position
BoxDecoration defaultDecorationTrackOn = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26)),
  color: const Color(0xFF3CB528),
);

/// Decoration track if switch in OFF position
BoxDecoration defaultDecorationTrackOff = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26)),
  color: const Color(0xFFCA271D),
);

/// Decoration track if switch in WAIT position
BoxDecoration defaultDecorationTrackWait = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26)),
  color: const Color(0xFF908E93),
);

/// Decoration track if switch is Disabled
BoxDecoration defaultDecorationTrackDisabled = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF908393)),
  color: const Color(0xFF908E93),
);

/// Decoration slider if switch in ON position
BoxDecoration defaultDecorationSliderOn = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFFF4F4F4),
);

/// Decoration slider if switch in OFF position
BoxDecoration defaultDecorationSliderOff = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFFF4F4F4),
);

/// Decoration slider if switch in WAIT position
BoxDecoration defaultDecorationSliderWait = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFFF4F4F4),
);

/// Decoration slider if switch is Disabled
BoxDecoration defaultDecorationSliderDisabled = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF908393), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFF908E93),
);

// const TextStyle defaultTextStyleEnabled = TextStyle(
//   color: Color(0xFF58565C),
//   fontSize: 13,
// );
//
// const TextStyle defaultTextStyleDisabled = TextStyle(
//   color: Color(0xFF908E93),
//   fontSize: 13,
// );