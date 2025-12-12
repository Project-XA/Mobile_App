import 'package:flutter/material.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/widgets/create_session_form.dart';

class ManageSessionsView extends StatelessWidget {
  const ManageSessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CreateSessionForm()],
      ),
    );
  }
}
