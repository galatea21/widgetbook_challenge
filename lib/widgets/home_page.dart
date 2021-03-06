import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook_challenge/providers/providers.dart';
import 'package:widgetbook_challenge/widgets/language_change_button.dart';
import 'package:widgetbook_challenge/widgets/name_input_field.dart';

/// The app's only page, contains the text input field, submit button and
/// an area that displays result message from the API
class HomePage extends ConsumerStatefulWidget {
  /// Creates a new instance of [HomePage].
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiState = ref.watch(greetingApiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('title').tr(),
        actions: [
          LanguageChangeButton(
            appContext: context,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            NameInputField(
              controller: _controller,
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(greetingApiProvider.notifier)
                    .submitUsername(_controller.text.trim());
              },
              child: const Text('submit').tr(),
            ),
            const SizedBox(height: 100),
            apiState.map(
              initial: (_) {
                _controller.clear();
                return const SizedBox();
              },
              loading: (_) => const CircularProgressIndicator(),
              success: (state) {
                _controller.clear();
                return Text(state.msg);
              },
              error: (state) => Text(state.errorMsg),
            ),
          ],
        ),
      ),
    );
  }
}
