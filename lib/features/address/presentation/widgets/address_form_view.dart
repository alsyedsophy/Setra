import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/components/app_text_field.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/utils/utils.dart';
import 'package:setra/features/address/presentation/cubits/address_cubit.dart';
import 'package:setra/features/address/presentation/cubits/address_state.dart';

class AddressFormView extends StatelessWidget {
  const AddressFormView({
    super.key,
    required this._formKey,
    required this._nameCtrl,
    required this._phoneCtrl,
    required this._cityCtrl,
    required this._areaCtrl,
    required this._streetCtrl,
    required this._buildingCtrl,
    required this._notesCtrl,
    required this._isDefault,
    required this._isEdit,
    this._submit,
    this._onDefaultChanged,
  });

  final GlobalKey<FormState> _formKey;
  final TextEditingController _nameCtrl;
  final TextEditingController _phoneCtrl;
  final TextEditingController _cityCtrl;
  final TextEditingController _areaCtrl;
  final TextEditingController _streetCtrl;
  final TextEditingController _buildingCtrl;
  final TextEditingController _notesCtrl;
  final bool _isDefault;
  final bool _isEdit;

  final VoidCallback? _submit;
  final void Function(bool)? _onDefaultChanged;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.successMessage != curr.successMessage,
      listener: (context, state) {
        if (state.status == AddressStatus.success ||
            state.status == AddressStatus.loaded) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.successMessage ?? 'تم الحفظ')),
            );
          context.read<AddressCubit>().clearMessages();
          if (context.canPop()) {
            context.pop();
          }
        } else if (state.status == AddressStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<AddressCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        final isSaving = state.status == AddressStatus.saving;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  prefixIcon: Icons.person_outline, // تم التصحيح هنا
                  enabled: !isSaving,
                  validator: (v) => AppValidators.required(v),
                ),
                AppSpacing.h_12.hSpace,
                AppTextField(
                  controller: _phoneCtrl,
                  label: 'Phone',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  enabled: !isSaving,
                  validator: (v) => AppValidators.phone(v),
                ),
                AppSpacing.h_12.hSpace,
                AppTextField(
                  controller: _cityCtrl,
                  label: 'City / Gover',
                  prefixIcon: Icons.location_city_outlined,
                  enabled: !isSaving,
                  validator: (v) => AppValidators.required(v),
                ),
                AppSpacing.h_12.hSpace,
                AppTextField(
                  controller: _areaCtrl,
                  label: 'Area',
                  prefixIcon: Icons.map_outlined,
                  enabled: !isSaving,
                  validator: (v) => AppValidators.required(v),
                ),
                AppSpacing.h_12.hSpace,
                AppTextField(
                  controller: _streetCtrl,
                  label: 'Streat',
                  prefixIcon: Icons.signpost_outlined,
                  enabled: !isSaving,
                  validator: (v) => AppValidators.required(v),
                ),
                AppSpacing.h_12.hSpace,
                AppTextField(
                  controller: _buildingCtrl,
                  label: 'Building / apartment (choose)',
                  prefixIcon: Icons.home_outlined,
                  enabled: !isSaving,
                ),
                AppSpacing.h_12.hSpace,
                AppTextField(
                  controller: _notesCtrl,
                  label: 'Notes (choose)',
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 3,
                  enabled: !isSaving,
                ),
                AppSpacing.h_12.hSpace,
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('تعيين كعنوان افتراضي'),
                  value: _isDefault,
                  onChanged: isSaving ? null : _onDefaultChanged,
                ),
                AppSpacing.h_24.hSpace,
                AppButton(
                  label: isSaving
                      ? 'جاري الحفظ...'
                      : (_isEdit ? 'حفظ التعديلات' : 'إضافة العنوان'),
                  onPressed: isSaving ? null : _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
