import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/features/posts/view_models/timeline_view_model.dart';
import 'package:mood_tracker/features/posts/views/widgets/post.dart';

class PostTimelineScreen extends ConsumerStatefulWidget {
  const PostTimelineScreen({super.key});

  @override
  PostTimelineScreenState createState() => PostTimelineScreenState();
}

class PostTimelineScreenState extends ConsumerState<PostTimelineScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // 스크롤이 맨 아래에 도달했을 때
      ref.read(timelineProvider.notifier).fetchNextPage();
    }
  }

  Future<void> _onRefresh() {
    return ref.read(timelineProvider.notifier).refresh();
  }

  // TODO: 삭제하기
  void _onDelete(String postId) {
    print("delete: $postId");
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Delete note"),
        message: const Text("Are you sure you want to do this?"),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(timelineProvider.notifier).deletePost(postId);
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // TODO: 수정하기

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "could not load posts: $error",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          data: (posts) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 50,
              edgeOffset: 20,
              color: Theme.of(context).primaryColor,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const SliverAppBar(
                    // snap: true,
                    floating: true,
                    stretch: true,
                    // backgroundColor: Colors.white,
                    // elevation: 1,
                    collapsedHeight: 80,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 10,
                      ),
                      stretchModes: [
                        StretchMode.blurBackground,
                        StretchMode.zoomBackground,
                        StretchMode.fadeTitle
                      ],
                      // background: Image.network(
                      //   "https://mblogthumb-phinf.pstatic.net/MjAyMjA5MjNfMjcx/MDAxNjYzOTEzMjI2MjEw.FBd103pylVi-nZy3nWW9iLXgMhWp8TLj_TF6FwNUVO0g.lArVFBKhdY0T4_PD1WTjH47UFK5KdCZhu0XZ9zLBIZcg.JPEG.vavidolls/DSC06687.JPG?type=w800",
                      //   fit: BoxFit.cover,
                      // ),
                      title: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.heartbeat,
                              size: 36,
                            ),
                            Gaps.h10,
                            Text(
                              "감정 타임라인",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList.separated(
                    itemCount: posts.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onLongPress: () => _onDelete(posts[index].id),
                      child: Post(
                        createdAt: posts[index].createdAt,
                        emotionName: posts[index].emotionName,
                        content: posts[index].content,
                        imgs: posts[index].imgs ?? [],
                      ),
                    ),
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 0.5,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100, // 원하는 높이
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }
}
