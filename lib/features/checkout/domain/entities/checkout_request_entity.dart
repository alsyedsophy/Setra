import 'package:equatable/equatable.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';
import 'package:setra/features/orders/domain/entities/order_status.dart';

class CheckoutRequestEntity extends Equatable {
  final AddressEntity shippingAddress;
  final PaymentMethod paymentMethod;

  const CheckoutRequestEntity({
    required this.shippingAddress,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [shippingAddress, paymentMethod];
}
