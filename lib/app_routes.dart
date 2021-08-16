import 'package:flutter/material.dart';
import 'package:itarashop/model/Category.dart';
import 'package:itarashop/ui/account/account_change_password.dart';
import 'package:itarashop/ui/account/account_delivery_instruction.dart';
import 'package:itarashop/ui/account/account_details_screen.dart';
import 'package:itarashop/ui/account/account_orders.dart';
import 'package:itarashop/ui/account/account_report_problem.dart';
import 'package:itarashop/ui/account/account_reviews.dart';
import 'package:itarashop/ui/account/account_wishlists.dart';
import 'package:itarashop/ui/account/wishlist_items.dart';
import 'package:itarashop/ui/category/productsTag.dart';
import 'package:itarashop/ui/links/help.dart';
import 'package:itarashop/ui/links/legal.dart';
import 'package:itarashop/ui/order/checkout_screen.dart';
import 'package:itarashop/webservice/webview.dart';
import 'ui/account/account_add_address.dart';
import 'ui/account/account_addressbook.dart';
import 'ui/account/account_edit_address.dart';
import 'ui/account/edit_profile_screen.dart';
import 'ui/category/category_screen.dart';
import 'ui/category/subcategory_screen.dart';
import 'ui/home/frontsection_slug_screen.dart';
import 'ui/order/payment_screen.dart';
import 'ui/order/summary_screen.dart';
import 'ui/product/product_screen.dart';
import 'app_tabview.dart';
import 'ui/auth/auth_screen.dart';
import 'ui/auth/register_screen.dart';
import 'ui/auth/signin_screen.dart';
import 'ui/cart/cart_screen.dart';
import 'ui/search/filter_result.dart';
import 'ui/search/search_filter.dart';
import 'ui/search/search_screen.dart';

generateRoute({BuildContext? context, String ?name, Map ?arguments}) {
  switch (name) {
    case '/webview':
      return Webview(
        url: arguments!['url'],
        title: arguments['title'],
      );
      break;

    case '/app':
      return AppTabView(
        activeScreen: arguments!['activeScreen'],
      );
      break;

    case '/search':
      return SearchScreen();
      break;

    case '/search-filter':
      return SearchFilter(
        query: arguments!['query'],
      );
      break;

    case '/search-filter-result':
      return FilterResultScreen(
        filterData: arguments!['filterData'],
        query: arguments['query'],
      );
      break;

    case '/auth':
      return AuthScreen();
      break;

    case '/register':
      return RegisterScreen();
      break;

    case '/signin':
      return SigninScreen(
          deepLinkSubCategory:
              arguments == null ? '' : arguments['deepLinkSubCategory'] ?? '',
          categoryTitle:
              arguments == null ? '' : arguments['categoryTitle'] ?? '',
          flowType: arguments == null
              ? FlowType.Normal
              : arguments['flowType'] ?? FlowType.Normal);
      break;

    case '/frontsection-slug':
      return FrontSectionSlugScreen(slug: arguments!['slug']);
      break;

    case '/product':
      return ProductScreen(
        productNumber: arguments!['productNumber'],
      );
      break;

    case '/cart':
      return CartScreen();
      break;

    case '/category':
      return CategoryScreen(
        category: arguments!['category'],
      );
      break;

    case '/subcategory':
      return SubcategoryScreen(
        categoryTitle: arguments!['categoryTitle'] ?? '',
        subcategory: arguments['subcategory'] ?? Category(),
        deepLinkSubCat: arguments['deepLinkSubCat'] ?? '',
        flowType: arguments['flowType'],
      );
      break;
    case '/tags':
      return ProductsTag(
        categoryTitle: arguments!['categoryTitle'] ?? '',
        subcategory: arguments['subcategory'] ?? Category(),
        deepLinkSubCat: arguments['deepLinkSubCat'] ?? '',
        flowType: arguments['flowType'],
      );
      break;

    /// Checkout
    case '/checkout-step-1':
      return CheckoutScreen(
        subtotal: arguments!['subtotal'],
      );
      break;

    case '/checkout-step-2':
      return PaymentScreen(
        deliveryAddressId: arguments!['deliveryAddressId'],
        deliveryOptionSlug: arguments['deliveryOptionSlug'],
        userId: arguments['userId'],
        subtotal: arguments['subtotal'],
        shippingFee: arguments['shippingFee'],
        
      );
      break;

    case '/checkout-step-3':
      return SummaryScreen(
        orderSummary: arguments!['orderSummary'],
      );
      break;

    /// Accounts
    case '/account/account-details':
      return AccountDetailsScreen();
      break;

    case '/account/change-password':
      return AccountChangePassword();
      break;

    case '/account/wishlists':
      return AccountWishlists(
        userId: arguments!['userId'],
      );
      break;

    case '/account/wishlists/items':
      return WishlistItems(
        userId: arguments!['userId'],
        wishlist: arguments['wishlist'],
      );

    case '/account/orders':
      return AccountOrders(
        userId: arguments!['userId'],
      );
      break;

    case '/account/address-book':
      return AccountAdressBook(
        userId: arguments!['userId'],
      );
      break;

    case '/account/add-address':
      return AddAddress(
        userId: arguments!['userId'],
      );
      break;

    case '/account/edit-address':
      return EditAddress(
        address: arguments!['address'],
        userId: arguments['userId'],
      );
      break;

    case '/account/delivery-instruction':
      return DeliveryInstruction(
        address: arguments!['address'],
        userId: arguments['userId'],
      );
      break;

    case '/account/edit-profile':
      return EditProfileScreen();
      break;

    case '/account/reviews':
      return AccountReviewScreen();
      break;

    // case '/account/push-notifications':
    //   return Text('Push Notifications');
    //   break;

    case '/account/report-a-problem':
      return AccountReportProblemScreen();
      break;

    case '/links/help':
      return HelpScreen();
      break;

    case '/links/legal':
      return LegalScreen();
      break;
  }
}
