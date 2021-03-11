import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vet_app/data/model/freezed_classes.dart';
import 'package:vet_app/domain/providers/home/bookings_provider.dart';
import 'package:vet_app/util/ui/datetimeutil.dart';

class BookingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookings = useProvider(bookingsStreamProvider);
    return PlatformScaffold(
      body: SingleChildScrollView(
        child: Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.all(8.0),
            child: bookings.when(
                data: (QuerySnapshot data) {
                  if (data.docs.isEmpty) {
                    return Text("No bookings available");
                  }

                  List<Booking> currentBookings = [];
                  for (var document in data.docs) {
                    Booking newBooking = Booking.fromJson(document.data()!);
                    currentBookings.add(newBooking);
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        for (var booking in currentBookings) ...[
                          Column(
                            children: [
                              ListTile(
                                title: Text(
                                  DateTimeUtils.getDayOfWeek(
                                    booking.datetime!,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateTimeUtils.getDayMonthYear(
                                        booking.datetime!,
                                      ),
                                    ),
                                    Text(
                                      DateTimeUtils.getTime(
                                        booking.datetime!,
                                      ),
                                    ),
                                    Text(
                                      booking.user!,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Text("Animal: ${booking.animal}"),
                                    Text("Species: ${booking.species}"),
                                    Text(booking.visitReason!),
                                  ],
                                ),
                                leading: Icon(Icons.calendar_today_outlined),
                                trailing: Icon(Icons.check_box),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                              )
                            ],
                          ),
                        ]
                      ],
                    ),
                  );
                },
                loading: () {
                  return Center(child: PlatformCircularProgressIndicator());
                },
                error: (error, stack) {})),
      ),
    );
  }
}
