import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackingTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> timelineEvents;
  final DateFormat dateFormat;

  const TrackingTimeline({
    super.key,
    required this.timelineEvents,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Timeline',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: timelineEvents.length,
          itemBuilder: (context, index) {
            final event = timelineEvents[index];
            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              isFirst: index == 0,
              isLast: index == timelineEvents.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 24,
                height: 24,
                color: event['isCompleted']
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData: event['isCompleted'] ? Icons.check : Icons.circle_outlined,
                ),
              ),
              beforeLineStyle: LineStyle(
                color: index == 0 || timelineEvents[index - 1]['isCompleted']
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                thickness: 2,
              ),
              afterLineStyle: LineStyle(
                color: event['isCompleted']
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                thickness: 2,
              ),
              startChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dateFormat.format(event['time']),
                      style: TextStyle(
                        color: event['isCompleted']
                            ? Colors.black87
                            : Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              endChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'],
                      style: TextStyle(
                        color: event['isCompleted']
                            ? Colors.black87
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['description'],
                      style: TextStyle(
                        color: event['isCompleted']
                            ? Colors.black87
                            : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
