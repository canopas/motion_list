import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'builder/motion_list_base.dart';
import 'builder/motion_list_impl.dart';

///  enterTransition: [FadeEffect(), ScaleEffect()],
///
/// Effects are always run in parallel (ie. the fade and scale effects in the
/// example above would be run simultaneously), but you can apply delays to
/// offset them or run them in sequence.
/// A Flutter AnimatedGridView that animates insertion and removal of the item.
class AnimatedListView<E extends Object> extends StatelessWidget {
  /// The current list of items that this[MotionListViewBuilder] should represent.
  final List<E> items;

  ///Called, as needed, to build list item widget
  final ItemBuilder itemBuilder;

  ///List of [AnimationEffect](s) used for the appearing animation when an item was inserted into the list.
  ///
  ///Defaults to [FadeAnimation()]
  final List<AnimationEffect>? enterTransition;

  ///List of [AnimationEffect](s) used for the disappearing animation when an item was removed from the list.
  ///
  ///Defaults to [FadeAnimation()]
  final List<AnimationEffect>? exitTransition;

  /// The duration of the animation when an item was inserted into the list.
  ///
  /// If you provide a specific duration for each AnimationEffect, it will override this [insertDuration].
  final Duration? insertDuration;

  /// The duration of the animation when an item was removed from the list.
  ///
  /// If you provide a specific duration for each AnimationEffect, it will override this [removeDuration].
  final Duration? removeDuration;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// [ScrollController] to get the current scroll position.
  ///
  ///  Must be null if [primary] is true.
  ///
  ///  It can be used to read the current
  //   scroll position (see [ScrollController.offset]), or change it (see
  //   [ScrollController.animateTo]).
  final ScrollController? controller;

  /// When this is true, the scroll view is scrollable even if it does not have
  /// sufficient content to actually scroll. Otherwise, by default the user can
  /// only scroll the view if it has sufficient content. See [physics].
  ///
  /// Cannot be true while a [ScrollController] is provided to `controller`,
  /// only one ScrollController can be associated with a ScrollView.
  ///
  /// Defaults to null.
  final bool? primary;

  /// {@template flutter.widgets.reorderable_list.padding}
  /// The amount of space by which to inset the list contents.
  ///
  /// It defaults to `EdgeInsets.all(0)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions. Furthermore, if [primary] is
  /// false, then the user cannot scroll if there is insufficient content to
  /// scroll, while if [primary] is true, they can always attempt to scroll.
  final ScrollPhysics? physics;

  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final String? restorationId;

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Defaults to [Clip.hardEdge].
  ///
  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final Clip clipBehavior;

  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final DragStartBehavior dragStartBehavior;

  /// A custom builder that is for adding items with animations.
  ///
  /// The `context` argument is the build context where the widget will be
  /// created, the `index` is the index of the item to be built, and the
  /// `animation` is an [Animation] that should be used to animate an entry
  /// transition for the widget that is built.
  final AnimatedWidgetBuilder? insertItemBuilder;

  /// A custom builder that is for removing items with animations.
  ///
  /// The `context` argument is the build context where the widget will be
  /// created, the `index` is the index of the item to be built, and the
  /// `animation` is an [Animation] that should be used to animate an exit
  /// transition for the widget that is built.
  final AnimatedWidgetBuilder? removeItemBuilder;

  /// Whether the extent of the scroll view in the scrollDirection should be determined by the contents being viewed.
  final bool shrinkWrap;

  /// A callback function to determine if two items in the list are considered the same.
  ///
  /// This function is important to prevent unnecessary animations when editing or updating items.
  /// For example, if your items have a unique `id`, you can use this function to compare them
  /// and return `true`, indicating they represent the same item.
  ///
  ///
  /// **Why is this important?**
  ///
  /// If `isSameItem` is not defined and you are working with immutable objects (e.g., creating new
  /// instances on every update), the library may interpret these as different items. This will
  /// trigger animations unnecessarily. Additionally, if you are generating `Key` values directly
  /// from these instances, it can result in the following exception:
  ///
  /// `Multiple widgets used the same GlobalKey.`
  ///
  /// To avoid this exception, you must implement the `isSameItem` callback to accurately compare
  /// the identity of the items in your list.
  ///
  /// Example:
  /// ```dart
  /// isSameItem: (a, b) => a.id == b.id,
  /// ```
  final bool Function(E a, E b)? isSameItem;

  /// Whether to enable swap animation when changing the order of the items.
  ///
  /// Defaults to true.
  final bool enableSwap;

  /// Creates a [AnimatedListView] that animates insertion and removal of the item.
  const AnimatedListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.enterTransition,
    this.exitTransition,
    this.insertDuration,
    this.removeDuration,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.insertItemBuilder,
    this.removeItemBuilder,
    this.shrinkWrap = false,
    required this.isSameItem,
    this.enableSwap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        scrollBehavior: scrollBehavior,
        restorationId: restorationId,
        keyboardDismissBehavior: keyboardDismissBehavior,
        dragStartBehavior: dragStartBehavior,
        clipBehavior: clipBehavior,
        shrinkWrap: shrinkWrap,
        slivers: [
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: MotionListImpl(
              items: items,
              itemBuilder: itemBuilder,
              enterTransition: enterTransition,
              exitTransition: exitTransition,
              insertDuration: insertDuration,
              removeDuration: removeDuration,
              scrollDirection: scrollDirection,
              insertItemBuilder: insertItemBuilder,
              removeItemBuilder: removeItemBuilder,
              isSameItem: isSameItem,
              enableSwap: enableSwap,
            ),
          ),
        ]);
  }
}
