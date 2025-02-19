import 'package:practice_7/presentation/screens/navigationBar/navigation_bar.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/presentation/screens/screen.dart';

var appRoutes = {
  Routes.home: (context) => const HomeScreen(),
  Routes.productDetails: (context) => const ProductDetailsScreen(),
  Routes.productType: (context) => const ProductTypeScreen(),
  Routes.orders: (context) => const Orders(),
  Routes.deliveryLocation: (context) => const DeliveryLocation(),
  Routes.paymentscreen: (context) => const PaymentScreen(),
  Routes.whishlist: (context) => const WhistlistScreen(),
  Routes.setting: (context) => const SettingScreen(),
  Routes.navBar: (context) => const NavigationBarScreen(),
  Routes.cart: (context) => const CartScreen(),
  Routes.login: (context) => const LoginScreen(),
  Routes.register: (context) => const RegisterScreen(),
  Routes.myOrder: (context) => const MyOrderScreen(),
};
