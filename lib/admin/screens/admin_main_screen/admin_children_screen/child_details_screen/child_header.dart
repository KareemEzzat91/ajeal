import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:flutter/material.dart';

class ChildHeaderSection extends StatelessWidget {
  const ChildHeaderSection({
    super.key,
    required this.child,
  });

  final Child child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[700],
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Center(
        child: Hero(
          tag: 'child_avatar_${child.id}${child.name}',
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                child.gender == "Male"
                    ? "https://img.freepik.com/premium-photo/professional-portrait-studio-photograph-adorable-mixedrace-child-generative-ai_895561-2847.jpg"
                    : "https://avatarfiles.alphacoders.com/143/143832.jpg",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
