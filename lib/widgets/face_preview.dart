import 'package:flutter/material.dart';

/// Live makeup preview, ported from the prototype's SVG face.
/// Paints in the original 182x200 coordinate space and scales to fit.
class FacePreview extends StatelessWidget {
  final Color skin;
  final Color? blush;
  final Color? glow;
  final double glowOpacity;
  final Color lip;
  final bool lipShine;

  const FacePreview({
    super.key,
    required this.skin,
    required this.lip,
    this.blush,
    this.glow,
    this.glowOpacity = 0.75,
    this.lipShine = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 182,
      height: 200,
      child: CustomPaint(
        painter: _FacePainter(
          skin: skin,
          blush: blush,
          glow: glow,
          glowOpacity: glowOpacity,
          lip: lip,
          lipShine: lipShine,
        ),
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  final Color skin;
  final Color? blush;
  final Color? glow;
  final double glowOpacity;
  final Color lip;
  final bool lipShine;

  _FacePainter({
    required this.skin,
    required this.blush,
    required this.glow,
    required this.glowOpacity,
    required this.lip,
    required this.lipShine,
  });

  // Original SVG viewBox.
  static const _vbWidth = 182.0;
  static const _vbHeight = 200.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale the 182x200 artwork to whatever box we're given.
    canvas.scale(size.width / _vbWidth, size.height / _vbHeight);

    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // --- hair backdrop ---
    fill.color = const Color(0xFF6A4A3C).withValues(alpha: 0.9);
    final hairBack = Path()
      ..moveTo(91, 8)
      ..cubicTo(45, 8, 33, 48, 33, 92)
      ..cubicTo(33, 150, 55, 196, 91, 196)
      ..cubicTo(127, 196, 149, 150, 149, 92)
      ..cubicTo(149, 48, 137, 8, 91, 8)
      ..close();
    canvas.drawPath(hairBack, fill);

    // --- face + neck ---
    fill.color = skin;
    canvas.drawOval(Rect.fromCenter(center: const Offset(91, 100), width: 104, height: 128), fill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(76, 150, 30, 34), const Radius.circular(12)),
      fill,
    );

    // --- glow / highlight layer (cheekbones + nose) ---
    if (glow != null) {
      fill.color = glow!.withValues(alpha: glowOpacity);
      canvas.drawOval(Rect.fromCenter(center: const Offset(68, 92), width: 22, height: 14), fill);
      canvas.drawOval(Rect.fromCenter(center: const Offset(114, 92), width: 22, height: 14), fill);
      canvas.drawOval(Rect.fromCenter(center: const Offset(91, 104), width: 8, height: 28), fill);
    }

    // --- blush ---
    if (blush != null) {
      fill.color = blush!.withValues(alpha: 0.55);
      canvas.drawOval(Rect.fromCenter(center: const Offset(66, 112), width: 26, height: 18), fill);
      canvas.drawOval(Rect.fromCenter(center: const Offset(116, 112), width: 26, height: 18), fill);
    }

    // --- eyes ---
    fill.color = Colors.white;
    canvas.drawOval(Rect.fromCenter(center: const Offset(71, 92), width: 13, height: 15), fill);
    canvas.drawOval(Rect.fromCenter(center: const Offset(111, 92), width: 13, height: 15), fill);
    fill.color = const Color(0xFF5A3A2E);
    canvas.drawCircle(const Offset(72, 93), 3.6, fill);
    canvas.drawCircle(const Offset(112, 93), 3.6, fill);

    // --- eyebrows ---
    stroke
      ..color = const Color(0xFF6A4A3C)
      ..strokeWidth = 2.4;
    canvas.drawPath(Path()..moveTo(63, 84)..quadraticBezierTo(71, 80, 79, 84), stroke);
    canvas.drawPath(Path()..moveTo(103, 84)..quadraticBezierTo(111, 80, 119, 84), stroke);

    // --- nose ---
    stroke
      ..color = const Color(0xFFD9B49E)
      ..strokeWidth = 2;
    final nose = Path()
      ..moveTo(89, 100)
      ..quadraticBezierTo(88, 114, 84, 120)
      ..quadraticBezierTo(90, 124, 96, 120);
    canvas.drawPath(nose, stroke);

    // --- lips ---
    fill.color = lip;
    final lips = Path()
      ..moveTo(76, 136)
      ..quadraticBezierTo(91, 130, 106, 136)
      ..quadraticBezierTo(98, 146, 91, 146)
      ..quadraticBezierTo(84, 146, 76, 136)
      ..close();
    canvas.drawPath(lips, fill);
    if (lipShine) {
      fill.color = Colors.white.withValues(alpha: 0.8);
      final shine = Path()
        ..moveTo(84, 137)
        ..quadraticBezierTo(91, 134, 98, 137)
        ..quadraticBezierTo(92, 139, 84, 137)
        ..close();
      canvas.drawPath(shine, fill);
    }

    // --- hair front ---
    fill.color = const Color(0xFF7A5443);
    final hairFront = Path()
      ..moveTo(91, 8)
      ..cubicTo(50, 8, 39, 44, 38, 78)
      ..cubicTo(46, 64, 60, 56, 74, 56)
      ..cubicTo(70, 40, 80, 30, 91, 30)
      ..cubicTo(102, 30, 112, 40, 108, 56)
      ..cubicTo(122, 56, 136, 64, 144, 78)
      ..cubicTo(143, 44, 132, 8, 91, 8)
      ..close();
    canvas.drawPath(hairFront, fill);
  }

  @override
  bool shouldRepaint(_FacePainter old) =>
      old.skin != skin ||
      old.blush != blush ||
      old.glow != glow ||
      old.glowOpacity != glowOpacity ||
      old.lip != lip ||
      old.lipShine != lipShine;
}
