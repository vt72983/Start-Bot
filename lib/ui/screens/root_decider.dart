import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/storage/secure_storage_provider.dart';
import 'token_screen.dart';

class RootDeciderScreen extends ConsumerStatefulWidget {
  const RootDeciderScreen({super.key});

  @override
  ConsumerState<RootDeciderScreen> createState() => _RootDeciderScreenState();
}

class _RootDeciderScreenState extends ConsumerState<RootDeciderScreen> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.readToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      context.go('/control');
    } else {
      context.go('/token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}


