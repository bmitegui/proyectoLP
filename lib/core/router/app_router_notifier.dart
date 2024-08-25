import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_finder/features/user/presentation/bloc/bloc.dart';

class UserBlocListenable extends ChangeNotifier {
  final UserBloc authBloc;
  late final StreamSubscription<UserState> _subscription;

  UserBlocListenable(this.authBloc) {
    _subscription = authBloc.stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
