import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/supply.dart';

void main() {
  test('Firestore save and fetch supply', () async {
    final fakeFirestore = FakeFirebaseFirestore();

    // Supply verisi ekle
    final supplyData = {
      'name': 'Tedarik 1',
      'description': 'Bu bir test tedarikidir',
    };

    await fakeFirestore.collection('supplies').doc('supply1').set(supplyData);

    // Firestore'dan veri çek
    final snapshot = await fakeFirestore.collection('supplies').doc('supply1').get();

    // Kontrol yap
    expect(snapshot.exists, true);
    expect(snapshot.data()?['name'], 'Tedarik 1');
  });
}
