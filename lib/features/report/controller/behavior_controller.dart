import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/behavior_model.dart';
import '../service/behavior_service.dart';

final behaviorProvider =
    StateNotifierProvider<
      BehaviorController,
      AsyncValue<List<BehaviorModel>>
    >((ref) => BehaviorController());

class BehaviorController
    extends StateNotifier<AsyncValue<List<BehaviorModel>>> {
  BehaviorController() : super(const AsyncLoading()) {
    fetchBehaviors();
  }

  final _service = BehaviorService();

  Future<void> fetchBehaviors() async {
    try {
      state = const AsyncLoading();
      final clinicalSings = await _service.getBehavior();
      state = AsyncData(clinicalSings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
