// ignore_for_file: public_member_api_docs, sort_constructors_first

class OperationResponseDto {
  String jsonrpc;
  dynamic id;
  List<dynamic> result;

  OperationResponseDto({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  // factory OperationResponseDto.fromJson(Map<String, dynamic> json) =>
  //     OperationResponseDto(
  //       jsonrpc: json["jsonrpc"],
  //       id: json["id"],
  //       result: List<dynamic>.from(
  //           json["result"].map((x) => dynamic.fromJson(x))),
  //     );

  // Map<String, dynamic> toJson() => {
  //       "jsonrpc": jsonrpc,
  //       "id": id,
  //       "result": List<dynamic>.from(result.map((x) => x.toJson())),
  //     };

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'jsonrpc': jsonrpc,
      'id': id,
      'result': result,
    };
  }

  factory OperationResponseDto.fromJson(Map<String, dynamic> map) {
    return OperationResponseDto(
      jsonrpc: map['jsonrpc'] as String,
      id: map['id'] as dynamic,
      result: List<dynamic>.from(
        (map['result'] as List<dynamic>),
      ),
    );
  }

  // String toJson() => json.encode(toMap());

  // factory OperationResponseDto.fromJson(String source) =>
  //     OperationResponseDto.fromMap(json.decode(source) as Map<String, dynamic>);
}

// class ResultOperation {
//   int id;
//   List<dynamic> activityIds;
//   dynamic activityState;
//   dynamic activityUserId;
//   dynamic activityTypeId;
//   dynamic activityTypeIcon;
//   dynamic activityDateDeadline;
//   dynamic myActivityDateDeadline;
//   dynamic activitySummary;
//   dynamic activityExceptionDecoration;
//   dynamic activityExceptionIcon;
//   dynamic activityCalendarEventId;
//   dynamic messageIsFollower;
//   List<int> messageFollowerIds;
//   List<int> messagePartnerIds;
//   List<int> messageIds;
//   dynamic hasMessage;
//   dynamic messageUnread;
//   int messageUnreadCounter;
//   dynamic messageNeedaction;
//   int messageNeedactionCounter;
//   dynamic messageHasError;
//   int messageHasErrorCounter;
//   int messageAttachmentCount;
//   dynamic messageMainAttachmentId;
//   List<dynamic> websiteMessageIds;
//   dynamic messageHasSmsError;
//   dynamic name;
//   dynamic origin;
//   dynamic note;
//   dynamic backorderId;
//   dynamic backorderIds;
//   dynamic moveType;
//   dynamic state;
//   dynamic groupId;
//   dynamic priority;
//   DateTime scheduledDate;
//   dynamic dateDeadline;
//   dynamic hasDeadlineIssue;
//   DateTime date;
//   dynamic dateDone;
//   dynamic delayAlertDate;
//   dynamic jsonPopover;
//   List<dynamic> locationId;
//   List<dynamic> locationDestId;
//   List<int> moveLines;
//   List<int> moveIdsWithoutPackage;
//   dynamic hasScrapMove;
//   List<dynamic> pickingTypeId;
//   dynamic pickingTypeCode;
//   dynamic pickingTypeEntirePacks;
//   dynamic useCreateLots;
//   dynamic useExistingLots;
//   dynamic hidePickingType;
//   dynamic partnerId;
//   List<dynamic> companyId;
//   dynamic userId;
//   List<int> moveLineIds;
//   List<int> moveLineIdsWithoutPackage;
//   List<int> moveLineNosuggestIds;
//   dynamic moveLineExist;
//   dynamic hasPackages;
//   dynamic showCheckAvailability;
//   dynamic showMarkAsTodo;
//   dynamic showValidate;
//   dynamic showAllocation;
//   dynamic ownerId;
//   dynamic printed;
//   dynamic signature;
//   dynamic isSigned;
//   dynamic isLocked;
//   List<dynamic> productId;
//   dynamic showOperations;
//   dynamic showReserved;
//   dynamic showLotsText;
//   dynamic hasTracking;
//   dynamic immediateTransfer;
//   List<dynamic> packageLevelIds;
//   List<dynamic> packageLevelIdsDetails;
//   dynamic productsAvailability;
//   dynamic productsAvailabilityState;
//   DateTime lastUpdate;
//   dynamic displayName;
//   List<dynamic> createUid;
//   DateTime createDate;
//   List<dynamic> writeUid;
//   DateTime writeDate;
//   dynamic batchId;

