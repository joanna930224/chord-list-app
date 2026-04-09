import 'package:chord_list_app/features/box/presentation/screens/box_screen.dart';
import 'package:chord_list_app/features/library/presentation/screens/library_screen.dart';
import 'package:chord_list_app/features/my/presentation/screens/my_screen.dart';
import 'package:chord_list_app/features/search/presentation/search_screen.dart';
import 'package:chord_list_app/shared/exports.dart';

class HomeScreen extends StatelessWidget {
  static String get routeName => 'ab2def8e-780f-4f5a-94f4-7d3dfc64f47f';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends HookWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex.value,
        children: const [
          BoxScreen(),
          LibraryScreen(),
          SearchScreen(),
          MyScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex.value,
          onTap: (index) => currentIndex.value = index,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Box',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined),
              activeIcon: Icon(Icons.library_books),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'MY',
            ),
          ],
        ),
      ),
    );
  }
}
