import 'dart:html' as html; // 👈 Add this for web tab opening
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticksy_web/Screens/FullImageScreen.dart';

class ViewAttachmentsWidget extends StatelessWidget {
  final List<String> attachments; // URLs or local file paths

  const ViewAttachmentsWidget({super.key, required this.attachments});

  bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');
  }

  bool _isPdf(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  String _getFileExtension(String url) {
    return url.split('.').last.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: const Color(0xff2C2C2C),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: Get.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Attachments",
                style: GoogleFonts.alata(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Display attachments row-wise
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: attachments.map((url) {
                    // 🖼️ If image
                    if (_isImage(url)) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullImageScreen(imageUrl: url),
                            ),
                          );
                        },
                        child: _imagePreview(url),
                      );
                    }
                    // 📄 If PDF → open in new browser tab
                    else if (_isPdf(url)) {
                      return GestureDetector(
                        onTap: () {
                          html.window.open(
                            url,
                            '_blank',
                          ); // 👈 open PDF in new tab
                        },
                        child: _filePreview(url, "PDF"),
                      );
                    }
                    // 📎 Other file types
                    else {
                      return _filePreview(url, _getFileExtension(url));
                    }
                  }).toList(),
                ),
              ),

              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: GoogleFonts.alata(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🖼️ Image Preview Widget
  Widget _imagePreview(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 80,
      height: 80,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, color: Colors.redAccent, size: 30),
          );
        },
      ),
    );
  }

  // 📁 File Preview Widget
  Widget _filePreview(String url, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.alata(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
