import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.tune_outlined,
                color: AppColors.primaryDarker,
                size: 30.0,
              ),
              onPressed: () => (),
            ),
          ],
        ),
        title: Text(
          'CampusConnect',
          style: TextStyle(
            color: AppColors.primaryDarker,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryDarker,
              size: 30.0,
            ),
            onPressed: () => (),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 350.0,
              height: 530.0,
              decoration: BoxDecoration(
                color: AppColors.primaryDarkest,
                image: DecorationImage(
                  image: AssetImage('assets/images/usuarioTest.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.transparent,
                    spreadRadius: 1.0,
                    blurRadius: 13.0,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saimon, 22',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppColors.transparent,
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      'Facultad de Computación',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            color: AppColors.transparent,
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),

                    // Gustos personales
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10.0,
                      children: [
                        Container(
                          width: 93.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: AppColors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.music_note, color: AppColors.white),
                              SizedBox(width: 5.0),
                              Text(
                                'Música',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 93.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: AppColors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.palette_outlined,
                                color: AppColors.white,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                'Arte',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 93.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: AppColors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sports_soccer_outlined,
                                color: AppColors.white,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                'Fútbol',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.transparent,
                        spreadRadius: 1.0,
                        blurRadius: 80.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.clear,
                    size: 55.0,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 70.0),
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.transparent,
                        spreadRadius: 1.0,
                        blurRadius: 80.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 50.0,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
