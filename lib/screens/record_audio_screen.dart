import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/audio_recorder.dart';
import '../services/api_client.dart';
import '../state/session_state.dart';
import 'result_screen.dart';

class RecordAudioScreen extends StatefulWidget {
  const RecordAudioScreen({super.key});

  @override
  State<RecordAudioScreen> createState() => _RecordAudioScreenState();
}

class _RecordAudioScreenState extends State<RecordAudioScreen> 
    with TickerProviderStateMixin {
  final AudioRecorderService _rec = AudioRecorderService();
  bool _recording = false;
  bool _loading = false;
  String? _error;
  File? _audioFile;
  late AnimationController _animationController;
  late AnimationController _timerController;
  int _seconds = 0;
  int _milliseconds = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _timerController.addListener(() {
      if (_recording) {
        setState(() {
          _milliseconds += 100;
          if (_milliseconds >= 1000) {
            _milliseconds = 0;
            _seconds++;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord() async {
    setState(() { _error = null; });
    try {
      if (!_recording) {
        await _rec.startRecording();
        setState(() { 
          _recording = true; 
          _seconds = 0;
          _milliseconds = 0;
        });
        _timerController.repeat();
        _animationController.repeat();
      } else {
        final f = await _rec.stopRecording();
        if (f != null) {
          setState(() { _audioFile = f; });
          context.read<SessionState>().setAudio(f);
        }
        setState(() { _recording = false; });
        _timerController.stop();
        _animationController.stop();
      }
    } catch (e) {
      setState(() { _error = e.toString(); });
    }
  }

  Future<void> _callStt() async {
    final audio = _audioFile ?? context.read<SessionState>().recordedAudio;
    if (audio == null) { 
      setState(() { _error = '오디오가 없습니다.'; }); 
      return; 
    }
    
    setState(() { 
      _loading = true; 
      _error = null; 
    });
    
    try {
      final api = ApiClient();
      final res = await api.sttSummarize(audio);
      context.read<SessionState>().setSttResult(res);
      
      if (!mounted) return;
      
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen()),
      );
    } catch (e) {
      setState(() { 
        _error = e.toString().replaceAll('ApiException: ', '');
      });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Widget _buildTimer() {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    final ms = (_milliseconds ~/ 10).toString().padLeft(2, '0');
    
    return Container(
      width: 412,
      height: 109,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 48,
            fontWeight: FontWeight.w500,
            height: 0.75,
          ),
          children: [
            TextSpan(
              text: '$minutes:$secs.',
              style: const TextStyle(color: Color(0xFF949494)),
            ),
            TextSpan(
              text: ms,
              style: const TextStyle(color: Color(0xFFFFBF40)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFB),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFFBF40),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // 오디오 시각화 완전히 제거
              // 타이머
              _buildTimer(),
              const SizedBox(height: 20),
              // 녹음 완료 버튼
              if (_audioFile != null)
                GestureDetector(
                  onTap: _loading ? null : _callStt,
                  child: Container(
                    width: 317,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBF40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        '✓  녹음 완료',
                        style: TextStyle(
                          color: Color(0xFFFFFDFB),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              else
                // 녹음 시작/종료 버튼
                GestureDetector(
                  onTap: _toggleRecord,
                  child: Container(
                    width: 317,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBF40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _recording ? Icons.stop : Icons.mic,
                            color: const Color(0xFFFFFDFB),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _recording ? '녹음 종료' : '녹음 시작',
                            style: const TextStyle(
                              color: Color(0xFFFFFDFB),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_loading) ...[
                const SizedBox(height: 20),
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFBF40)),
                  ),
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
      ),
    );
  }
}


