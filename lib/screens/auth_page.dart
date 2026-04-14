import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../nav.dart';
import '../auth_provider.dart';
import '../widgets/app_logo.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 768) {
            // Desktop/Tablet split layout
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildLeftPanel(context),
                ),
                Expanded(
                  flex: 7,
                  child: _buildRightPanel(context, isDesktop: true),
                ),
              ],
            );
          } else {
            // Mobile single column layout
            return _buildRightPanel(context, isDesktop: false);
          }
        },
      ),
    );
  }

  Widget _buildLeftPanel(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: const Color(0xFFF0EEE9), // surface-container
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Paper texture
          Opacity(
            opacity: 0.4,
            child: Image.network(
              'https://www.transparenttextures.com/patterns/paper.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLogo(
                  size: 64,
                  radius: 20,
                  backgroundColor:
                      colorScheme.primaryContainer.withValues(alpha: 0.18),
                  padding: const EdgeInsets.all(4),
                ),
                const SizedBox(height: 24),
                Text(
                  'The Word,\nRefined for the\nDigital Age.',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurface,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'A SCHOLARLY SANCTUARY FOR THE MODERN SCRIBE.',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.history_edu,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Digital Manuscript',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Experience the texture of history with our curated digital parchment interface.',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.normal,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom gradient fade
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    colorScheme.surface,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, {required bool isDesktop}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
        if (!isDesktop)
          // Mobile background image
          Opacity(
            opacity: 0.05,
            child: Image.network(
              'https://images.unsplash.com/photo-1504052434569-70ad5836ab65?q=80&w=2070&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),

        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48.0 : 24.0,
              vertical: 24.0,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isDesktop
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: isDesktop
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      AppLogo(
                        size: 40,
                        radius: 12,
                        backgroundColor: colorScheme.primaryContainer
                            .withValues(alpha: 0.18),
                        padding: const EdgeInsets.all(3),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Holy Bible',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SIGN IN TO YOUR SANCTUARY',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          context,
                          label: 'EMAIL ADDRESS',
                          hintText: 'name@sanctuary.com',
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          context,
                          label: 'PASSWORD',
                          hintText: '••••••••',
                          obscureText: _obscurePassword,
                          controller: _passwordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Remember me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  _rememberMe = val ?? false;
                                });
                              },
                              activeColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remember scribe',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          final email = _emailController.text.trim();
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Enter your email address first.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          context
                              .read<AuthProvider>()
                              .sendPasswordReset(email: email);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Password reset email sent. Check your inbox.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign In Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6B0109),
                          const Color(0xFF8C1D1D),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final authProvider = context.read<AuthProvider>();
                          final email = _emailController.text.trim();
                          final password = _passwordController.text;

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter both email and password.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          final success = await authProvider.signInWithEmail(
                            email: email,
                            password: password,
                          );

                          if (success && mounted) {
                            context.go(AppRoutes.home);
                          } else if (mounted &&
                              authProvider.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.errorMessage!),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color:
                                    const Color(0xFFFDDF9E), // secondary-fixed
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: const Color(0xFFFDDF9E),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Or enter via
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color:
                              colorScheme.outlineVariant.withValues(alpha: 0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'OR ENTER VIA',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color:
                              colorScheme.outlineVariant.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social Login
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          context,
                          iconData: Icons.apple,
                          label: 'Apple ID',
                          onTap: () async {
                            final authProvider = context.read<AuthProvider>();
                            final success =
                                await authProvider.signInWithApple();
                            if (success && mounted) {
                              context.go(AppRoutes.home);
                            } else if (mounted &&
                                authProvider.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage!),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSocialButton(
                          context,
                          iconUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDbUZaYY6nDTBvn9LB_cxP7_9cK7vN1kspLt2dCihkf4798pH2PMsCrMA6kWmoyCN5ZnuW6L4Ufx8U7-h9K1JM11sPKlCzBcXDc3FqnH8pAb0Hmtd83I8i0DKIc4M4NpkURcsmaCCtI8go28avFli0TlLHwTm3kfv0EkTEw2FdBvdS0F7Mt7aw_w__jlpulQzg3a3IPkz2ufUXN8bm5hZBVl_HLq_JexE87tMgYYcbMENehNMckmDjajbG5rWAf59glZlEXlArKsz4',
                          label: 'Google',
                          onTap: () async {
                            final authProvider = context.read<AuthProvider>();
                            final success =
                                await authProvider.signInWithGoogle();
                            if (success && mounted) {
                              context.go(AppRoutes.home);
                            } else if (mounted &&
                                authProvider.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage!),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Guest Login
                  SizedBox(
                    width: double.infinity,
                    child: _buildSocialButton(
                      context,
                      iconData: Icons.person_outline,
                      label: 'Guest Login',
                      onTap: () async {
                        final authProvider = context.read<AuthProvider>();
                        final success = await authProvider.signInAsGuest();
                        if (success && mounted) {
                          context.go(AppRoutes.home);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Link
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          'New to the library?',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.signup);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'SIGN UP',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              decoration: TextDecoration.underline,
                              decorationColor: colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Version info (desktop only)
        if (isDesktop)
          Positioned(
            bottom: 32,
            right: 32,
            child: Row(
              children: [
                Text(
                  'V.2.4 CODEX-ALPHA',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 32,
                  height: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.verified,
                  size: 16,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 2.0,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFB9B7B6)
                  .withValues(alpha: 0.5), // on-tertiary-container
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F3EE), // surface-container-low
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    String? iconUrl,
    IconData? iconData,
    required String label,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: const Color(0xFFF5F3EE), // surface-container-low
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap ??
            () {
              context.read<AuthProvider>().loginAsUser();
              context.go(AppRoutes.home);
            },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconUrl != null)
                Image.network(
                  iconUrl,
                  width: 16,
                  height: 16,
                  color: Colors.black,
                  colorBlendMode: BlendMode.srcIn,
                )
              else if (iconData != null)
                Icon(
                  iconData,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
