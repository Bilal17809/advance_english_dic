import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';

class PurchaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final RemoveAds removeAdsController = Get.put(RemoveAds());

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  String? _queryProductError;
  String? get queryProductError => _queryProductError;

  final bool _kAutoConsume = Platform.isIOS || false;

  final List<String> _kSubscriptionIdsForIOS = const [
    'com.urdulughat.removeads'
  ];

  final List<String> _kNonSubscriptionIds = const [
    'consumable',
    'upgrade',
  ];

  Set<String> get _allProductIds => {
    ..._kNonSubscriptionIds,
      ..._kSubscriptionIdsForIOS,
  };



  Future<void> init([void Function(void Function())? setState]) async {
    await _checkInternetConnection();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
          (details) => _listenToPurchaseUpdated(details, setState!),
      onDone: () => _subscription.cancel(),
      onError: (Object error) {
        debugPrint('Error in purchase stream: $error');
        if (Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
        setState!(() => _purchasePending = false);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Purchase stream error: ${error.toString()}')),
        );
      },
    );
    await _checkInitialPurchases();
    await initStoreInfo(setState!);
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      if (!Get.context!.mounted) return;
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(const SnackBar(content: Text("No Internet Available")));
    }
  }

  Future<void> initStoreInfo(void Function(void Function()) setState) async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      setState(() {
        _isAvailable = false;
        _products = [];
        _queryProductError = null;
        _purchasePending = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_allProductIds);

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = available;
      });
      return;
    }
    setState(() {
      _isAvailable = available;
      _products = productDetailResponse.productDetails..sort((a, b) {
        const order = ['year', 'annual', 'quarter', 'month'];
        int getIndex(ProductDetails p) {
          final id = p.id.toLowerCase();
          for (int i = 0; i < order.length; i++) {
            if (id.contains(order[i])) return i;
          }
          return order.length;
        }
        return getIndex(a).compareTo(getIndex(b));
      });
      _queryProductError = null;
    });
  }


  Future<void> buyProduct(
      ProductDetails product,
      PurchaseDetails? purchase,
      BuildContext context,
      ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Connecting to store...'),
          ],
        ),
      ),
    );
    try {
      late PurchaseParam purchaseParam;
      if (Platform.isAndroid) {
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: product,
          changeSubscriptionParam:
          purchase != null && purchase is GooglePlayPurchaseDetails
              ? ChangeSubscriptionParam(oldPurchaseDetails: purchase)
              : null,
        );
      } else if (Platform.isIOS) {
        purchaseParam = PurchaseParam(productDetails: product);
      }
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      if (product.id == 'consumable') {
        _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: _kAutoConsume,
        );
      } else {
        _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      debugPrint('Purchase initiation error: $e');
      if (Navigator.of(Get.context!).canPop()) Navigator.of(Get.context!).pop();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Failed to initiate purchase: ${e.toString()}')),
      );
    }
  }
  Future<void> _checkInitialPurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      // await StorageServices.clearSubscriptionState();
      removeAdsController.isSubscribedGet(false);
    }
  }


  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> detailsList,
      void Function(void Function()) setState,
      ) async {
    bool foundActiveSubscription = false;
    for (var details in detailsList) {
      if (details.status == PurchaseStatus.pending) {
        setState(() => _purchasePending = true);
      } else if (details.status == PurchaseStatus.error) {
        setState(() => _purchasePending = false);
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              'Purchase failed: ${details.error?.message ?? "Unknown error"}',
            ),
          ),
        );
      } else if (details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored) {
        if (_kSubscriptionIdsForIOS.contains(details.productID)) {
          foundActiveSubscription = true;
          setState(() => _purchasePending = false);
          if (Navigator.of(Get.context!).canPop()) {
            Navigator.of(Get.context!).pop();
          }
          // await StorageServices.saveGeneralSubscriptionStatus(true);
          // await StorageServices.saveSubscriptionProductId(details.productID);
          removeAdsController.isSubscribedGet(true);
          if (details.status == PurchaseStatus.purchased) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(content: Text('Subscription purchased successfully!')),
            );
          }
          if (details.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(details);
          }
        }
      }
    }
    if (detailsList.isNotEmpty && detailsList.every((d) => d.status == PurchaseStatus.restored) && !foundActiveSubscription) {
      // await StorageServices.clearSubscriptionState();
      removeAdsController.isSubscribedGet(false);
      debugPrint('Restore successful, but no active subscription found.');
    }
  }

  Future<void> restorePurchases(
      BuildContext context,
      void Function(void Function()) setState,
      ) async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(const SnackBar(content: Text('Store is not available!')));
      return;
    }
    setState(() => _purchasePending = true);
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Restoring purchases...'),
          ],
        ),
      ),
    );
    try {
      await _inAppPurchase.restorePurchases();
      Timer(const Duration(seconds: 10), () {
        if (_purchasePending) {
          setState(() => _purchasePending = false);
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Restore timed out or no purchases found.'),
            ),
          );
        }
      });
    } catch (e) {
      setState(() => _purchasePending = false);
      if (Navigator.of(Get.context!).canPop()) {
        Navigator.of(Get.context!).pop();
      }
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('An error occurred during restore: $e')),
      );
    }
  }

  Future<void> openSubscriptionManagement() async {
    if (Platform.isAndroid) {
      const url = 'https://play.google.com/store/account/subscriptions';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch Play Store subscription page.');
      }
    } else if (Platform.isIOS) {
      const url = 'https://apps.apple.com/account/subscriptions';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch App Store subscription page.');
      }
    } else {
      debugPrint('Unsupported platform for subscription management.');
    }
  }
}
