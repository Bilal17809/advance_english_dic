import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../ai_translator/controller/speak_dialog_contrl.dart';
import '../remove_ads_contrl/remove_ads_contrl.dart';
import '../term/term.dart';
import '../them_controller/them_controller.dart';



final bool _kAutoConsume = Platform.isIOS || true;
const String _kConsumableId = 'consumable';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'com.advanceenglishdictionary.Ads';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
];

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  final ThemeController themeController = Get.put(ThemeController());
  final RemoveAds removeAdsController = Get.put(RemoveAds());

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      if (!context.mounted) return;
      await showNoInternetDialog(context);
    }
  }



  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (Object error) {
        print('Error in purchase stream: $error');
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        setState(() {
          _purchasePending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase stream error: ${error.toString()}')),
        );
      },
    );
    initStoreInfo();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _loading = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   final check = themeController.isDarkMode.value;
  //   return Scaffold(
  //     backgroundColor:Colors.white,
  //     body: LayoutBuilder(
  //       builder: (context, constraints) {
  //         return _buildBody(constraints, check);
  //       },
  //     ),
  //   );
  // }


  @override
Widget build(BuildContext context) {
  final mobileHeight = MediaQuery.of(context).size.height;
  final mobileWidth = MediaQuery.of(context).size.width;
  final features = [
    {'imagePath': 'assets/trial/online-payment.png'},
    {'imagePath': 'assets/trial/book.png'},
    {'imagePath': 'assets/trial/science.png'},
  ];

  final purchaseFeature = [
    {'title': 'Smart AI', 'subtitle': 'Ask AI everything'},
    {'title': 'No Ads', 'subtitle': '100% ad free\nexperience'},
    {'title': 'Premium', 'subtitle': 'Access all features'},
  ];
  bool isSubscribed = removeAdsController.isSubscribedGet.value;
  return Scaffold(
    body: Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [kSkyBlueColor, kWhite],
            ),
          ),
        ),
        // Main content
        Column(
          children: [
            SizedBox(height: 48),
            // Illustrations
            Container(
              height: mobileHeight * 0.15,
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: mobileHeight * 0.015),
              child: CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 0.6,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items:
                features.map((feature) {
                  return Image.asset(
                    feature['imagePath'] as String,
                    fit: BoxFit.contain,
                  );
                }).toList(),
              ),
            ),
            // Title and subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mobileWidth * 0.04),
              child: Column(
                children: [
                  isSubscribed?Text("Ads free version",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kSkyBlueColor,
                    ),
                  )
                      :Text(
                    'Upgrade to Premium & Get',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kSkyBlueColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Unlimited Access',
                    style: context.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: mobileHeight * 0.15,
                  viewportFraction: 0.75,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items:
                purchaseFeature.map((purchaseFeature) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: mobileWidth * 0.08,
                    ),
                    decoration: roundedDecoration.copyWith(
                      color: kSkyBlueColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kSkyBlueColor.withValues(alpha: 0.3), width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: roundedDecoration,
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            purchaseFeature['title'] == 'No Ads'
                                ? Icons.block
                                : purchaseFeature['title'] == 'Smart AI'
                                ? Icons.psychology
                                : Icons.info_outline,
                            color:
                            purchaseFeature['title'] == 'No Ads'
                                ? kRed
                                : kBlack,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              purchaseFeature['title'] as String,
                              style: context.textTheme.titleSmall,
                            ),
                            SizedBox(height: 2),
                            Text(
                              purchaseFeature['subtitle'] as String,
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height:MediaQuery.of(context).size.height*0.08),
            _buildProductList(mobileWidth, mobileHeight,true),
            SizedBox(height: 8),
            Text(
              '>> Cancel anytime at least 24 hours before renewal',
              style: context.textTheme.bodySmall?.copyWith(
                color: kSkyBlueColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20 ),
                  child: InkWell(
                    onTap: () {
                      Get.to(TermScreen());
                    },
                    child: Row(
                      children: [
                        Text(
                          "Term and conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:  14,
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                // const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                        onTap: _restorePurchases,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: _purchasePending
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                                SizedBox(width:6),
                                Text("Restoring...", style: TextStyle(color: Colors.white)),
                              ],
                            )
                                : Text(
                              "Restore",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        // Close button
        Positioned(
          top: 0,
          right: mobileWidth * 0.04,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: mobileHeight * 0.02),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(mobileWidth * 0.02),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kBlack.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: mobileWidth * 0.06,
                  ),
                ),
              ),
            ),
          ),
        ),

        if (_purchasePending)
          const Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
      ],
    ),
  );
}

  Column _buildProductList(double screenWidth, double screenHeight, bool isDarkMode) {
    double horizontalPadding = screenWidth * 0.04;
    double verticalPadding = screenHeight * 0.01;
    bool isSmallScreen = screenWidth < 600;

    final Map<String, PurchaseDetails> purchases = {
      for (var purchase in _purchases) purchase.productID: purchase
    };
    bool isSubscribed = removeAdsController.isSubscribedGet.value;
    return Column(
      children: _products.map((product) {
        final purchase = purchases[product.id];
        return isSubscribed
            ? Padding(
          padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: const Text(
            "You are on the ads-free version!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        )
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Card(
            color:kSkyBlueColor,
            elevation: 1.0,
            margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            child: ListTile(
              title: Text(
                'Life Time Subscription',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:isSmallScreen? 16:screenHeight*0.02,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                product.description,
                style: TextStyle(
                    fontSize:isSmallScreen? 14:screenHeight*0.02,
                    color:  Colors.white),
              ),
              trailing: Text(
                product.price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.white,
                  fontSize: isSmallScreen?16:screenHeight*0.02,
                ),
              ),
              onTap: () {
                // Ensure the context is valid before showing the dialog
                if (mounted) {
                  _showPurchaseDialog(context, product, purchase);
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showPurchaseDialog(
      BuildContext context, ProductDetails product, PurchaseDetails? purchase) async {
    final bool? confirmPurchase = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Confirm Purchase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Are you sure you want to buy:',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: ${product.price}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false); // User cancels
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 3,
                          ),
                          child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (confirmPurchase == true) {
      await _buyProduct(product, purchase);
    }
  }

  Widget _buildBody(BoxConstraints constraints, bool isDarkMode) {
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final check = themeController.isDarkMode.value;

    bool isSmallScreen = screenWidth < 600;
    bool isSubscribed = removeAdsController.isSubscribedGet.value;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_queryProductError != null) {
      return Center(child: Text(_queryProductError!));
    }

    final List<Map<String, dynamic>> items = [
      {'icon': 'assets/trial/free-trial.png', 'text': 'Free Trial'},
      {'icon': 'assets/trial/book.png', 'text': 'AI Dictionary'},
      {'icon': 'assets/trial/regulation.png', 'text': 'Quizzes'},
      {'icon': 'assets/trial/interactive.png', 'text': 'AI Translation'},
    ];

    return Stack(
      children: [
        ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: isSmallScreen ? screenHeight * 0.03 : screenHeight * 0.04,
                          color:Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/subs.png',
                  height: isSmallScreen ? screenHeight * 0.4 : screenHeight * 0.5,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topCenter,
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 10 : screenHeight * 0.01),
            Center(
              child: Column(
                children: [
                  isSubscribed
                      ? const Text(
                    "Ads free version",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )
                      : const Text(
                    "Go to Premium",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Unlock All Features",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : screenHeight * 0.02),
            SizedBox(
              height: isSmallScreen ? 60 : screenHeight * 0.08,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: screenWidth * 0.4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: check ? Colors.grey.shade300 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              items[index]['icon'],
                              width: isSmallScreen ? 24 : screenHeight * 0.050,
                              height: isSmallScreen ? 24 : screenHeight * 0.050,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: isSmallScreen ? 4 : screenWidth * 0.015),
                            Text(
                              items[index]['text'],
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : screenHeight * 0.016,
                                fontWeight: FontWeight.bold,
                                color: check ? Colors.black : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildProductList(screenWidth, screenHeight, isDarkMode),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Center(
                child: Text(
                  "Cancel any time, currently we are not offering free trial",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : screenHeight * 0.018,
                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: isSmallScreen ? 20 : screenWidth * 0.07),
                  child: InkWell(
                    onTap: () {
                      // Ensure TermScreen is defined and imported
                      // Get.to(TermScreen());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('TermScreen navigation not implemented in example')),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          "Term and conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14, // Adjusted for consistency
                            decoration: TextDecoration.underline,
                            color: Colors.black, // Adjusted for consistency
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: _restorePurchases,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: _purchasePending
                                ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                                SizedBox(width:6),
                                Text("Restoring...", style: TextStyle(color: Colors.white)),
                              ],
                            )
                                : Text(
                              "Restore",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.02,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        if (_purchasePending)
          const Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
      ],
    );
  }

  Future<void> _buyProduct(ProductDetails product, PurchaseDetails? purchase) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false, // Prevent back button dismissal
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Connecting to store...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      final purchaseParam = GooglePlayPurchaseParam( // Cast if using specific platform params
        productDetails: product,
        changeSubscriptionParam: purchase != null && purchase is GooglePlayPurchaseDetails
            ? ChangeSubscriptionParam(
          oldPurchaseDetails: purchase,
        )
            : null,
      );
      if (product.id == _kConsumableId) {
        await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: _kAutoConsume,
        );
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }

    } catch (e) {
      print('Immediate purchase initiation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate purchase: ${e.toString()}')),
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> detailsList) async {
    for (var details in detailsList) {
      if (details.status == PurchaseStatus.pending) {
        setState(() => _purchasePending = true);
      } else if (details.status == PurchaseStatus.error) {
        setState(() => _purchasePending = false);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${details.error?.message ?? "Unknown error"}')),
        );
      } else if (details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored) {
        setState(() => _purchasePending = false);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('SubscribedAED', true);
        await prefs.setString('subscriptionId', details.productID);
        removeAdsController.isSubscribedGet(true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscription purchased successfully!')),
        );

        if (details.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(details);
        }
      }
      if (details.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(details);
      }
    }
  }

  Future<void> _restorePurchases() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store is not available!')),
      );
      return;
    }

    setState(() {
      _purchasePending = true;
    });

    // Show a restoring loader similar to _buyProduct
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Restoring purchases...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      await _inAppPurchase.restorePurchases();
      Timer(const Duration(seconds: 20), () {
        if (_purchasePending) {
          setState(() {
            _purchasePending = false;
          });
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Restore timed out or no purchases found.')),
          );
        }
      });

    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during restore: ${e.toString()}')),
      );
    }
  }
}


class PurchaseController extends GetxController {
  var selectedPlanIndex = 0.obs;
  var isLoading = false.obs;

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }
}