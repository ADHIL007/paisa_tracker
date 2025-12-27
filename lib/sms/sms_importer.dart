import 'package:get/get.dart';
import 'package:paisa_tracker/sms/sms_filter.dart';
import 'package:another_telephony/telephony.dart';


class SmsImporter {
  final Telephony _telephony = Telephony.instance;
  final FinancialSmsFilter _filter = FinancialSmsFilter();

  Future<List<SmsMessage>> importSms() async {
    final bool? permissionGranted =
        await _telephony.requestSmsPermissions;

    if (permissionGranted != true) {
      Get.snackbar("PERMISSION NEEDED", "Please grant SMS permission");
      return [];
    }

    final List<SmsMessage> allMessages =
        await _telephony.getInboxSms(
      columns: [
        SmsColumn.BODY,
        SmsColumn.ADDRESS,
        SmsColumn.DATE,
        SmsColumn.ID,
      ],
      sortOrder: [
        OrderBy(SmsColumn.DATE, sort: Sort.DESC),
      ],
    );

    return allMessages.where(_filter.isRelevant).toList();
  }
}
