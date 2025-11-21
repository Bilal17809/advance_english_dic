import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../adds/rewarded_intertitial.dart';
import '../../presentations/levels/game_leves.dart';
import '../../presentations/subscription/subscription_view.dart';
import '../../presentations/word_game/controller/controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class AnimatedForwardArrow extends StatefulWidget {
  final bool isEnabled;
  const AnimatedForwardArrow({super.key, required this.isEnabled});

  @override
  State<AnimatedForwardArrow> createState() => _AnimatedForwardArrowState();
}

class _AnimatedForwardArrowState extends State<AnimatedForwardArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedForwardArrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Icon(Icons.arrow_forward, size: 20),
    );
  }
}


class GlowingCircle extends StatefulWidget {
  const GlowingCircle({super.key});

  @override
  State<GlowingCircle> createState() => _GlowingCircleState();
}

class _GlowingCircleState extends State<GlowingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glow = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical:5.0),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(_glow.value),
                  blurRadius:1.8 * _glow.value, // stronger blur
                  spreadRadius:0.3 * _glow.value, // stronger spread
                ),
              ],
              border: Border.all(
                color: Colors.indigo.shade700.withOpacity(0.5),
                width:0.3,
              ),
            ),
          ),
        );
      },
    );
  }
}


class AnimatedStaggeredLetter extends StatefulWidget {
  final String letter;
  final VoidCallback onTap;
  final int delayIndex;

  const AnimatedStaggeredLetter({
    super.key,
    required this.letter,
    required this.onTap,
    required this.delayIndex,
  });

