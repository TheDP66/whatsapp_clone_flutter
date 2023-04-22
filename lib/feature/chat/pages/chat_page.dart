import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/helper/last_seen_message.dart';
import 'package:whatsapp_clone/common/models/message_model.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/feature/chat/widgets/chat_text_field.dart';
import 'package:whatsapp_clone/feature/chat/widgets/message_card.dart';
import 'package:whatsapp_clone/feature/chat/widgets/yellow_card.dart';

final pageStorageBucket = PageStorageBucket();

class ChatPage extends ConsumerWidget {
  ChatPage({super.key, required this.user});

  final UserModel user;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.theme.chatPageBgColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back,
              ),
              Hero(
                tag: 'profile',
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        user.profileImageUrl,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.profile,
              arguments: user,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                StreamBuilder(
                  stream: ref
                      .read(authControllerProvider)
                      .getUserPresenceStatus(uid: user.uid),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      return const Text(
                        'Connecting...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      );
                    }

                    final singleUserModel = snapshot.data!;

                    final lastMessage =
                        lastSeenMessage(singleUserModel.lastSeen);

                    return Text(
                      singleUserModel.active ? "Online" : "$lastMessage ago",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        actions: [
          CustomIconButton(
            onTap: () {},
            icon: Icons.video_call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onTap: () {},
            icon: Icons.call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onTap: () {},
            icon: Icons.more_vert,
            iconColor: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Image(
            height: double.maxFinite,
            width: double.maxFinite,
            image: const AssetImage('assets/images/doodle_bg.png'),
            fit: BoxFit.cover,
            color: context.theme.photoIconBgColor,
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: ref
                      .watch(chatControllerProvider)
                      .getAllOneToOneMessage(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return PageStorage(
                      bucket: pageStorageBucket,
                      child: ListView.builder(
                        key: const PageStorageKey('chat_page_list'),
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        controller: scrollController,
                        itemBuilder: (_, index) {
                          final message = snapshot.data![index];
                          final isSender = message.senderId ==
                              FirebaseAuth.instance.currentUser!.uid;

                          final haveNip = (index == 0) ||
                              (index == snapshot.data!.length - 1 &&
                                  message.senderId !=
                                      snapshot.data![index - 1].senderId) ||
                              (message.senderId !=
                                      snapshot.data![index - 1].senderId &&
                                  message.senderId ==
                                      snapshot.data![index + 1].senderId) ||
                              (message.senderId !=
                                      snapshot.data![index - 1].senderId &&
                                  message.senderId !=
                                      snapshot.data![index + 1].senderId);

                          return Column(
                            children: [
                              if (index == 0) const YellowCard(),
                              MessageCard(
                                isSender: isSender,
                                haveNip: haveNip,
                                message: message,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              ChatTextField(
                receiverId: user.uid,
                scrollController: scrollController,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
