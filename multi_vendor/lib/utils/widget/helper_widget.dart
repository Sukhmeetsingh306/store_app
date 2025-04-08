/*
This the code for the animation which can be applied for the desktop view if animation is working slow or giving any kind of error in the code 

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    _textAnimationController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController1,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation1 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController1,
        curve: Curves.easeIn,
      ),
    );

    _textAnimationController1.forward();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _scaleAnimation2 = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 50), () {
      _controller2.forward();
    });

    _controller3 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _fadeAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _moveAnimation3 =
        Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 50), () {
      _controller3.forward();

      _controller3.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.forward();
        }
      });
    });
  as use the initialized(isLargeScreen) method in the scaffold up from the return or in the body
*/
