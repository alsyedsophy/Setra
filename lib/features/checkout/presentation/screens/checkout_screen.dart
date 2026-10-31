import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/address/presentation/cubits/address_cubit.dart';
import 'package:setra/features/address/presentation/cubits/address_state.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/checkout/domain/entities/checkout_request_entity.dart';
import 'package:setra/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:setra/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

import '../widgets/address/address_picker_sheet.dart';
import '../widgets/checkout_bottom_bar.dart';
import '../widgets/checkout_message.dart';
import '../widgets/order_items_section.dart';
import '../widgets/order_summary_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/address/shipping_address_section.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutScreen> {
  PaymentMethod _paymentMethod = PaymentMethod.cashOnDelivery;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final addressCubit = context.read<AddressCubit>();
      if (addressCubit.state.status == AddressStatus.initial) {
        addressCubit.loadAddresses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: _onCheckoutStateChanged,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Checkout', style: context.textTheme.titleLarge),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) => _buildBody(cartState),
        ),
      ),
    );
  }

  // ─────────────────────────── Listener ───────────────────────────

  void _onCheckoutStateChanged(BuildContext context, CheckoutState state) {
    final isSubmitting = state is CheckoutLoading;
    if (_isSubmitting != isSubmitting) {
      setState(() => _isSubmitting = isSubmitting);
    }

    if (state is CheckoutSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الطلب بنجاح'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      // TODO: انتقل إلى تفاصيل الطلب بعد ربط مسار Orders في GoRouter.
    }

    if (state is CheckoutFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.failure.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─────────────────────────── Body ───────────────────────────

  Widget _buildBody(CartState cartState) {
    if (cartState.status == CartStatus.loading ||
        cartState.status == CartStatus.initial) {
      return const AppLoading();
    }

    if (cartState.status == CartStatus.unAuthintecated) {
      return const CheckoutMessage(
        icon: Icons.lock_outline,
        title: 'Login required',
        message: 'Please log in to continue with your order.',
      );
    }

    final cart = cartState.cartEntity;
    if (cart == null || cart.items.isEmpty) {
      return const CheckoutMessage(
        icon: Icons.shopping_bag_outlined,
        title: 'Your cart is empty',
        message: 'Add products to your cart before checking out.',
      );
    }

    if (cartState.status == CartStatus.validating) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Checking product availability...'),
          ],
        ),
      );
    }

    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, addressState) {
        if (addressState.status == AddressStatus.initial ||
            addressState.status == AddressStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (addressState.status == AddressStatus.unAuthenticated) {
          return const CheckoutMessage(
            icon: Icons.lock_outline,
            title: 'Login required',
            message: 'Please log in to select a shipping address.',
          );
        }

        if (addressState.status == AddressStatus.error) {
          return CheckoutMessage(
            icon: Icons.error_outline,
            title: 'Unable to load addresses',
            message: addressState.errorMessage ?? 'Please try again.',
            onRetry: () => context.read<AddressCubit>().loadAddresses(),
          );
        }

        return _buildCheckoutContent(
          cart: cart,
          cartState: cartState,
          addresses: addressState.addresses,
          selectedAddress: addressState.selectedAddress,
        );
      },
    );
  }

  Widget _buildCheckoutContent({
    required CartEntity cart,
    required CartState cartState,
    required List<AddressEntity> addresses,
    required AddressEntity? selectedAddress,
  }) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ShippingAddressSection(
                  addresses: addresses,
                  // addresses: [],
                  selectedAddress: selectedAddress,
                  // selectedAddress: null,
                  onChange: () =>
                      _showAddressPicker(addresses, selectedAddress),
                  onSelect: () =>
                      _showAddressPicker(addresses, selectedAddress),
                ),
                AppSpacing.h_16.hSpace,
                OrderItemsSection(
                  cart: cart,
                  productNameOf: (productId) =>
                      cartState.productsById[productId]?.name ?? 'Product',
                ),
                AppSpacing.h_16.hSpace,
                PaymentMethodSection(
                  paymentMethod: _paymentMethod,
                  onChanged: (method) =>
                      setState(() => _paymentMethod = method),
                ),
                const SizedBox(height: 16),
                OrderSummarySection(cart: cart),
              ],
            ),
          ),
          CheckoutBottomBar(
            total: cart.totalPrice,
            isSubmitting: _isSubmitting,
            enabled:
                selectedAddress != null &&
                cart.items.isNotEmpty &&
                cartState.status == CartStatus.loaded,
            onPlaceOrder: () {
              if (selectedAddress == null) {
                _showMessage('Please select a shipping address.');
                return;
              }
              _submitOrder(selectedAddress);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── Actions ───────────────────────────

  Future<void> _submitOrder(AddressEntity address) async {
    if (_isSubmitting) return;

    final cart = context.read<CartCubit>().state.cartEntity;
    if (cart == null || cart.items.isEmpty) {
      _showMessage('Your cart is empty.');
      return;
    }

    await context.read<CheckoutCubit>().placeOrder(
      CheckoutRequestEntity(
        shippingAddress: address,
        paymentMethod: _paymentMethod,
      ),
    );
  }

  void _showAddressPicker(
    List<AddressEntity> addresses,
    AddressEntity? selectedAddress,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => AddressPickerSheet(
        addresses: addresses,
        selectedAddress: selectedAddress,
        onAddressSelected: (address) =>
            context.read<AddressCubit>().selectAddress(address),
        onAddNewAddress: () {
          // TODO: انتقل إلى شاشة إضافة عنوان.
        },
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
