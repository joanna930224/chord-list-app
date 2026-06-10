import 'package:chord_list_app/features/box/presentation/widgets/box_sort_button_widget.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_image.dart';

class BoxAppBar extends HookConsumerWidget {
  final ScrollController scrollController;

  const BoxAppBar({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAtTop = useState(true);

    useEffect(() {
      void onScroll() {
        final atTop = scrollController.offset <= 0;
        if (atTop != isAtTop.value) {
          isAtTop.value = atTop;
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      flexibleSpace: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: isAtTop.value
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1A5A4FCF), Colors.transparent],
                  stops: [0.0, 1.0],
                )
              : null,
          color: isAtTop.value ? null : context.colorScheme.onInverseSurface,
        ),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: CImage(
          'assets/icons/chordbox_logo.svg',
          width: 100,
          color: context.colorScheme.primary,
        ),
      ),
      actions: const [
        BoxSortButtonWidget(),
        SizedBox(width: 8),
      ],
      centerTitle: false,
      automaticallyImplyLeading: false,
    );
  }
}
