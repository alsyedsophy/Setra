import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/components.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/widgets/widgets.dart';

import 'package:setra/features/orders/presentation/cubits/orders_cubit.dart';
import 'package:setra/features/orders/presentation/cubits/orders_state.dart';

import '../widgets/orders_list.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrdersCubit>().watchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: _onStateChanged,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            title: Text('My Orders', style: context.textTheme.titleLarge),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  // ─────────────────────────── Listener ───────────────────────────

  void _onStateChanged(BuildContext context, OrdersState state) {
    if (state is OrderCancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order cancelled successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (state is OrdersError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.failure.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─────────────────────────── Body ───────────────────────────

  Widget _buildBody(BuildContext context, OrdersState state) {
    if (state is OrdersInitial || state is OrdersLoading) {
      return AppLoading();
    }

    if (state is OrdersEmpty) {
      return AppEmptyView(message: 'No Orders yet');
    }

    if (state is OrdersError) {
      return AppErrorView(
        message: state.failure.message,
        onRetry: () => context.read<OrdersCubit>().watchOrders(),
      );
    }

    if (state is OrdersLoaded) {
      return OrdersList(orders: state.orders);
    }

    if (state is OrderCancelling) {
      return OrdersList(orders: state.orders, cancellingOrderId: state.orderId);
    }

    if (state is OrderCancelled) {
      return OrdersList(orders: state.orders);
    }

    return const SizedBox.shrink();
  }
}