//   ResultOperation({
//     required this.id,
//     required this.activityIds,
//     required this.activityState,
//     required this.activityUserId,
//     required this.activityTypeId,
//     required this.activityTypeIcon,
//     required this.activityDateDeadline,
//     required this.myActivityDateDeadline,
//     required this.activitySummary,
//     required this.activityExceptionDecoration,
//     required this.activityExceptionIcon,
//     required this.activityCalendarEventId,
//     required this.messageIsFollower,
//     required this.messageFollowerIds,
//     required this.messagePartnerIds,
//     required this.messageIds,
//     required this.hasMessage,
//     required this.messageUnread,
//     required this.messageUnreadCounter,
//     required this.messageNeedaction,
//     required this.messageNeedactionCounter,
//     required this.messageHasError,
//     required this.messageHasErrorCounter,
//     required this.messageAttachmentCount,
//     required this.messageMainAttachmentId,
//     required this.websiteMessageIds,
//     required this.messageHasSmsError,
//     required this.name,
//     required this.origin,
//     required this.note,
//     required this.backorderId,
//     required this.backorderIds,
//     required this.moveType,
//     required this.state,
//     required this.groupId,
//     required this.priority,
//     required this.scheduledDate,
//     required this.dateDeadline,
//     required this.hasDeadlineIssue,
//     required this.date,
//     required this.dateDone,
//     required this.delayAlertDate,
//     required this.jsonPopover,
//     required this.locationId,
//     required this.locationDestId,
//     required this.moveLines,
//     required this.moveIdsWithoutPackage,
//     required this.hasScrapMove,
//     required this.pickingTypeId,
//     required this.pickingTypeCode,
//     required this.pickingTypeEntirePacks,
//     required this.useCreateLots,
//     required this.useExistingLots,
//     required this.hidePickingType,
//     required this.partnerId,
//     required this.companyId,
//     required this.userId,
//     required this.moveLineIds,
//     required this.moveLineIdsWithoutPackage,
//     required this.moveLineNosuggestIds,
//     required this.moveLineExist,
//     required this.hasPackages,
//     required this.showCheckAvailability,
//     required this.showMarkAsTodo,
//     required this.showValidate,
//     required this.showAllocation,
//     required this.ownerId,
//     required this.printed,
//     required this.signature,
//     required this.isSigned,
//     required this.isLocked,
//     required this.productId,
//     required this.showOperations,
//     required this.showReserved,
//     required this.showLotsText,
//     required this.hasTracking,
//     required this.immediateTransfer,
//     required this.packageLevelIds,
//     required this.packageLevelIdsDetails,
//     required this.productsAvailability,
//     required this.productsAvailabilityState,
//     required this.lastUpdate,
//     required this.displayName,
//     required this.createUid,
//     required this.createDate,
//     required this.writeUid,
//     required this.writeDate,
//     required this.batchId,
//   });

