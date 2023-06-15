part of 'package:pod_player/src/pod_player.dart';

class _PodCoreVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoPlayerCtr;
  final double videoAspectRatio;
  final String tag;
  final bool showControls;

  const _PodCoreVideoPlayer({
    Key? key,
    required this.videoPlayerCtr,
    required this.videoAspectRatio,
    required this.tag,
    required this.showControls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return Builder(
      builder: (_ctrx) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode: (_podCtr.isFullScreen ? FocusNode() : _podCtr.keyboardFocusWeb) ?? FocusNode(),
          onKey: (value) => _podCtr.onKeyBoardEvents(
            event: value,
            appContext: _ctrx,
            tag: tag,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: VideoPlayer(videoPlayerCtr),
              ),
              if (showControls) ...[
                _VideoOverlays(tag: tag),
                
                
                IgnorePointer(
                  child: GetBuilder<PodGetXVideoController>(
                    tag: tag,
                    id: 'podVideoState',
                    builder: (_podCtr) {
                      final loadingWidget = _podCtr.onLoading?.call(context) ??
                          const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );

                      if (kIsWeb) {
                        switch (_podCtr.podVideoState) {
                          case PodVideoState.loading:
                            return loadingWidget;
                          case PodVideoState.paused:
                            return const Center(
                              child: Icon(
                                Icons.play_arrow,
                                size: 45,
                                color: Colors.white,
                              ),
                            );
                          case PodVideoState.playing:
                            return Center(
                              child: TweenAnimationBuilder<double>(
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                                tween: Tween<double>(begin: 1, end: 0),
                                duration: const Duration(seconds: 1),
                                child: const Icon(
                                  Icons.pause,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          case PodVideoState.error:
                            return const SizedBox();
                        }
                      } else {
                        if (_podCtr.podVideoState == PodVideoState.loading) {
                          return loadingWidget;
                        }
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                // GetBuilder<PodGetXVideoController>(
                //   tag: tag,
                //   id: 'full-screen',
                //   builder: (_podCtr) => _podCtr.isFullScreen
                //       ? const SizedBox()
                //       : GetBuilder<PodGetXVideoController>(
                //           tag: tag,
                //           id: 'overlay',
                //           builder: (_podCtr) =>
                //               _podCtr.isOverlayVisible || !_podCtr.alwaysShowProgressBar
                //                   ? const SizedBox()
                //                   : Align(
                //                       alignment: Alignment.bottomCenter,
                //                       child: PodProgressBar(
                //                         tag: tag,
                //                         alignment: Alignment.bottomCenter,
                //                         podProgressBarConfig: _podCtr.podProgressBarConfig,
                //                       ),
                //                     ),
                //         ),
                // ),
              ],
            ],
          ),
        );
      },
    );
  }
}
