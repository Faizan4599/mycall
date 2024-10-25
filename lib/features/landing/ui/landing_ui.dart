import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycall/features/landing/bloc/landing_bloc.dart';
import 'package:mycall/mixins/common_mixin.dart';
import 'package:mycall/widget/round_button.dart';

class LandingUi extends StatelessWidget with CommonMixin {
  final _bloc = LandingBloc();
  LandingUi({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _bloc.add(LandingGetDataEvent());
      },
    );
  }
  final TextEditingController numberTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: BlocProvider(
        create: (context) => LandingBloc(),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(31, 56, 56, 56),
          // appBar: AppBar(
          //   title: const Text("My call"),
          // ),
          body: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              BlocBuilder<LandingBloc, LandingState>(
                builder: (context, state) {
                  bool isAllTap = true;
                  if (state is LandingOnTapChangeColorState) {
                    isAllTap = state.isTap;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundButton(
                        data: "All",
                        onTap: () {
                          // _bloc.add(LandingButtonColorTapEvent(isTap: true));
                          context
                              .read<LandingBloc>()
                              .add(LandingButtonColorTapEvent(isTap: false));
                        },
                        istap: isAllTap,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      RoundButton(
                        data: "Missed",
                        onTap: () {
                          // _bloc.add(LandingButtonColorTapEvent(isTap: false));
                          context
                              .read<LandingBloc>()
                              .add(LandingButtonColorTapEvent(isTap: true));
                        },
                        istap: !isAllTap,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recents",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.border_color_outlined,
                        size: 20,
                        color: Colors.white,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: numberTxt,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_outlined),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    // borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  hintText: "Search",
                  fillColor: const Color.fromARGB(31, 56, 56, 56),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 0.50),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.50),
                  ),
                ),
              ),
              BlocBuilder<LandingBloc, LandingState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    print("State is $state ");
                    if (state is LandingGetDataState) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = state.data[index];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    // border: Border.all(color: Colors.white),
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 0.50),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      data.img.toString(),
                                                    ),
                                                    fit: BoxFit.fitWidth),
                                                // color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(50),),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.name.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                masknumbers(
                                                    data.number.toString()),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                "mobile",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          (data.isMissed == false)
                                              ? const Icon(
                                                  Icons.call,
                                                  color: Colors.white,
                                                  size: 20,
                                                )
                                              : const Icon(
                                                  Icons.call_missed,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data.day.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
