import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockWidget extends StatefulWidget {
  const MockWidget({Key? key}) : super(key: key);

  @override
  _MockWidgetState createState() => _MockWidgetState();
}

class _MockWidgetState extends State<MockWidget> {
  bool isSignedIn = true;

  @override
  Widget build(BuildContext context) {
    return isSignedIn
        ? TextButton(
            onPressed: () {
              Supabase.instance.client.auth.signOut();
            },
            child: const Text('Sign out'),
          )
        : const Text('You have signed out');
  }

  @override
  void initState() {
    SupabaseAuth.instance.onAuthChange.listen((event) {
      if (event == AuthChangeEvent.signedOut) {
        setState(() {
          isSignedIn = false;
        });
      }
    });
    super.initState();
  }
}

class MockLocalStorage extends LocalStorage {
  MockLocalStorage()
      : super(
          initialize: () async {},

          /// Session expires at is at its maximum value for unix timestamp
          accessToken: () async =>
              '{"currentSession":{"access_token":"","expires_in":3600,"refresh_token":"","user":{"id":"","aud":"","created_at":"","role":"authenticated","updated_at":""}},"expiresAt":2147483647}',
          persistSession: (_) async {},
          removePersistedSession: () async {},
          hasAccessToken: () async => true,
        );
}

// Register the mock handler for uni_links
void mockAppLink() {
  const channel = MethodChannel('com.llfbandit.app_links/messages');
  TestWidgetsFlutterBinding.ensureInitialized();

  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) {
    return null;
  });
}
