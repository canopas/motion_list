import 'package:animated_reorderable_list/src/animation/provider/animation_effect.dart';
import 'package:flutter/cupertino.dart';

class SlideInUp extends AnimationEffect<Offset> {
  static const Offset beginValue = Offset(0, -1);
  static const Offset endValue = Offset(0, 0);

  SlideInUp(
      {super.delay, super.duration, super.curve, Offset? begin, Offset? end})
      : super(
      begin: begin ?? beginValue,
      end: end ?? endValue);

  @override
  Widget build(BuildContext context, Widget child, Animation<double> animation,
      EffectEntry entry) {
    final Animation<Offset> position = buildAnimation(entry).animate(animation);
    return ClipRect(
      clipBehavior: Clip.hardEdge,
        child: SlideTransition(position: position, child: child));
  }
}


// class SlideInUp extends StatelessWidget {
//   final Widget child;
//   final Animation<double> animation;
//
//   const SlideInUp({Key? key, required this.child, required this.animation})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRect(
//       clipBehavior: Clip.hardEdge,
//       child: SlideTransition(
//         position:
//             Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
//                 .animate(animation),
//         child: child,
//       ),
//     );
//   }
// }
