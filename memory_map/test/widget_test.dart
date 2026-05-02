import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memory_map/app/app.dart';

void main() {
  testWidgets('renders root shell with five tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MemoryMapApp()));
    await tester.pump();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Plan'), findsWidgets);
    expect(find.text('Current'), findsWidgets);
    expect(find.text('My Trips'), findsWidgets);
    expect(find.text('Memories'), findsWidgets);
  });
}
