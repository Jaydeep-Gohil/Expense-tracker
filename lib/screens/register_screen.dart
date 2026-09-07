import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  String _currency = 'USD - US Dollar';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    if (!_acceptedTerms) {
      _showMessage('Please agree to the Terms of Service and Privacy Policy.');
      return;
    }

    // TODO:
    // Connect Supabase signUp() here.

    _showMessage('Creating account...');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFB),

      // No bottomNavigationBar here.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(48),
              border: Border.all(
                color: const Color(0xFFBCC5C8),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0C6774),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x30000000),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      size: 31,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // FinFlow
                const Center(
                  child: Text(
                    'FinFlow',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007D78),
                      letterSpacing: -0.7,
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                // Subtitle
                const Center(
                  child: Text(
                    'Create your account to start managing\n'
                        'your finances.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      color: Color(0xFF4E585B),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Full Name
                _label('Full Name'),

                const SizedBox(height: 6),

                CustomTextField(
                  controller: _nameController,
                  hintText: 'John Doe',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 17),

                // Email
                _label('Email Address'),

                const SizedBox(height: 6),

                CustomTextField(
                  controller: _emailController,
                  hintText: 'john@example.com',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 17),

                // Password
                _label('Password'),

                const SizedBox(height: 6),

                CustomTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xFF758084),
                    ),
                  ),
                ),

                const SizedBox(height: 17),

                // Confirm Password
                _label('Confirm Password'),

                const SizedBox(height: 6),

                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: '••••••••',
                  icon: Icons.lock_reset_outlined,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                        !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xFF758084),
                    ),
                  ),
                ),

                const SizedBox(height: 17),

                // Currency
                _label('Primary Currency'),

                const SizedBox(height: 6),

                _buildCurrencyDropdown(),

                const SizedBox(height: 20),

                // Terms
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                        shape: const CircleBorder(),
                        side: const BorderSide(
                          color: Color(0xFFB8C1C4),
                        ),
                        activeColor: const Color(0xFF007D78),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Wrap(
                        children: [
                          const Text(
                            'I agree to the ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF606A6E),
                              height: 1.5,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              // TODO: Terms of Service
                            },
                            child: const Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF007D78),
                                height: 1.5,
                              ),
                            ),
                          ),

                          const Text(
                            ' and ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF606A6E),
                              height: 1.5,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              // TODO: Privacy Policy
                            },
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF007D78),
                                height: 1.5,
                              ),
                            ),
                          ),

                          const Text(
                            '.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF606A6E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Create Account
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6774),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF202629),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFBFC7C9),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _currency,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF758084),
          ),
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF303638),
          ),
          items: const [
            DropdownMenuItem(
              value: 'USD - US Dollar',
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 21,
                    color: Color(0xFF758084),
                  ),
                  SizedBox(width: 8),
                  Text('USD - US Dollar'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'INR - Indian Rupee',
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 21,
                    color: Color(0xFF758084),
                  ),
                  SizedBox(width: 8),
                  Text('INR - Indian Rupee'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'EUR - Euro',
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 21,
                    color: Color(0xFF758084),
                  ),
                  SizedBox(width: 8),
                  Text('EUR - Euro'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'GBP - British Pound',
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 21,
                    color: Color(0xFF758084),
                  ),
                  SizedBox(width: 8),
                  Text('GBP - British Pound'),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              _currency = value;
            });
          },
        ),
      ),
    );
  }
}