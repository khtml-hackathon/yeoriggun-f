import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/api_client.dart';
import '../../state/session_state.dart';
import '../../config/api_config.dart';
import 'record_audio_screen.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key, required this.apiBase});

  final String apiBase;

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    setState(() { 
      _error = null; 
      _loading = true; 
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: source, 
        imageQuality: 95
      );
      
      if (picked == null) {
        setState(() { _loading = false; });
        return;
      }

      final file = File(picked.path);
      final state = context.read<SessionState>();
      state.setImage(file);

      final api = ApiClient(widget.apiBase);
      final result = await api.analyzeImage(file);
      state.setAnalyzeResult(result);
      
      if (!mounted) return;
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecordAudioScreen(apiBase: widget.apiBase),
        ),
      );
    } catch (e) {
      setState(() { 
        _error = e.toString().replaceAll('ApiException: ', '');
      });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final img = context.watch<SessionState>().selectedImage;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFB),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFFBF40), // 주황색 화살표
            size: 32,
          ),
        ),
        title: const Text(
          '상품 추가',
          style: TextStyle(
            color: Color(0xFF281D1B),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 서버 연결 경고 제거 (간소화)
            
            const SizedBox(height: 50),
            
            // 제목
            const Text(
              '상품 사진 등록',
              style: TextStyle(
                color: Color(0xFF281D1B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
                         // 카메라와 갤러리 선택 카드들 (세로 정렬)
             Column(
               children: [
                 // 카메라 카드
                 GestureDetector(
                   onTap: _loading ? null : () => _pickImage(ImageSource.camera),
                   child: Container(
                     width: double.infinity,
                     height: 200,
                     decoration: BoxDecoration(
                       color: const Color(0xB0B0B0B0),
                       borderRadius: BorderRadius.circular(15),
                       border: Border.all(
                         color: const Color(0x40B0B0B0),
                         width: 1,
                       ),
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(
                           Icons.camera_alt,
                           size: 120,
                           color: const Color(0xFF757575),
                         ),
                         const SizedBox(height: 20),
                         const Text(
                           '카메라 이동',
                           style: TextStyle(
                             color: Color(0xFF757575),
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
                 
                 const SizedBox(height: 20),
                 
                 // 갤러리 카드
                 GestureDetector(
                   onTap: _loading ? null : () => _pickImage(ImageSource.gallery),
                   child: Container(
                     width: double.infinity,
                     height: 200,
                     decoration: BoxDecoration(
                       color: const Color(0xB0B0B0B0),
                       borderRadius: BorderRadius.circular(15),
                       border: Border.all(
                         color: const Color(0x40B0B0B0),
                         width: 1,
                       ),
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(
                           Icons.photo_library,
                           size: 120,
                           color: const Color(0xFF757575),
                         ),
                         const SizedBox(height: 20),
                         const Text(
                           '갤러리 이동',
                           style: TextStyle(
                             color: Color(0xFF757575),
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
            
            if (_loading) ...[
              const SizedBox(height: 20),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
            
            if (_error != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

