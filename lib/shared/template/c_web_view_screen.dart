import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CWebViewScreen extends HookWidget {
  static String get routeName => 'c-web-view-screen';

  const CWebViewScreen({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);
    final controller = useMemoized(() {
      final wvc = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => isLoading.value = true,
            onPageFinished: (_) => isLoading.value = false,
          ),
        );
      if (url.isNotEmpty) wvc.loadRequest(Uri.parse(url));
      return wvc;
    });

    if (url.isEmpty) {
      return CScaffold(
        title: Text(title),
        body: const Center(child: Text('준비 중입니다.')),
      );
    }

    return CScaffold(
      title: Text(title),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading.value) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
