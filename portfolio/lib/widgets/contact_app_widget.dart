import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app.dart';
import 'glassmorphism_link_widget.dart';

class ContactAppWidget extends StatefulWidget {
  final App openApp;

  const ContactAppWidget({super.key, required this.openApp});

  @override
  State<ContactAppWidget> createState() => _ContactAppWidgetState();
}

class _ContactAppWidgetState extends State<ContactAppWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Üst boşluk - geri butonu için
          const SizedBox(height: 100),

          // Contact içeriği
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildContactContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactContent() {
    Map<String, dynamic>? data = widget.openApp.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık ve açıklama container'ı
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                widget.openApp.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Açıklama
              Text(
                widget.openApp.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Linkler - En üstte (hem links hem socialLinks kontrol et)
        if (data.isNotEmpty) ...[
          // Önce socialLinks'i kontrol et
          if (data['socialLinks'] != null &&
              (data['socialLinks'] as List).isNotEmpty) ...[
            GlassmorphismLinkWidget(
              links: data['socialLinks'],
              title: 'SOCIAL LINKS',
            ),
            const SizedBox(height: 20),
          ]
          // Eğer socialLinks yoksa, links'i kontrol et
          else if (data['links'] != null &&
              (data['links'] as List).isNotEmpty) ...[
            GlassmorphismLinkWidget(
              links: data['links'],
              title: 'SOCIAL LINKS',
            ),
            const SizedBox(height: 20),
          ],
        ],

        // İletişim bilgileri
        if (data.isNotEmpty) ...[
          // Email - hem kopyalama hem yönlendirme butonları ile
          if (data['email'] != null && data['email'].toString().isNotEmpty)
            _buildContactInfoCardWithActions(
              'Email',
              data['email'].toString(),
              Icons.email,
              Colors.red,
              onCopy: () => _copyToClipboard(data['email'].toString()),
              onAction: () => _openEmail(data['email'].toString()),
              actionIcon: Icons.mail_outline,
              actionLabel: 'Send',
            ),

          // Telefon - hem kopyalama hem yönlendirme butonları ile
          if (data['phone'] != null && data['phone'].toString().isNotEmpty)
            _buildContactInfoCardWithActions(
              'Phone',
              data['phone'].toString(),
              Icons.phone,
              Colors.green,
              onCopy: () => _copyToClipboard(data['phone'].toString()),
              onAction: () => _openPhone(data['phone'].toString()),
              actionIcon: Icons.call,
              actionLabel: 'Call',
            ),

          // Adres - küçültülmüş versiyon
          if (data['address'] != null && data['address'].toString().isNotEmpty)
            _buildCompactAddressCard(data['address'].toString()),
        ],

        const SizedBox(height: 30),

        // Contact Form
        _buildContactForm(),
      ],
    );
  }

  Widget _buildContactInfoCardWithActions(
    String title,
    String value,
    IconData icon,
    Color iconColor, {
    required VoidCallback onCopy,
    VoidCallback? onAction,
    IconData? actionIcon,
    String? actionLabel,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst kısım - icon, title ve value
          Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: iconColor.withOpacity(0.3)),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 15),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: iconColor.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Value
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Alt kısım - aksiyon butonları
          Row(
            children: [
              // Kopyala butonu - her zaman var
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onCopy,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.copy,
                            color: Colors.white.withOpacity(0.8),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Copy',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Aksiyon butonu - email/phone için
              if (onAction != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onAction,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: iconColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              actionIcon ?? Icons.launch,
                              color: iconColor.withOpacity(0.9),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              actionLabel ?? 'Open',
                              style: TextStyle(
                                color: iconColor.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactAddressCard(String address) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12), // Daha küçük padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10), // Daha küçük radius
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Icon - daha küçük
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Icon(Icons.location_on, color: Colors.orange, size: 16),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'ADDRESS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),

                // Value
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.3,
                  ),
                  maxLines: 2, // Maksimum 2 satır
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Sadece kopyala butonu - daha küçük
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _copyToClipboard(address),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Icon(
                  Icons.copy,
                  color: Colors.white.withOpacity(0.7),
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form başlığı
            Row(
              children: [
                Icon(Icons.send, color: Colors.blue.withOpacity(0.8), size: 24),
                const SizedBox(width: 10),
                Text(
                  'Send Message',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.withOpacity(0.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name field
            _buildFormField(
              controller: _nameController,
              label: 'Your Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email field
            _buildFormField(
              controller: _emailController,
              label: 'Your Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Subject field
            _buildFormField(
              controller: _subjectController,
              label: 'Subject',
              icon: Icons.subject,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Message field
            _buildFormField(
              controller: _messageController,
              label: 'Your Message',
              icon: Icons.message,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Send button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send,
                      size: 18,
                      color: Colors.white,
                    ), // Icon rengi beyaz
                    const SizedBox(width: 8),
                    Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Text rengi beyaz
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      cursorColor: Colors.white, // Cursor rengi beyaz
      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.6)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.6), width: 2),
        ),
        errorStyle: TextStyle(color: Colors.red.withOpacity(0.8), fontSize: 12),
      ),
    );
  }

  Future<void> _openEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // Fallback - kopyala
        _copyToClipboard(email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email app not found. $email copied to clipboard.'),
            backgroundColor: Colors.orange.withOpacity(0.8),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Hata durumunda kopyala
      _copyToClipboard(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening email. $email copied to clipboard.'),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _openPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        // Fallback - kopyala
        _copyToClipboard(phone);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone app not found. $phone copied to clipboard.'),
            backgroundColor: Colors.orange.withOpacity(0.8),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Hata durumunda kopyala
      _copyToClipboard(phone);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening phone. $phone copied to clipboard.'),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text copied to clipboard'),
        backgroundColor: Colors.green.withOpacity(0.8),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Form geçerli, mesaj gönderme işlemi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Colors.blue.withOpacity(0.8),
          duration: const Duration(seconds: 3),
        ),
      );

      // Form alanlarını temizle
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }
}
