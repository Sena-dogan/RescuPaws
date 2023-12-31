import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:gap/gap.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../model/new_paw_ui_model.dart';
import 'picker.dart';

class NewPawImageScreen extends ConsumerStatefulWidget {
  const NewPawImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewPawImageScreenState();
}

class _NewPawImageScreenState extends ConsumerState<NewPawImageScreen> {
  late PermissionState ps;
  @override
  Future<void> initState() async {
    super.initState();
    ps = await PhotoManager.requestPermissionExtend();
  }

  @override
  Widget build(BuildContext context) {
    if (ps != PermissionState.authorized) {
      return _handleError(context);
    }

    final NewPawUiModel newPaw = ref.watch(newPawLogicProvider);
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: PhotoManager.getAssetListRange(
                    start: 0,
                    end: 20,
                    filterOption: FilterOptionGroup(
                      createTimeCond: DateTimeCond(
                        min: DateTime.now().subtract(const Duration(days: 2)),
                        max: DateTime.now(),
                      ),
                    ),
                  ),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AssetEntity>> snapshot) {
                    if (snapshot.hasData) {
                      final List<AssetEntity> list = snapshot.data!;
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            final AssetEntity entity = list[index];
                            return CachedNetworkImage(imageUrl: entity.id);
                          },
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _handleError(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                    'Patili dostunuzun fotoğrafları için izninize ihtiyacımız var.'),
                const Gap(16),
                ElevatedButton(
                  onPressed: () async {
                    ps = await PhotoManager.requestPermissionExtend();
                    //TODO: handle permission denied case on paw image screen
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
