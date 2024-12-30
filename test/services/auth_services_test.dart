import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../lib/services/auth_service.dart';

// FirebaseAuth sınıfını mocklamak için
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('AuthService Tests', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late AuthService authService;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = AuthService(firebaseAuth: mockFirebaseAuth);
    });

    test('signIn should call FirebaseAuth signInWithEmailAndPassword', () async {
      final email = 'test@example.com';
      final password = '123456';
      final mockUserCredential = MockUserCredential();

      // Mock FirebaseAuth response
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async => mockUserCredential);

      await authService.signIn(email, password);

      // Verify signInWithEmailAndPassword is called
      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .called(1);
    });
  });
}
