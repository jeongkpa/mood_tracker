import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/constants/sizes.dart';
import 'package:mood_tracker/features/posts/view_models/timeline_view_model.dart';
import 'package:mood_tracker/features/posts/views/widgets/emotion_icon.dart';
import 'package:mood_tracker/features/posts/views/widgets/image_files_slider.dart';

class NewPost extends ConsumerStatefulWidget {
  final Function selectIndex;
  final String emotionName;

  const NewPost({
    super.key,
    required this.emotionName,
    required this.selectIndex,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPostState();
}

class _NewPostState extends ConsumerState<NewPost> {
  final String userName = "jeongkpa";
  final TextEditingController _postEditingController = TextEditingController();
  String _post = "";
  List<File>? _selectedPhotos;

  @override
  void initState() {
    super.initState();
    _postEditingController.addListener(() {
      setState(() {
        _post = _postEditingController.text;
      });
    });
  }

  @override
  void dispose() {
    _postEditingController.dispose();
    super.dispose();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }

  void _onEmojiTap() {
    widget.selectIndex(0);
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
  }

  void _onStartWriting() {}

  void _deleteImage() {
    _stopWriting();
    setState(() {
      _selectedPhotos = null;
    });
  }

  void _onTapPost() {
    ref.read(timelineProvider.notifier).savePost(
          emotionName: widget.emotionName,
          post: _post,
          images: _selectedPhotos,
          context: context,
        );
  }

  Future<void> _onAttachTap() async {
    final photos = await ImagePicker().pickMultiImage();

    setState(() {
      _selectedPhotos = photos
          .map(
            (photo) => File(photo.path),
          )
          .toList();
    });
  }

  // TODO: 새 게시물 작성시, Home 화면에 추가되기

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _stopWriting,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size18),
        ),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.0,
            title: const Text(
              "How do you feel?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                // letterSpacing: 0.15,
              ),
            ),
            // leadingWidth: 100,
            leading: IconButton(
              onPressed: _onEmojiTap,
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                size: 30,
              ),
            ),

            actions: [
              IconButton(
                icon: const Icon(Icons.close, size: 30), // 아이콘의 크기 조정
                onPressed: () {
                  // 닫기 버튼을 눌렀을 때의 동작
                  Navigator.of(context).pop();
                },
              ),
            ],
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(1.0),
            //   child: Container(
            //     color: Colors.grey,
            //     height: 0.5,
            //   ),
            // ),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _onEmojiTap,
                              child: EmotionIcon(
                                name: widget.emotionName,
                                size: 60,
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 0,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: -20,
                                    right: -20,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              width: 60,
                              child: Opacity(
                                opacity: 0.7,
                                child: Text(
                                  "now",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                            Gaps.h10,
                          ],
                        ),
                        Gaps.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.emotionName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                      Sizes.size20,
                                    ),
                                    topRight: Radius.circular(
                                      Sizes.size20,
                                    ),
                                    bottomLeft: Radius.circular(
                                      Sizes.size20,
                                    ),
                                    bottomRight: Radius.circular(
                                      Sizes.size20,
                                    ),
                                  ),
                                ),
                                // constraints: BoxConstraints(
                                //   maxHeight:
                                //       MediaQuery.of(context).size.height * 0.3,
                                // ),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _postEditingController,
                                      onTap: _onStartWriting,
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                        hintText: "내용을 적어주세요",
                                        // border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        // contentPadding: EdgeInsets.symmetric(
                                        //   vertical: Sizes.size10,
                                        //   horizontal: Sizes.size10,
                                        // ),
                                      ),
                                    ),
                                    Gaps.v10,
                                    _selectedPhotos != null
                                        ? ImageFilesSlider(
                                            imgs: _selectedPhotos!)
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                icon: const FaIcon(
                                                    FontAwesomeIcons.paperclip),
                                                onPressed: _onAttachTap,
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: ref.watch(timelineProvider).isLoading
                              ? () {}
                              : _onTapPost,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _post != "" ? 1.0 : 0.4,
                            child: ref.watch(timelineProvider).isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    "저장하기",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context).primaryColor,
                                    ),
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
      ),
    );
  }
}
