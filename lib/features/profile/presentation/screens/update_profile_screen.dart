import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/components/app_text_field.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/utils/validators.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:setra/features/profile/presentation/cubit/profile_states.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, required this.profile});
  final ProfileEntity profile;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _email = TextEditingController(text: widget.profile.email);
    _phone = TextEditingController(text: widget.profile.phoneNumber);
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _update() async {
    if (_formKey.currentState!.validate()) {
      final profileUpdated = widget.profile.copyWith(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _phone.text.trim(),
      );
      await context.read<ProfileCubit>().updateProfile(profileUpdated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            AppTextField(
              controller: _name,
              keyboardType: TextInputType.name,
              validator: (value) => AppValidators.required(value),
            ),
            AppSpacing.h_20.hSpace,
            AppTextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => AppValidators.email(value),
            ),
            AppSpacing.h_20.hSpace,
            AppTextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              hint: '01*********',
              validator: (value) => AppValidators.phone(value),
            ),
            AppSpacing.h_30.hSpace,

            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return AppButton(
                  label: 'Update',
                  onPressed: _update,
                  isLoading: state.status == ProfileStatus.updating,
                );
              },
            ),
          ],
        ).paddingHorizontalVertical(AppSpacing.w_20, AppSpacing.h_24),
      ),
    );
  }
}
