import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/models/content_item_model.dart';
import 'study_provider.dart';

class AudioScreen extends ConsumerStatefulWidget {
  final ContentItemModel content;

  const AudioScreen({super.key, required this.content});

  @override
  ConsumerState<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends ConsumerState<AudioScreen> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      if (widget.content.audioUrl == null) {
        if (mounted) {
          context.showSnackBar('Ses dosyası bulunamadı', isError: true);
        }
        return;
      }

      await _player.setUrl(widget.content.audioUrl!);
      
      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            // Bittiğinde işareti koy
            if (state.processingState == ProcessingState.completed) {
               ref.read(studyProvider(widget.content.subtopicId).notifier).markAsCompleted(widget.content.id);
               _isPlaying = false;
               _player.seek(Duration.zero);
               _player.stop();
            }
          });
        }
      });

      _player.durationStream.listen((d) {
        if (mounted && d != null) setState(() => _duration = d);
      });

      _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });

      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showSnackBar('Ses yüklenemedi: $e', isError: true);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _playPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _seek(double value) {
    _player.seek(Duration(milliseconds: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.audioSummary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.headphones,
                    size: 80,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
              Text(
                widget.content.title,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              
              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                // İlerleme çubuğu
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inMilliseconds.toDouble() > 0 ? _duration.inMilliseconds.toDouble() : 1.0,
                    value: _position.inMilliseconds.toDouble().clamp(0.0, _duration.inMilliseconds.toDouble()),
                    onChanged: _seek,
                    activeColor: context.colorScheme.primary,
                    inactiveColor: context.colorScheme.surfaceContainerHighest,
                  ),
                ),
                // Süre bilgileri
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Helpers.formatDuration(_position.inSeconds),
                        style: context.textTheme.bodyMedium,
                      ),
                      Text(
                        Helpers.formatDuration(_duration.inSeconds),
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                // Kontroller
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        final newPos = _position - const Duration(seconds: 10);
                        _player.seek(newPos < Duration.zero ? Duration.zero : newPos);
                      },
                    ),
                    const SizedBox(width: AppSizes.md),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 64,
                        color: Colors.white,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _playPause,
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        final newPos = _position + const Duration(seconds: 10);
                        _player.seek(newPos > _duration ? _duration : newPos);
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
