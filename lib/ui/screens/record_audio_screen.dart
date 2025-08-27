import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/audio_recorder.dart';
import '../../services/api_client.dart';
import '../../state/session_state.dart';
import 'result_screen.dart';

// ===== Figma tokens (align with detail screen) =====
const _surfacePrimary = Color(0xFFFFFDFB); // #fffdfb
const _surfaceSecondary = Color(0xFFFFA600); // orange per Figma
const _textPrimary = Color(0xFF281D1B); // #281d1b
const _borderPrimary = Color(0x80B0B0B0); // #b0b0b080
const _radius = 18.0;
const _marginH = 16.0;
const _marginTop = 50.0;

class RecordAudioScreen extends StatefulWidget {
  const RecordAudioScreen({super.key, required this.apiBase});

  final String apiBase;

  @override
  State<RecordAudioScreen> createState() => _RecordAudioScreenState();
}

class _RecordAudioScreenState extends State<RecordAudioScreen> {
  final AudioRecorderService _rec = AudioRecorderService();
  bool _recording = false;
  bool _loading = false;
  String? _error;
  File? _audioFile;

  Future<void> _toggleRecord() async {
    setState(() { _error = null; });
    try {
      if (!_recording) {
        await _rec.startRecording();
        setState(() { _recording = true; });
      } else {
        final f = await _rec.stopRecording();
        if (f != null) {
          setState(() { _audioFile = f; });
          context.read<SessionState>().setAudio(f);
        }
        setState(() { _recording = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); });
    }
  }

  Future<void> _callStt() async {
    final audio = _audioFile ?? context.read<SessionState>().recordedAudio;
    if (audio == null) { setState(() { _error = '오디오가 없습니다.'; }); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final api = ApiClient(widget.apiBase);
      final res = await api.sttSummarize(audio);
      context.read<SessionState>().setSttResult(res);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen()),
      );
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surfacePrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: _marginTop,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: _surfaceSecondary),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: '뒤로',
        ),
        title: const Text(
          '음성 녹음',
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(_marginH, 0, _marginH, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 녹음 컨트롤 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(color: _borderPrimary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _toggleRecord,
                      icon: Icon(_recording ? Icons.stop : Icons.mic, color: Colors.white),
                      label: Text(_recording ? '녹음 종료' : '녹음 시작'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _surfaceSecondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: (_audioFile != null && !_loading) ? _callStt : null,
                      icon: const Icon(Icons.send),
                      label: Text(_loading ? '전송 중...' : '인식 및 요약'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _surfaceSecondary,
                        side: BorderSide(color: _surfaceSecondary.withOpacity(0.2), width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFCDD2)),
                ),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


