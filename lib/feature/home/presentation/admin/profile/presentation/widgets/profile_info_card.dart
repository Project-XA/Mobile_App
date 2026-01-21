import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/data/service/dialog_service.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/info_card.dart';

class FirstNameCard extends StatelessWidget {
  final String firstNameAr;

  const FirstNameCard({super.key, required this.firstNameAr});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.person,
      label: 'First Name',
      value: firstNameAr,
      onEdit: null,
      //showEditDialog(
      //   context,
      //   'First Name',
      //   firstNameAr,
      //   (newValue) => context.read<UserProfileCubit>().updateUser(
      //         firstNameAr: newValue,
      //       ),
      // ),
    );
  }
}

class LastNameCard extends StatelessWidget {
  final String lastNameAr;

  const LastNameCard({super.key, required this.lastNameAr});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.person_outline,
      label: 'Last Name',
      value: lastNameAr,
      onEdit: null,
      // () => showEditDialog(
      //   context,
      //   'Last Name',
      //   lastNameAr,
      //   (newValue) =>
      //       context.read<UserProfileCubit>().updateUser(lastNameAr: newValue),
      // ),
    );
  }
}

class EmailCard extends StatelessWidget {
  final String email;

  const EmailCard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.email,
      label: 'Email',
      value: email,
      onEdit: null,
      // () => showEditDialog(
      //   context,
      //   'Email',
      //   email,
      //   (newValue) =>
      //       context.read<UserProfileCubit>().updateUser(email: newValue),
      // ),
    );
  }
}

class NationalIdCard extends StatelessWidget {
  final String nationalId;

  const NationalIdCard({super.key, required this.nationalId});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.badge,
      label: 'National ID',
      value: nationalId,
      onEdit: null,
    );
  }
}

class AddressCard extends StatelessWidget {
  final String address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.location_on,
      label: 'Address',
      value: address,
      onEdit: () => showEditDialog(
        context,
        'Address',
        address,
        (newValue) =>
            context.read<CurrentUserCubit>().updateUser(address: newValue),
      ),
    );
  }
}

class BirthDateCard extends StatelessWidget {
  final String birthDate;

  const BirthDateCard({super.key, required this.birthDate});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.cake,
      label: 'Birth Date',
      value: birthDate,
      onEdit: null,
    );
  }
}
