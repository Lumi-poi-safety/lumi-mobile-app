import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lumi/data/local/user_profile_store.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/widgets/lumi_buttons.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _store = UserProfileStore();
  final _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final p = await _store.load();
    _controller.text = p.name ?? '';
    setState(() => _loading = false);
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    await _store.saveName(_controller.text);
    if (!mounted) return;
    Navigator.of(context).pushNamed(Routes.onboardAge);
  }

  Future<void> _skip() async {
    if (!mounted) return;
    Navigator.of(context).pushNamed(Routes.onboardAge);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0XFFFEFEFE),
                                ),
                                alignment: Alignment.center,
                                child: Image.asset("lib/assets/images/Lumi_f2.png"),
                              ),
                              const SizedBox(height: 30),
                              Text("What should I call you?", style: t.titleLarge),
                              const SizedBox(height: 50),
                              TextField(
                                controller: _controller,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _continue(),
                                decoration: const InputDecoration(hintText: "Your name"),
                              ),
                              SizedBox(height: 50),
                              const Spacer(),
                              LumiPrimaryButton(onPressed: _continue, label: "Continue"),
                              const SizedBox(height: 12),
                              TextButton(onPressed: _skip, child: const Text("Skip")),
                              SizedBox(height: isKeyboardVisible ? 100 : 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