  @override
  State<AnimatedStaggeredLetter> createState() => _AnimatedStaggeredLetterState();
}
class _AnimatedStaggeredLetterState extends State<AnimatedStaggeredLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scale = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.delayed(Duration(milliseconds: 200 * widget.delayIndex), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: roundedDecoration.copyWith(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: kSkyBlueColor.withOpacity(0.5),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.letter,
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}


class AnimatedCardButton extends StatefulWidget {
  const AnimatedCardButton({super.key});

  @override
  State<AnimatedCardButton> createState() => _AnimatedCardButtonState();
}
class _AnimatedCardButtonState extends State<AnimatedCardButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  final splashAd = Get.find<RewardAdController>();


  @override
  void initState() {
    super.initState();
    splashAd.loadAd();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.9, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  final PuzzleController controller = Get.put(PuzzleController());


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: roundedDecoration.copyWith(
              borderRadius: BorderRadius.circular(30),
              color: kSkyBlueColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/clue.png',
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap:(){
                      _showHintDialog(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hint:',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: kWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          controller.getHintForCurrentWord(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: kWhite,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showCustomDialog(
                      context: context,
                      imagePath: "assets/bonus.png",
                      title: "Get Clue",
                      message: "Watch an ad to unlock a valuable clue that can help you move forward!",
                      leftButtonText: "Cancel",
                      rightButtonText: "Watch Ads",
                        onRightTap: () async {
                          Navigator.of(context).pop();
                          if (!splashAd.isAdLoaded.value) {
                            showAdNotReadyDialog(context);
                            return;
                          }
                          if (splashAd.isAdLoaded.value) {
                            splashAd.showAd(onAdComplete: () async {
                              controller.revealPartialCorrectSequence();
                            });
                          }
                          else {
                            showAdNotReadyDialog(context);
                          }
                        }
                    );
                  },
                  child: Container(
                    height: 36,
                    width: 88,
                    decoration: roundedDecoration.copyWith(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Center(
                      child: Text(
                        "Get Clue",
                        style: context.textTheme.labelSmall?.copyWith(
                          color: kBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 45,
            child: ScaleTransition(
              scale: _scale,
              child: Image.asset(
                'assets/click.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Dialog function to show the hint:
  void _showHintDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),  // Rounded corners
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Hint',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Title color
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height:15),
                Obx(() => Text(
                  controller.getHintForCurrentWord(),
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    height: 1.5, // Line height for readability
                  ),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height:20),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF42A5F5),
                          Color(0xFF1E88E5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(55),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:  Text(
                        "close",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}

void showAdNotReadyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      Future.delayed(const Duration(seconds: 2), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.info_outline, size: 48, color: Colors.blueAccent),
              SizedBox(height: 16),
              Text(
                "Ad Not Ready",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Please try again later.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    },
  );
}
Future<void> showCustomDialog({
  required BuildContext context,
  String? imagePath,
  required String title,
  required String message,
  String leftButtonText = "Cancel",
  String rightButtonText = "OK",
  VoidCallback? onLeftTap,
  required VoidCallback onRightTap,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.only(left:18.0,right:18,top: 18,bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath != null)
                Image.asset(
                  imagePath,
                  height: 80,
                  width: 80,
                ),
              const SizedBox(height:16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style:context.textTheme.labelMedium
              ),
              const SizedBox(height:16),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF42A5F5),
                        Color(0xFF1E88E5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(55),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(Subscriptions());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Go Premium",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width:10),
                        Image.asset(
                          'assets/click_free_trial.png',
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onLeftTap != null) onLeftTap();
                      },
                      child: Text(leftButtonText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        onRightTap();
                      },
                      child: Text(
                        rightButtonText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


class AnimatedCardButtons extends StatefulWidget {
  const AnimatedCardButtons({super.key});

  @override
  State<AnimatedCardButtons> createState() => _AnimatedCardButtonsState();
}
class _AnimatedCardButtonsState extends State<AnimatedCardButtons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 3.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 1.0, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: const AnimatedCardButton(),
        ),
      ),
    );
  }
}



class AnimatedLetter extends StatefulWidget {
  final String letter;
  final Color color;
  final int index;

  const AnimatedLetter({
    required this.letter,
    required this.color,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedLetter> createState() => _AnimatedLetterState();
}
class _AnimatedLetterState extends State<AnimatedLetter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 2.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: CircleAvatar(
            key: ValueKey(widget.letter + widget.index.toString()),
            radius: 22,
            backgroundColor: widget.color,
            child: Text(
              widget.letter,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}


class AnimatedPlayGameButton extends StatelessWidget {
  const AnimatedPlayGameButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GameLevels()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical:25),
          decoration: roundedDecoration.copyWith(
            color: kSkyBlueColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedMedalIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Boost Your Learning!',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: kWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Learn Grammar by Game",
                      style: context.textTheme.labelSmall?.copyWith(
                        color: kWhite,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              /// ▶️ Play Game Button
              Container(
                height: 36,
                width: 88,
                decoration: roundedDecoration.copyWith(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Play Game",
                    style: context.textTheme.labelSmall?.copyWith(
                      color: kBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AnimatedMedalIcon extends StatefulWidget {
  const AnimatedMedalIcon({Key? key}) : super(key: key);

  @override
  State<AnimatedMedalIcon> createState() => _AnimatedMedalIconState();
}

class _AnimatedMedalIconState extends State<AnimatedMedalIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _showMedal = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startToggleLoop();
  }

  void _startToggleLoop() async {
    while (mounted) {
      setState(() => _showMedal = true);
      await Future.delayed(const Duration(seconds: 8));

      setState(() => _showMedal = false);
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: _showMedal
          ? ScaleTransition(
        scale: _scale,
        child: Image.asset(
          'assets/medal.png',
          key: const ValueKey('medal'),
          width: 35,
          height: 35,
        ),
      )
          : Container(
        key: const ValueKey('circle'),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          border: Border.all(
              color: Colors.orange.withOpacity(0.7), width: 3),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(Icons.star, color: Colors.orange, size: 15),
      ),
    );
  }
}


class AnimatedForwardArrow2 extends StatefulWidget {
  final Color color;
  final double size;

  const AnimatedForwardArrow2({
    super.key,
    this.color = Colors.blueAccent,
    this.size = 20,
  });

  @override
  _AnimatedForwardArrow2State createState() => _AnimatedForwardArrow2State();
}

class _AnimatedForwardArrow2State extends State<AnimatedForwardArrow2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Icon(
          Icons.arrow_forward_ios,
          color: widget.color,
          size: widget.size,
        ),
      ),
    );
  }
}


