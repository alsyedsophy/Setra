import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/widgets.dart';

import 'package:setra/features/orders/presentation/cubits/order_details_cubit.dart';
import 'package:setra/features/orders/presentation/cubits/order_details_state.dart';

import '../widgets/order_details/order_details_content.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrderDetailsCubit>().watchOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        title: const Text('Order Details'),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: _onStateChanged,
        builder: _buildBody,
      ),
    );
  }

  // ─────────────────────────── Listener ───────────────────────────

  void _onStateChanged(BuildContext context, OrderDetailsState state) {
    if (state is OrderDetailsCancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order cancelled successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }

    if (state is OrderDetailsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.failure.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ─────────────────────────── Body ───────────────────────────

  Widget _buildBody(BuildContext context, OrderDetailsState state) {
    Future<void> onCancel() =>
        context.read<OrderDetailsCubit>().cancelOrder(widget.orderId);

    if (state is OrderDetailsInitial || state is OrderDetailsLoading) {
      return AppLoading();
    }

    if (state is OrderDetailsError) {
      return AppErrorView(
        message: state.failure.message,

        onRetry: () =>
            context.read<OrderDetailsCubit>().watchOrder(widget.orderId),
      );
    }

    if (state is OrderDetailsLoaded) {
      return OrderDetailsContent(order: state.order, onCancelOrder: onCancel);
    }

    if (state is OrderDetailsCancelling) {
      return Stack(
        children: [
          OrderDetailsContent(order: state.order, onCancelOrder: onCancel),
          Container(
            color: Colors.black.withValues(alpha: 0.25),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ],
      );
    }

    if (state is OrderDetailsCancelled) {
      return OrderDetailsContent(order: state.order, onCancelOrder: onCancel);
    }

    return const SizedBox.shrink();
  }
}
