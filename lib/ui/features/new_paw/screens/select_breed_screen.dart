import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../models/categories_response.dart';
import '../../../../utils/context_extensions.dart';
import '../../../../utils/error_widgett.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../logic/new_paw_logic.dart';

class SelectBreedScreen extends ConsumerStatefulWidget {
	const SelectBreedScreen({super.key});

	@override
	ConsumerState<ConsumerStatefulWidget> createState() => _NewPawScreenState();
}

class _NewPawScreenState extends ConsumerState<SelectBreedScreen> {
	@override
	Widget build(BuildContext context) {
		final AsyncValue<List<Category>> categories =
				ref.watch(fetchCategoriesProvider);
		//TODO: implement search on breeds and subbreeds
		return Container(
				constraints: const BoxConstraints.expand(),
				decoration: BoxDecoration(
					color: context.colorScheme.surface,
				),
				child: Scaffold(
					appBar: AppBar(
						backgroundColor: Colors.transparent,
						centerTitle: true,
						title: Text(
							'Cins Seç',
							style: context.textTheme.labelSmall,
						),
					),
					backgroundColor: Colors.transparent,
					body: categories.when(
						data: (List<Category> data) {
							return Padding(
								padding: const EdgeInsets.all(8.0),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										const Gap(16),
										Expanded(
											child: GridView.builder(
												gridDelegate:
														const SliverGridDelegateWithFixedCrossAxisCount(
													crossAxisCount: 2,
													childAspectRatio: 1.5,
												),
												itemCount: data.length,
												itemBuilder: (BuildContext context, int index) {
													return InkWell(
														onTap: () {
															ref
																	.read(newPawLogicProvider.notifier)
																	.setCategoryId(data[index].id);
															context.push(SGRoute.subbreed.route);
														},
														child: Card(
															elevation: 2,
															child: Stack(
																children: <Widget>[
																	Align(
																		alignment: Alignment.centerLeft,
																		child: Image.network(
																				data[index].image ?? '',
																				fit: BoxFit.cover, errorBuilder:
																						(BuildContext context, Object error,
																								StackTrace? stackTrace) {
																			return Center(
																				child: Container(
																					color: Colors.transparent,
																				),
																			);
																		}),
																	),
																	Container(
																		color: Colors.black.withOpacity(0.5),
																		child: Center(
																			child: Text(
																				data[index].name,
																				style: context.textTheme.labelSmall
																						?.copyWith(
																					color: Colors.white,
																				),
																			),
																		),
																	),
																],
															),
														),
													);
												},
											),
										),
									],
								),
							);
						},
						error: (Object error, StackTrace stackTrace) => PawErrorWidget(
              error: error,
              onRefresh: () async =>
                  ref.refresh(fetchCategoriesProvider.future),
            ),
						loading: () => const Center(
							child: LoadingPawWidget(),
						),
					),
				));
	}
}
