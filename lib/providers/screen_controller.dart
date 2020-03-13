import 'package:flutter/cupertino.dart';

class ScreenController {
  // ProductOverviewScreen ------------------------------------
  static var _isProductsOverviewScreenLoading = false;
  static var _firstLoadingProductOverviewScreen = true;

  static bool get productsOverviewScreenLoading {
    return _isProductsOverviewScreenLoading;
  }

  static bool get firstLoadingOnProductsOverviewScreen {
    return _firstLoadingProductOverviewScreen;
  }

  static void setProductsOverviewScreenLoading(bool isLoading) {
    _isProductsOverviewScreenLoading = isLoading;
  }

  static void setFirstLoadingOnProductsOverviewScreen(bool isLoading) {
    _firstLoadingProductOverviewScreen = isLoading;
  }
// ------------------------------------------------------------

  // UserProductsScreen -----------------------------------------
  static var _isUserProductsScreenLoading = false;
  static var _firstLoadingUserProductsScreen = true;

  static bool get userProductsScreenLoading {
    return _isUserProductsScreenLoading;
  }

  static bool get firstLoadingOnUserProductsScreen {
    return _firstLoadingUserProductsScreen;
  }

  static void setUserProductsScreenLoading(bool isLoading) {
    _isUserProductsScreenLoading = isLoading;
  }

  static void setFirstLoadingOnUserProductsScreen(bool isLoading) {
    _firstLoadingUserProductsScreen = isLoading;
  }
// ------------------------------------------------------------

  // OrdersScreen ---------------------------------------------
  static var _isOrdersScreenLoading = false;
  static var _firstLoadingOrderScreen = true;

  static bool get ordersScreenLoading {
    return _isOrdersScreenLoading;
  }

  static bool get firstLoadingOnOrdersScreen {
    return _firstLoadingOrderScreen;
  }

  static void setOrdersScreenLoading(bool isLoading) {
    _isOrdersScreenLoading = isLoading;
  }

  static void setFirstLoadingOnOrdersScreen(bool isLoading) {
    _firstLoadingOrderScreen = isLoading;
  }

// ------------------------------------------------------------
}
