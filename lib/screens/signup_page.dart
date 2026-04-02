import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../nav.dart';
import '../auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTabletOrDesktop = size.width >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4), // surface
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Texture Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.035,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/paper.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
              ),
            ),
          ),

          // 2. Right Sidebar Accent Image (Asymmetric Layout) for Desktop
          if (isDesktop)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: size.width * 0.22,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.saturation,
                    ),
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuA35rWy-g1Nkp7XdY8igUiK8Re_9xWFth_zmV3cYaYp5z_Q526ydlIsvElcSIHEO7CvJpsHLgIUK2Eb1YLazUpTGIg-d8tExjkwyLXxKlMgmlAoNZK5Rcb7JopzR9JsAYYANYj9V-FE5rrE5f2gtGLjK1gxDUOtenqQcLfEjIpMkCqes-0P6VSY6OKg2Ew69dbfGWn7o-j4WT8OWSDFVPgXDIS8Cxak-m8O_PnKNjl6pCQLSo4OpqO1e9YlfZtuu3OaoD_kHuIFDEc',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Left gradient fade on image
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: size.width * 0.1, // 10% of screen width fade
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFBF9F4),
                            const Color(0xFFFBF9F4).withValues(alpha: 0.0),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 3. Central Decor Blob
          Center(
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFADD9B)
                    .withValues(alpha: 0.1), // secondary-container / 10%
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: const SizedBox.shrink(),
            ),
          ),

          // 4. Main scrollable layout
          Column(
            children: [
              // Header
              _buildHeader(context, isTabletOrDesktop),

              // Main Content (Form)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 48.0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: 576), // max-w-xl
                            child: Column(
                              children: [
                                // Titles
                                Text(
                                  'AETHELRED MANUSCRIPT',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: const Color(0xFF715C27), // secondary
                                    letterSpacing: 3.0,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Join the Sanctuary',
                                  textAlign: TextAlign.center,
                                  style:
                                      theme.textTheme.displayMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Begin your journey through the sacred scrolls and eternal wisdom.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF58413F).withValues(
                                        alpha: 0.8), // on-surface-variant
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 48),

                                // Form Container
                                Container(
                                  padding: EdgeInsets.all(isTabletOrDesktop
                                      ? 48.0
                                      : 24.0), // md:p-12 p-6
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                        alpha:
                                            0.4), // surface-container-lowest/40
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 4,
                                          sigmaY: 4), // backdrop-blur-sm
                                      child: Column(
                                        children: [
                                          _buildTextField(
                                            context,
                                            label: 'FULL NAME',
                                            keyboardType: TextInputType.name,
                                            controller: _nameController,
                                          ),
                                          const SizedBox(height: 40),
                                          _buildTextField(
                                            context,
                                            label: 'EMAIL ADDRESS',
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: _emailController,
                                          ),
                                          const SizedBox(height: 40),
                                          _buildTextField(
                                            context,
                                            label: 'CREATE PASSWORD',
                                            obscureText: _obscurePassword,
                                            controller: _passwordController,
                                          ),
                                          const SizedBox(height: 24),

                                          // CTA Button
                                          Container(
                                            width: double.infinity,
                                            height: 56, // py-5 approximation
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF6B0109), // primary
                                                  Color(
                                                      0xFF8C1D1D), // primary-container
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF6B0109)
                                                      .withValues(alpha: 0.1),
                                                  blurRadius: 16,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  final authProvider = context
                                                      .read<AuthProvider>();
                                                  final name = _nameController
                                                      .text
                                                      .trim();
                                                  final email = _emailController
                                                      .text
                                                      .trim();
                                                  final password =
                                                      _passwordController.text;

                                                  if (email.isEmpty ||
                                                      password.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Please fill in all fields.'),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  if (password.length < 6) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Password must be at least 6 characters.'),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  final success =
                                                      await authProvider
                                                          .signUpWithEmail(
                                                    email: email,
                                                    password: password,
                                                  );

                                                  if (success && mounted) {
                                                    // Update display name if provided
                                                    final user =
                                                        authProvider.user;
                                                    if (user != null &&
                                                        name.isNotEmpty) {
                                                      await user
                                                          .updateDisplayName(
                                                              name);
                                                    }
                                                    context.go(AppRoutes.home);
                                                  } else if (mounted &&
                                                      authProvider
                                                              .errorMessage !=
                                                          null) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            authProvider
                                                                .errorMessage!),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                    );
                                                  }
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'CREATE ACCOUNT',
                                                      style: theme
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                        color: Colors
                                                            .white, // on-primary
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 2.0,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    const Icon(
                                                      Icons.church,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 16),

                                          // Guest Button
                                          Container(
                                            width: double.infinity,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                  0xFFF5F3EE), // surface-container-low
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: const Color(0xFFDFBFBC)
                                                    .withValues(
                                                        alpha:
                                                            0.3), // outline-variant/30
                                              ),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  final authProvider = context
                                                      .read<AuthProvider>();
                                                  final success =
                                                      await authProvider
                                                          .signInAsGuest();
                                                  if (success && mounted) {
                                                    context.go(AppRoutes.home);
                                                  }
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'CONTINUE AS GUEST',
                                                      style: theme
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                        color: const Color(
                                                            0xFF58413F), // on-surface-variant
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 2.0,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    const Icon(
                                                      Icons.person_outline,
                                                      color: Color(
                                                          0xFF58413F), // on-surface-variant
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 48),

                                          // Bottom Links
                                          Container(
                                            padding:
                                                const EdgeInsets.only(top: 32),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: const Color(0xFFDFBFBC)
                                                      .withValues(
                                                          alpha:
                                                              0.1), // outline-variant/10
                                                ),
                                              ),
                                            ),
                                            child: isTabletOrDesktop
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: _buildBottomLinks(
                                                        context),
                                                  )
                                                : Column(
                                                    children: _buildBottomLinks(
                                                        context,
                                                        isMobile: true),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Footer
                      _buildFooter(context, isTabletOrDesktop),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTabletOrDesktop) {
    return Container(
      color: const Color(0xFFFBF9F4).withValues(alpha: 0.85),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 10, sigmaY: 10), // backdrop-blur-xl (approx)
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    final authProvider = context.read<AuthProvider>();
                    final success = await authProvider.signInAsGuest();
                    if (success && mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.menu_book,
                        color: Color(0xFF8C1D1D), // primary-container
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Holy Bible',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1B1C19),
                                ),
                      ),
                    ],
                  ),
                ),
                if (isTabletOrDesktop)
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'SCHOLARLY TERMS',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(0xFF58413F),
                                    letterSpacing: 2.0,
                                    fontSize: 11,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'SIGN UP',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(
                                        0xFF8C1D1D), // primary-container (instead of bold text)
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBottomLinks(BuildContext context,
      {bool isMobile = false}) {
    final textTheme = Theme.of(context).textTheme;
    final textWidget = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'ALREADY A MEMBER? ',
          style: textTheme.labelSmall?.copyWith(
            color: const Color(0xFF58413F), // on-surface-variant
            letterSpacing: 2.0,
            fontSize: 11,
          ),
        ),
        InkWell(
          onTap: () => context.go(AppRoutes.auth),
          child: Text(
            'Sign In',
            style: textTheme.labelSmall?.copyWith(
              color: const Color(0xFF6B0109), // primary
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );

    final icons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconBox(Icons.auto_stories),
        const SizedBox(width: 16),
        _buildIconBox(Icons.history_edu),
      ],
    );

    if (isMobile) {
      return [
        textWidget,
        const SizedBox(height: 24),
        icons,
      ];
    }

    return [textWidget, icons];
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3EE), // surface-container-low
        border: Border.all(
          color: const Color(0xFFDFBFBC)
              .withValues(alpha: 0.2), // outline-variant/20
        ),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          hoverColor: const Color(0xFFFADD9B)
              .withValues(alpha: 0.2), // secondary-container/20
          child: Icon(
            icon,
            color: const Color(0xFF58413F), // on-surface-variant
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: const Color(0xFF1B1C19), // on-surface
        fontSize: 20, // text-xl
      ),
      cursorColor: const Color(0xFF715C27), // secondary
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: const Color(0xFF58413F)
              .withValues(alpha: 0.6), // on-surface-variant/60
          letterSpacing: 1.5,
          fontSize: 14,
        ),
        floatingLabelStyle: theme.textTheme.labelMedium?.copyWith(
          color: const Color(0xFF715C27), // secondary
          letterSpacing: 1.5,
          fontSize: 12, // scaled down
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFDFBFBC)
                .withValues(alpha: 0.3), // outline-variant/30
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFDFBFBC)
                .withValues(alpha: 0.3), // outline-variant/30
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF715C27), // secondary
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        isDense: true,
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isTabletOrDesktop) {
    final textTheme = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121210) : const Color(0xFFF5F3EE);

    final footerContent = isTabletOrDesktop
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Holy Bible © MMXXIV',
                style: textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? const Color(0xFFE7E5E4)
                      : const Color(0xFF292524), // stone-200 : stone-800
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  _buildFooterLink('SIGN IN'),
                  const SizedBox(width: 32),
                  _buildFooterLink('PRIVACY POLICY'),
                  const SizedBox(width: 32),
                  _buildFooterLink('SCHOLARLY TERMS'),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF715C27), // secondary
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AUTHENTICATED GATEWAY',
                    style: textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF58413F), // on-surface-variant
                      letterSpacing: 2.0,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Column(
            children: [
              Text(
                'Holy Bible © MMXXIV',
                style: textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? const Color(0xFFE7E5E4)
                      : const Color(0xFF292524),
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFooterLink('SIGN IN'),
                  const SizedBox(width: 16),
                  _buildFooterLink('PRIVACY POLICY'),
                  const SizedBox(width: 16),
                  _buildFooterLink('TERMS'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF715C27), // secondary
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AUTHENTICATED GATEWAY',
                    style: textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF58413F), // on-surface-variant
                      letterSpacing: 2.0,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          );

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1536), // max-w-screen-2xl
          child: footerContent,
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF323232), // tertiary
              letterSpacing: 2.0,
              fontSize: 11,
            ),
      ),
    );
  }
}