//   factory ResultOperation.fromJson(Map<String, dynamic> json) =>
//       ResultOperation(
//         id: json["id"],
//         activityIds: List<dynamic>.from(json["activity_ids"].map((x) => x)),
//         activityState: json["activity_state"],
//         activityUserId: json["activity_user_id"],
//         activityTypeId: json["activity_type_id"],
//         activityTypeIcon: json["activity_type_icon"],
//         activityDateDeadline: json["activity_date_deadline"],
//         myActivityDateDeadline: json["my_activity_date_deadline"],
//         activitySummary: json["activity_summary"],
//         activityExceptionDecoration: json["activity_exception_decoration"],
//         activityExceptionIcon: json["activity_exception_icon"],
//         activityCalendarEventId: json["activity_calendar_event_id"],
//         messageIsFollower: json["message_is_follower"],
//         messageFollowerIds:
//             List<int>.from(json["message_follower_ids"].map((x) => x)),
//         messagePartnerIds:
//             List<int>.from(json["message_partner_ids"].map((x) => x)),
//         messageIds: List<int>.from(json["message_ids"].map((x) => x)),
//         hasMessage: json["has_message"],
//         messageUnread: json["message_unread"],
//         messageUnreadCounter: json["message_unread_counter"],
//         messageNeedaction: json["message_needaction"],
//         messageNeedactionCounter: json["message_needaction_counter"],
//         messageHasError: json["message_has_error"],
//         messageHasErrorCounter: json["message_has_error_counter"],
//         messageAttachmentCount: json["message_attachment_count"],
//         messageMainAttachmentId: json["message_main_attachment_id"],
//         websiteMessageIds:
//             List<dynamic>.from(json["website_message_ids"].map((x) => x)),
//         messageHasSmsError: json["message_has_sms_error"],
//         name: json["name"],
//         origin: json["origin"],
//         note: json["note"],
//         backorderId: json["backorder_id"],
//         backorderIds: json["backorder_ids"],
//         moveType: json["move_type"],
//         state: json["state"],
//         groupId: json["group_id"],
//         priority: json["priority"],
//         scheduledDate: DateTime.parse(json["scheduled_date"]),
//         dateDeadline: json["date_deadline"],
//         hasDeadlineIssue: json["has_deadline_issue"],
//         date: DateTime.parse(json["date"]),
//         dateDone: json["date_done"],
//         delayAlertDate: json["delay_alert_date"],
//         jsonPopover: json["json_popover"],
//         locationId: List<dynamic>.from(json["location_id"].map((x) => x)),
//         locationDestId:
//             List<dynamic>.from(json["location_dest_id"].map((x) => x)),
//         moveLines: List<int>.from(json["move_lines"].map((x) => x)),
//         moveIdsWithoutPackage:
//             List<int>.from(json["move_ids_without_package"].map((x) => x)),
//         hasScrapMove: json["has_scrap_move"],
//         pickingTypeId:
//             List<dynamic>.from(json["picking_type_id"].map((x) => x)),
//         pickingTypeCode: json["picking_type_code"],
//         pickingTypeEntirePacks: json["picking_type_entire_packs"],
//         useCreateLots: json["use_create_lots"],
//         useExistingLots: json["use_existing_lots"],
//         hidePickingType: json["hide_picking_type"],
//         partnerId: json["partner_id"],
//         companyId: List<dynamic>.from(json["company_id"].map((x) => x)),
//         userId: json["user_id"],
//         moveLineIds: List<int>.from(json["move_line_ids"].map((x) => x)),
//         moveLineIdsWithoutPackage:
//             List<int>.from(json["move_line_ids_without_package"].map((x) => x)),
//         moveLineNosuggestIds:
//             List<int>.from(json["move_line_nosuggest_ids"].map((x) => x)),
//         moveLineExist: json["move_line_exist"],
//         hasPackages: json["has_packages"],
//         showCheckAvailability: json["show_check_availability"],
//         showMarkAsTodo: json["show_mark_as_todo"],
//         showValidate: json["show_validate"],
//         showAllocation: json["show_allocation"],
//         ownerId: json["owner_id"],
//         printed: json["printed"],
//         signature: json["signature"],
//         isSigned: json["is_signed"],
//         isLocked: json["is_locked"],
//         productId: List<dynamic>.from(json["product_id"].map((x) => x)),
//         showOperations: json["show_operations"],
//         showReserved: json["show_reserved"],
//         showLotsText: json["show_lots_text"],
//         hasTracking: json["has_tracking"],
//         immediateTransfer: json["immediate_transfer"],
//         packageLevelIds:
//             List<dynamic>.from(json["package_level_ids"].map((x) => x)),
//         packageLevelIdsDetails:
//             List<dynamic>.from(json["package_level_ids_details"].map((x) => x)),
//         productsAvailability: json["products_availability"],
//         productsAvailabilityState: json["products_availability_state"],
//         lastUpdate: DateTime.parse(json["__last_update"]),
//         displayName: json["display_name"],
//         createUid: List<dynamic>.from(json["create_uid"].map((x) => x)),
//         createDate: DateTime.parse(json["create_date"]),
//         writeUid: List<dynamic>.from(json["write_uid"].map((x) => x)),
//         writeDate: DateTime.parse(json["write_date"]),
//         batchId: json["batch_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "activity_ids": List<dynamic>.from(activityIds.map((x) => x)),
//         "activity_state": activityState,
//         "activity_user_id": activityUserId,
//         "activity_type_id": activityTypeId,
//         "activity_type_icon": activityTypeIcon,
//         "activity_date_deadline": activityDateDeadline,
//         "my_activity_date_deadline": myActivityDateDeadline,
//         "activity_summary": activitySummary,
//         "activity_exception_decoration": activityExceptionDecoration,
//         "activity_exception_icon": activityExceptionIcon,
//         "activity_calendar_event_id": activityCalendarEventId,
//         "message_is_follower": messageIsFollower,
//         "message_follower_ids":
//             List<dynamic>.from(messageFollowerIds.map((x) => x)),
//         "message_partner_ids":
//             List<dynamic>.from(messagePartnerIds.map((x) => x)),
//         "message_ids": List<dynamic>.from(messageIds.map((x) => x)),
//         "has_message": hasMessage,
//         "message_unread": messageUnread,
//         "message_unread_counter": messageUnreadCounter,
//         "message_needaction": messageNeedaction,
//         "message_needaction_counter": messageNeedactionCounter,
//         "message_has_error": messageHasError,
//         "message_has_error_counter": messageHasErrorCounter,
//         "message_attachment_count": messageAttachmentCount,
//         "message_main_attachment_id": messageMainAttachmentId,
//         "website_message_ids":
//             List<dynamic>.from(websiteMessageIds.map((x) => x)),
//         "message_has_sms_error": messageHasSmsError,
//         "name": name,
//         "origin": origin,
//         "note": note,
//         "backorder_id": backorderId,
//         "backorder_ids": backorderIds,
//         "move_type": moveType,
//         "state": state,
//         "group_id": groupId,
//         "priority": priority,
//         "scheduled_date": scheduledDate.toIso8601String(),
//         "date_deadline": dateDeadline,
//         "has_deadline_issue": hasDeadlineIssue,
//         "date": date.toIso8601String(),
//         "date_done": dateDone,
//         "delay_alert_date": delayAlertDate,
//         "json_popover": jsonPopover,
//         "location_id": List<dynamic>.from(locationId.map((x) => x)),
//         "location_dest_id": List<dynamic>.from(locationDestId.map((x) => x)),
//         "move_lines": List<dynamic>.from(moveLines.map((x) => x)),
//         "move_ids_without_package":
//             List<dynamic>.from(moveIdsWithoutPackage.map((x) => x)),
//         "has_scrap_move": hasScrapMove,
//         "picking_type_id": List<dynamic>.from(pickingTypeId.map((x) => x)),
//         "picking_type_code": pickingTypeCode,
//         "picking_type_entire_packs": pickingTypeEntirePacks,
//         "use_create_lots": useCreateLots,
//         "use_existing_lots": useExistingLots,
//         "hide_picking_type": hidePickingType,
//         "partner_id": partnerId,
//         "company_id": List<dynamic>.from(companyId.map((x) => x)),
//         "user_id": userId,
//         "move_line_ids": List<dynamic>.from(moveLineIds.map((x) => x)),
//         "move_line_ids_without_package":
//             List<dynamic>.from(moveLineIdsWithoutPackage.map((x) => x)),
//         "move_line_nosuggest_ids":
//             List<dynamic>.from(moveLineNosuggestIds.map((x) => x)),
//         "move_line_exist": moveLineExist,
//         "has_packages": hasPackages,
//         "show_check_availability": showCheckAvailability,
//         "show_mark_as_todo": showMarkAsTodo,
//         "show_validate": showValidate,
//         "show_allocation": showAllocation,
//         "owner_id": ownerId,
//         "printed": printed,
//         "signature": signature,
//         "is_signed": isSigned,
//         "is_locked": isLocked,
//         "product_id": List<dynamic>.from(productId.map((x) => x)),
//         "show_operations": showOperations,
//         "show_reserved": showReserved,
//         "show_lots_text": showLotsText,
//         "has_tracking": hasTracking,
//         "immediate_transfer": immediateTransfer,
//         "package_level_ids": List<dynamic>.from(packageLevelIds.map((x) => x)),
//         "package_level_ids_details":
//             List<dynamic>.from(packageLevelIdsDetails.map((x) => x)),
//         "products_availability": productsAvailability,
//         "products_availability_state": productsAvailabilityState,
//         "__last_update": lastUpdate.toIso8601String(),
//         "display_name": displayName,
//         "create_uid": List<dynamic>.from(createUid.map((x) => x)),
//         "create_date": createDate.toIso8601String(),
//         "write_uid": List<dynamic>.from(writeUid.map((x) => x)),
//         "write_date": writeDate.toIso8601String(),
//         "batch_id": batchId,
//       };
// }
