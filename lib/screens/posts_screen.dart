import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/screens/chat_screen.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
// import 'package:social_media_app/screens/sign_in_screen.dart';

class PostsScreen extends StatefulWidget {
  static const String id = "posts_screen";

  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // instans picker
              final picker = ImagePicker();
              picker
                  .pickImage(source: ImageSource.gallery, imageQuality: 40)
                  .then((XFile) {
                if (XFile != null) {
                  final File file = File(XFile.path);
                  Navigator.of(context)
                      .pushNamed(CreatePostScreen.id, arguments: file);
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                context.read<AuthCubit>().signOut();
                // .then((_) =>
                //     Navigator.of(context)
                //         .pushReplacementNamed(SignInScreen.id));
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            if (snapshot.hasError) {
              return const Center(child: Text("Loading"));
            }
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot doc = snapshot.data!.docs[index];
              final Post post = Post(
                description: doc["desription"],
                id: doc['postID'],
                imageURL: doc["imageURL"],
                timestamp: doc['timestamp'],
                userID: doc['userID'],
                userName: doc["userName"],
              );
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ChatScreen.id, arguments: post);
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(post.imageURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(post.userName,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 5),
                      Text(post.description,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
