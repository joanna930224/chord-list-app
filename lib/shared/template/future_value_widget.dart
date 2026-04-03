import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_elevated_button.dart';
import 'package:chord_list_app/shared/template/c_error_widget.dart';
import 'package:chord_list_app/shared/template/c_loading_widget.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';

class FutureValueWidget<T> extends HookWidget {
  const FutureValueWidget(
    this.providers, {
    super.key,
    required this.data,
    this.error,
    this.loading,
    this.isSliver = false,
  });

  final Future<T> providers;
  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget Function()? loading;
  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    final snapshot = useFuture(providers);

    final loadingWidget = useCallback(() {
      final loading = this.loading;

      if (loading != null) {
        return loading();
      }

      return isSliver
          ? const SliverToBoxAdapter(child: CLoadingWidget())
          : const _ScaffoldLoading();
    }, []);

    final errorWidget = useCallback((Object error, StackTrace stackTrace) {
      final widget = this.error;

      if (widget != null) {
        return widget(error, stackTrace);
      }

      return isSliver
          ? SliverToBoxAdapter(
              child: CErrorWidget(error: error, stackTrace: stackTrace),
            )
          : _ScaffoldError(error: error, stackTrace: stackTrace);
    }, []);

    if (snapshot.hasData) {
      return data(snapshot.requireData);
    }

    if (snapshot.hasError) {
      return errorWidget(snapshot.error!, snapshot.stackTrace!);
    }

    return loadingWidget();
  }
}

class _ScaffoldError extends HookWidget {
  const _ScaffoldError({required this.error, required this.stackTrace});

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return CScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.error, size: 30, color: context.colorScheme.error),
          SizedBox(height: 20),
          Text(
            '페이지를 찾을 수 없습니다.',
            textAlign: TextAlign.center,
            style: context.textTheme.regular16,
          ),
          SizedBox(height: 30),
          CElevatedButton(
            backgroundColor: context.colorScheme.onPrimary,
            textColor: context.colorScheme.primary,
            title: '홈으로 이동하기',
            onPressed: () {
              context.go('/');
            },
          ).ph20,
        ],
      ),
    );
  }
}

class _ScaffoldLoading extends StatelessWidget {
  const _ScaffoldLoading();

  @override
  Widget build(BuildContext context) {
    return CScaffold(body: const CLoadingWidget());
  }
}
