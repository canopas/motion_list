import 'package:animated_reorderable_list/src/animation/provider/animation_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';

import 'motion_animated_builder.dart';

class MotionListImpl<E extends Object> extends MotionListBase<Widget, E> {
  MotionListImpl({
    Key? key,
    required List<E> items,
    required ItemBuilder itemBuilder,
    List<AnimationEffect>? enterTransition,
    List<AnimationEffect>? exitTransition,
    Duration? insertDuration,
    Duration? removeDuration,
    Axis? scrollDirection,
    AnimationType? insertAnimationType,
    AnimationType? removeAnimationType,
    EqualityChecker<E>? areItemsTheSame,
  }) : super(
            key: key,
            items: items,
            itemBuilder: itemBuilder,
            insertDuration: insertDuration,
            removeDuration: removeDuration,
            enterTransition: enterTransition,
            exitTransition: exitTransition,
            scrollDirection: scrollDirection,
            areItemsTheSame: areItemsTheSame,
            insertAnimationType: insertAnimationType,
            removeAnimationType: removeAnimationType);

  MotionListImpl.grid({
    Key? key,
    required List<E> items,
    required ItemBuilder itemBuilder,
    required SliverGridDelegate sliverGridDelegate,
    List<AnimationEffect>? enterTransition,
    List<AnimationEffect>? exitTransition,
    Duration? insertDuration,
    Duration? removeDuration,
    Axis? scrollDirection,
  }) : super(
            key: key,
            items: items,
            itemBuilder: itemBuilder,
            sliverGridDelegate: sliverGridDelegate,
            enterTransition: enterTransition,
            exitTransition: exitTransition,
            insertDuration: insertDuration,
            removeDuration: removeDuration,
            scrollDirection: scrollDirection,
            );

  @override
  MotionListImplState<E> createState() => MotionListImplState<E>();
}

class MotionListImplState<E extends Object>
    extends MotionListBaseState<Widget, MotionListImpl<E>, E> {
  @override
  Widget build(BuildContext context) {
    return MotionBuilder(
      key: listKey,
      initialCount: oldList.length,
      insertAnimationBuilder: insertItemBuilder,
      removeAnimationBuilder: removeItemBuilder,
      itemBuilder: itemBuilder,
      scrollDirection: scrollDirection,
      delegateBuilder: sliverGridDelegate,
    );
  }
}
