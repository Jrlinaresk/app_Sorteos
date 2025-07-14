import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/models/user.dart';
import 'package:sorteos_app/services/api_service.dart';
import 'package:sorteos_app/theme/theme.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final userProfileProvider = FutureProvider.family<User, String>((
  ref,
  userId,
) async {
  return ref.read(apiServiceProvider).fetchUser(userId);
});

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider(widget.userId).future).then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider(widget.userId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: userAsync.when(
        loading: () => _ProfileContent(user: null), // Mostrar el diseño base
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) => _ProfileContent(user: user),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final User? user;
  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SafeArea(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: BackButton(color: Colors.transparent),
                ),
                CircleAvatar(
                  radius: 96.h,
                  backgroundImage:
                      user != null
                          ? NetworkImage(user!.profilePictureUrl)
                          : null,
                  child:
                      user == null ? const CircularProgressIndicator() : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user?.nickname ?? 'Cargando...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.phone ?? 'Cargando...',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Proximamente')));
                      },
                      child: Text('Update'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MaterialTheme.whiteColor,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
