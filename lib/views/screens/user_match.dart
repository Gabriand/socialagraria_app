import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

class UserMatch extends StatefulWidget {
  const UserMatch({super.key});

  @override
  State<UserMatch> createState() => _UserMatchState();
}

class _UserMatchState extends State<UserMatch> {
  final List<Map<String, String>> matches = [
    {
      "name": "Ana",
      "info": "Universidad de Diseño",
      "img": "assets/images/Erika.jpg",
    },
    {
      "name": "Carlos",
      "info": "Facultad de Ingeniería",
      "img": "assets/images/Victor.jpg",
    },
    {
      "name": "Beatriz",
      "info": "Escuela de Negocios",
      "img": "assets/images/Erika.jpg",
    },
    {
      "name": "David",
      "info": "Universidad Politécnica",
      "img": "assets/images/Victor.jpg",
    },
    {
      "name": "Elena",
      "info": "Facultad de Artes",
      "img": "assets/images/Erika.jpg",
    },
    {
      "name": "Fernando",
      "info": "Campus de Ciencias",
      "img": "assets/images/Victor.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Tus Matches",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDarker,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    return MatchCard(
                      name: matches[index]["name"]!,
                      info: matches[index]["info"]!,
                      img: matches[index]["img"]!,
                      onLike: () {
                        // Lógica de like
                      },
                      onDislike: () {
                        setState(() {
                          matches.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String name;
  final String info;
  final String img;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const MatchCard({
    super.key,
    required this.name,
    required this.info,
    required this.img,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            Image.asset(
              img,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.accent,
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                );
              },
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 140,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 14,
              right: 14,
              bottom: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.95),
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onDislike,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.30),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.error,
                        size: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  GestureDetector(
                    onTap: onLike,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border_outlined,
                        color: AppColors.white,
                        size: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
