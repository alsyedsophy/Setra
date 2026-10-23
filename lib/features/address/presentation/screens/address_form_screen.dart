import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/presentation/cubits/address_cubit.dart';
import 'package:setra/features/address/presentation/widgets/address_form_view.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key, this.address});

  final AddressEntity? address;

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _buildingCtrl;
  late final TextEditingController _notesCtrl;
  bool _isDefault = false;

  bool get _isEdit => widget.address != null;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _nameCtrl = TextEditingController(text: a?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: a?.phone ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? '');
    _areaCtrl = TextEditingController(text: a?.area ?? '');
    _streetCtrl = TextEditingController(text: a?.street ?? '');
    _buildingCtrl = TextEditingController(text: a?.building ?? '');
    _notesCtrl = TextEditingController(text: a?.notes ?? '');
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _areaCtrl.dispose();
    _streetCtrl.dispose();
    _buildingCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<AddressCubit>();
    final buildingText = _buildingCtrl.text.trim();
    final notesText = _notesCtrl.text.trim();

    if (_isEdit) {
      final updated = widget.address!.copyWith(
        fullName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        area: _areaCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        building: buildingText.isEmpty ? null : buildingText,
        notes: notesText.isEmpty ? null : notesText,
        isDefault: _isDefault,
        clearBuilding: buildingText.isEmpty,
        clearNotes: notesText.isEmpty,
      );
      cubit.updateAddress(updated);
    } else {
      cubit.addAddress(
        fullName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        area: _areaCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        building: buildingText.isEmpty ? null : buildingText,
        notes: notesText.isEmpty ? null : notesText,
        isDefault: _isDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Address' : 'New Address'),
        centerTitle: true,
      ),
      body: AddressFormView(
        formKey: _formKey,
        nameCtrl: _nameCtrl,
        phoneCtrl: _phoneCtrl,
        cityCtrl: _cityCtrl,
        areaCtrl: _areaCtrl,
        streetCtrl: _streetCtrl,
        buildingCtrl: _buildingCtrl,
        notesCtrl: _notesCtrl,
        isDefault: _isDefault,
        isEdit: _isEdit,
        submit: _submit,
        onDefaultChanged: (v) => setState(() => _isDefault = v),
      ),
    );
  }
}
