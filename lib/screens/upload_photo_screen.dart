import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../state/session_state.dart';
import '../config/api_config.dart';
import 'record_audio_screen.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;
  String? _error;
  bool _serverConnected = false;

  @override
  void initState() {
    super.initState();
    _checkServerConnection();
  }

  Future<void> _checkServerConnection() async {
    final api = ApiClient();
    final connected = await api.testConnection();
    setState(() {
      _serverConnected = connected;
    });
  }

  Future<void> _pickAndAnalyze() async {
    if (!_serverConnected) {
      setState(() {
        _error = '서버에 연결할 수 없습니다. 백엔드 서버가 실행 중인지 확인해주세요.';
      });
      return;
    }

    setState(() { 
      _error = null; 
      _loading = true; 
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery, 
        imageQuality: 95
      );
      
      if (picked == null) {
        setState(() { _loading = false; });
        return;
      }

      final file = File(picked.path);
      final state = context.read<SessionState>();
      state.setImage(file);

      final api = ApiClient();
      final result = await api.analyzeImage(file);
      state.setAnalyzeResult(result);
      
      if (!mounted) return;
      
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RecordAudioScreen()),
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
      appBar: AppBar(
        title: const Text('1) 사진 업로드'),
        actions: [
          IconButton(
            icon: Icon(
              _serverConnected ? Icons.check_circle : Icons.error,
              color: _serverConnected ? Colors.green : Colors.red,
            ),
            onPressed: _checkServerConnection,
            tooltip: _serverConnected ? '서버 연결됨' : '서버 연결 안됨',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 서버 연결 상태 표시
            if (!_serverConnected)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '백엔드 서버에 연결할 수 없습니다.\n'
                        'yeoriggun-ai 폴더에서 "npm start"를 실행해주세요.',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (img != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(img, height: 220, fit: BoxFit.cover),
              )
            else
              Container(
                height: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('이미지를 선택하세요'),
              ),
            
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: (_loading || !_serverConnected) ? null : _pickAndAnalyze,
              icon: const Icon(Icons.photo),
              label: Text(_loading ? '분석 중...' : '이미지 선택 및 분석'),
            ),
            
            if (_error != null) ...[
              const SizedBox(height: 12),
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


