import 'package:flutter/material.dart';

BoxDecoration defaultDecorationTrackOn = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26)),
  color: const Color(0xFF3CB528),
);

BoxDecoration defaultDecorationTrackOff = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26)),
  color: const Color(0xFFCA271D),
);

BoxDecoration defaultDecorationTrackWait = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26)),
  color: const Color(0xFF908E93),
);

BoxDecoration defaultDecorationTrackDisabled = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF908393)),
  color: const Color(0xFF908E93),
);

BoxDecoration defaultDecorationSliderOn = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFFF4F4F4),
);

BoxDecoration defaultDecorationSliderOff = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFFF4F4F4),
);

BoxDecoration defaultDecorationSliderWait = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF201D26), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFFF4F4F4),
);

BoxDecoration defaultDecorationSliderDisabled = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF908393), strokeAlign: BorderSide.strokeAlignOutside),
  color: const Color(0xFF908E93),
);

const TextStyle defaultTextStyleEnabled = TextStyle(
  color: Color(0xFF58565C),
  fontSize: 13,
);

const TextStyle defaultTextStyleDisabled = TextStyle(
  color: Color(0xFF908E93),
  fontSize: 13,
);