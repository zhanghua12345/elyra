import 'dart:math' as Math;

import 'package:flutter/material.dart';

class PaySettingsBean {
  final int payMode;
  final int showType;
  final List<String> sort;
  final List<OSContentItem> listCoins;
  final List<OSContentItem> listSubVip;

  PaySettingsBean({
    required this.payMode,
    required this.showType,
    required this.sort,
    required this.listCoins,
    required this.listSubVip,
  });

  factory PaySettingsBean.fromJson(Map<String, dynamic> json) {
    return PaySettingsBean(
      payMode: json['pay_mode'] ?? 1,
      showType: json['show_type'] ?? 1,
      sort: List<String>.from(json['sort'] ?? []),
      listCoins: (json['list_coins'] as List?)
              ?.map((item) => OSContentItem.fromJson(item))
              .toList() ??
          [],
      listSubVip: (json['list_sub_vip'] as List?)
              ?.map((item) => OSContentItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OSContentItem {
late String _clickVersion_string;
late bool _enbalePerAllUnecho = false;


  final int id;
  final String buyType; 
  final String? size; 
  final int coins;
  final int sendCoins;
  final int sendCoinTtl;
  final String price;
  final String priceLocal;
  final String iosTemplateId;
  final String? androidTemplateId;
  final String vipType; 
  final String shortType;
  final String description;
  final int sort;
  final int? discountType; 
  final String? cornerMarker; 
  final EIndexAbout? extInfo;
  
  
  dynamic productDetails; 
  String? orderCode; 
  String? transactionId; 
  String? serverVerificationData; 

  
  int get sendVal => buyType == 'coins' && coins > 0
      ? ((sendCoins / coins) * 100).toInt()
      : 0;

  OSContentItem({
    required this.id,
    required this.buyType,
    this.size,
    required this.coins,
    required this.sendCoins,
    required this.sendCoinTtl,
    required this.price,
    required this.priceLocal,
    required this.iosTemplateId,
    this.androidTemplateId,
    required this.vipType,
    required this.shortType,
    required this.description,
    required this.sort,
    this.discountType,
    this.cornerMarker,
    this.extInfo,
    this.productDetails,
    this.orderCode,
    this.transactionId,
    this.serverVerificationData,
  });

  factory OSContentItem.fromJson(Map<String, dynamic> json) {
    return OSContentItem(
      id: json['id'] ?? 0,
      buyType: json['buy_type'] ?? '',
      size: json['size'],
      coins: json['coins'] ?? 0,
      sendCoins: json['send_coins'] ?? 0,
      sendCoinTtl: json['send_coin_ttl'] ?? 0,
      price: json['price'] ?? '',
      priceLocal: json['pricelocal'] ?? '',
      iosTemplateId: json['ios_template_id'] ?? '',
      androidTemplateId: json['android_template_id'],
      vipType: json['vip_type'] ?? '',
      shortType: json['short_type'] ?? '',
      description: json['description'] ?? '',
      sort: json['sort'] ?? 0,
      discountType: json['discount_type'],
      cornerMarker: json['corner_marker'],
      extInfo: json['ext_info'] != null
          ? EIndexAbout.fromJson(json['ext_info'])
          : null,
    );
  }
  
  

 GestureDetector clearLeaveExpandPatchPhysical(bool createResult, String buildShort_2) {
    double time_5c6 = 4.0;
    bool playZ = true;
    List<dynamic> originalu = [261, 473, 237];
    bool unechoy = false;
    String ettingE = String.fromCharCodes([97,114,105,98,95,97,95,52,51,0]);
    String adjacentS = String.fromCharCodes([101,95,52,49,95,99,97,108,99,117,108,97,116,105,110,103,0]);
    String oldY = String.fromCharCodes([105,95,51,57,95,113,117,97,100,0]);
    Map<String, dynamic> e_viewu = {String.fromCharCodes([106,95,49,49,95,115,117,109,102,0]):117, String.fromCharCodes([104,105,110,116,115,95,51,95,49,50,0]):234};
    String backgroundF = String.fromCharCodes([108,95,51,57,95,102,114,101,101,109,0]);
    String alignment4 = String.fromCharCodes([97,117,116,104,101,110,116,105,99,97,116,101,95,111,95,53,50,0]);
   for (var z = 0; z < 2; z++) {
      adjacentS += "${e_viewu.values.length ^ 1}";
   }
      time_5c6 *= adjacentS.length.toDouble();
   do {
       String compressI = String.fromCharCodes([105,110,102,101,114,101,100,95,116,95,50,55,0]);
          String vibeor = String.fromCharCodes([109,95,51,95,117,114,118,101,0]);
          int loadt = 4;
         print(loadt);
         compressI += "${vibeor.length}";
         loadt >>= Math.max(Math.min(5, loadt.abs()), 5);
      if (compressI.length >= 4) {
         compressI += "${2 + compressI.length}";
      }
       int resulty = 0;
      e_viewu = {"${originalu.length}": 1};
      if (925876 == e_viewu.length) {
         break;
      }
   } while ((925876 == e_viewu.length) && (1 <= e_viewu.values.length));
   while (ettingE.length <= backgroundF.length) {
       double category_kA = 2.0;
       int tabletv = 3;
       bool fit2 = false;
       double pagesN = 2.0;
      for (var m = 0; m < 2; m++) {
         fit2 = 25 > (tabletv.toDouble() / (Math.max(pagesN, 4))).toInt();
      }
          String networkm = String.fromCharCodes([98,95,50,55,95,100,105,115,112,115,97,98,108,101,0]);
          List<dynamic> pickP = [638, 609];
         print(pickP);
          Map<String, dynamic> jumpY = {String.fromCharCodes([115,99,97,110,110,101,114,95,121,95,50,53,0]):String.fromCharCodes([104,97,118,101,95,53,95,51,52,0]), String.fromCharCodes([111,108,107,97,100,111,116,95,97,95,53,56,0]):String.fromCharCodes([103,104,97,115,104,95,51,95,52,55,0]), String.fromCharCodes([100,95,56,57,95,102,101,116,99,104,0]):String.fromCharCodes([101,95,55,56,95,109,112,101,103,117,116,105,108,115,0])};
         print(jumpY);
         fit2 = tabletv > jumpY.keys.length;
         networkm += "1";
         pickP.add(tabletv);
      while (!fit2) {
         tabletv *= 3 * pagesN.toInt();
         break;
      }
         pagesN /= Math.max(tabletv.toDouble(), 2);
      for (var d = 0; d < 1; d++) {
         category_kA /= Math.max((3 * category_kA.toInt()).toDouble(), 3);
      }
          String recharge_ = String.fromCharCodes([98,111,111,107,107,101,101,112,105,110,103,95,107,95,57,49,0]);
         print(recharge_);
         tabletv >>= Math.max(Math.min(3, pagesN.toInt().abs()), 5);
         recharge_ = "${1 >> (Math.max(3, Math.min(pagesN.toInt().abs(), 1)))}";
      while ((category_kA - pagesN) >= 2.54) {
          double dramac = 2.0;
          String homeo = String.fromCharCodes([99,121,117,118,95,98,95,54,53,0]);
          Map<String, dynamic> n_imageP = {String.fromCharCodes([116,111,110,95,49,95,49,50,0]):true , String.fromCharCodes([99,95,56,56,95,115,111,99,107,97,100,100,114,0]):true };
         print(n_imageP);
          Map<String, dynamic> child0 = {String.fromCharCodes([99,97,116,97,108,111,103,95,118,95,56,51,0]):351, String.fromCharCodes([100,95,54,95,115,116,117,102,102,105,110,103,0]):602, String.fromCharCodes([117,95,51,55,95,97,110,110,117,108,97,114,0]):582};
         pagesN += (homeo.length | tabletv).toDouble();
         dramac *= (1 | n_imageP.values.length).toDouble();
         n_imageP["$category_kA"] = category_kA.toInt();
         child0 = {"${child0.values.length}": child0.keys.length ^ category_kA.toInt()};
         break;
      }
      if (fit2) {
          String big5 = String.fromCharCodes([105,99,111,110,105,99,95,110,95,55,53,0]);
          String category_f2j = String.fromCharCodes([121,95,55,57,95,99,116,111,114,0]);
          String trending5 = String.fromCharCodes([116,111,109,105,99,95,109,95,50,56,0]);
         pagesN += (pagesN.toInt() ^ category_f2j.length).toDouble();
         big5 += "${((fit2 ? 5 : 2) * 3)}";
         trending5 += "${category_f2j.length + trending5.length}";
      }
          double alignmentJ = 0.0;
         pagesN /= Math.max(5, (2 | tabletv).toDouble());
         alignmentJ -= (alignmentJ.toInt() << (Math.max(4, Math.min(pagesN.toInt().abs(), 3)))).toDouble();
         category_kA /= Math.max(2, (((fit2 ? 4 : 3) + category_kA.toInt()).toDouble()));
          Map<String, dynamic> controllerY = {String.fromCharCodes([98,121,116,101,99,111,100,101,118,116,97,98,95,115,95,55,53,0]):String.fromCharCodes([115,117,115,112,101,110,100,101,100,95,56,95,49,52,0]), String.fromCharCodes([117,110,105,110,115,116,97,108,108,95,111,95,49,54,0]):String.fromCharCodes([111,95,55,54,95,102,119,100,0]), String.fromCharCodes([100,114,101,102,95,117,95,52,0]):String.fromCharCodes([118,101,108,111,99,105,116,121,95,113,95,51,48,0])};
         print(controllerY);
          List<dynamic> ttlB = [116, 656];
         print(ttlB);
         tabletv |= category_kA.toInt() | tabletv;
         controllerY = {"${ttlB.length}": ttlB.length};
          bool iconu = false;
         category_kA += tabletv.toDouble();
         iconu = pagesN == 26.81;
      backgroundF += "${pagesN.toInt()}";
      break;
   }
   do {
      ettingE = "3";
      if (ettingE == String.fromCharCodes([56,114,50,106,0])) {
         break;
      }
   } while ((oldY.length > 2) && (ettingE == String.fromCharCodes([56,114,50,106,0])));
      oldY = "${((unechoy ? 5 : 1))}";
       bool delete_wP = true;
       String appv = String.fromCharCodes([110,95,53,54,95,109,97,105,110,108,105,115,116,0]);
      do {
          String controllers8 = String.fromCharCodes([97,95,53,57,95,108,105,98,115,104,105,110,101,0]);
          List<dynamic> utils_ = [String.fromCharCodes([120,95,52,52,95,116,114,97,110,115,108,97,116,111,110,0]), String.fromCharCodes([116,95,53,51,95,117,110,102,101,116,99,104,0])];
          bool codeE = true;
          String verticall = String.fromCharCodes([112,111,115,116,115,99,97,108,101,95,120,95,53,49,0]);
          double timeouti = 1.0;
         delete_wP = controllers8.length >= utils_.length;
         codeE = utils_.length == 5;
         verticall += "${timeouti.toInt() % 3}";
         timeouti += (verticall.length ^ 1).toDouble();
         if (delete_wP ? !delete_wP : delete_wP) {
            break;
         }
      } while ((delete_wP ? !delete_wP : delete_wP) && (appv.startsWith("$delete_wP")));
         appv += "${(appv == String.fromCharCodes([50,0]) ? appv.length : (delete_wP ? 5 : 2))}";
         delete_wP = (((!delete_wP ? appv.length : 41) | appv.length) < 41);
      while (delete_wP || appv.length > 2) {
         delete_wP = (((!delete_wP ? appv.length : 66) - appv.length) < 66);
         break;
      }
      if (!delete_wP) {
         appv = "${((delete_wP ? 1 : 1))}";
      }
         delete_wP = appv.length < 97;
      ettingE = "${backgroundF.length >> (Math.max(Math.min(3, originalu.length), 3))}";
      ettingE += "1";
      oldY += "${(adjacentS == String.fromCharCodes([100,0]) ? oldY.length : adjacentS.length)}";
      originalu = [1 >> (Math.max(Math.min(1, adjacentS.length), 5))];
      e_viewu = {"${e_viewu.keys.length}": backgroundF.length};
       int readyv = 2;
          int buildM = 3;
         print(buildM);
         readyv *= buildM;
      while (readyv <= 2) {
          String timeoutA = String.fromCharCodes([114,101,113,117,97,110,116,95,54,95,52,52,0]);
          int bbfdebaffdx = 3;
          List<dynamic> namei = [165, 311];
         print(namei);
          String menuT = String.fromCharCodes([115,116,105,99,107,101,114,115,101,116,95,107,95,54,50,0]);
          String delete_11Z = String.fromCharCodes([113,95,57,51,95,112,101,97,107,0]);
         readyv ~/= Math.max(1, (delete_11Z == String.fromCharCodes([53,0]) ? delete_11Z.length : menuT.length));
         timeoutA += "2";
         bbfdebaffdx |= menuT.length;
         namei.add(timeoutA.length);
         break;
      }
       int picker0 = 1;
       int wantV = 1;
      unechoy = readyv >= time_5c6.toInt();
      e_viewu[ettingE] = 1;
       Map<String, dynamic> fddebcdbeeffcebdfu = {String.fromCharCodes([103,104,97,115,104,95,111,95,50,49,0]):true , String.fromCharCodes([117,110,112,111,105,115,111,110,95,117,95,56,48,0]):false };
      if (fddebcdbeeffcebdfu["${fddebcdbeeffcebdfu.keys.length}"] != null) {
         fddebcdbeeffcebdfu["${fddebcdbeeffcebdfu.keys.length}"] = fddebcdbeeffcebdfu.values.length + fddebcdbeeffcebdfu.values.length;
      }
         fddebcdbeeffcebdfu = {"${fddebcdbeeffcebdfu.keys.length}": 3};
       String gleez = String.fromCharCodes([104,95,52,54,95,110,97,112,115,104,111,116,0]);
       String confirmv = String.fromCharCodes([113,95,54,56,95,115,105,109,100,0]);
      time_5c6 *= (((unechoy ? 3 : 2) - 1).toDouble());
   while (unechoy) {
      e_viewu[backgroundF] = (backgroundF == String.fromCharCodes([56,0]) ? backgroundF.length : alignment4.length);
      break;
   }
      backgroundF = "${alignment4.length + 2}";
      unechoy = adjacentS == backgroundF;
       Map<String, dynamic> serverF = {String.fromCharCodes([111,98,106,101,99,116,95,102,95,50,55,0]):824, String.fromCharCodes([99,111,110,118,101,114,116,111,114,95,57,95,52,53,0]):977};
       bool borderN = true;
      do {
         borderN = serverF.keys.length >= 81;
         if (borderN ? !borderN : borderN) {
            break;
         }
      } while ((borderN ? !borderN : borderN) && (2 > (5 % (Math.max(4, serverF.values.length))) && 5 > serverF.values.length));
         serverF = {"${serverF.values.length}": ((borderN ? 1 : 4) & serverF.length)};
       String cancleV = String.fromCharCodes([99,97,116,97,108,111,103,95,111,95,56,51,0]);
       String pickerS = String.fromCharCodes([114,95,55,52,95,116,111,111,108,99,104,97,105,110,0]);
       String restoreH = String.fromCharCodes([116,105,99,107,101,114,115,95,50,95,50,57,0]);
      while (cancleV.startsWith("${pickerS.length}")) {
          String local_m2G = String.fromCharCodes([104,95,56,53,95,103,97,109,97,0]);
         print(local_m2G);
          Map<String, dynamic> error1 = {String.fromCharCodes([114,101,115,104,97,112,101,95,57,95,55,0]):330, String.fromCharCodes([118,115,116,97,116,115,95,112,95,55,50,0]):210};
         pickerS += "${serverF.length}";
         local_m2G = "${2 >> (Math.max(Math.min(3, error1.keys.length), 3))}";
         error1[cancleV] = serverF.keys.length;
         break;
      }
          Map<String, dynamic> olde = {String.fromCharCodes([109,97,120,105,109,105,122,101,100,95,102,95,54,52,0]):false , String.fromCharCodes([111,95,53,51,95,112,114,101,115,101,110,116,97,98,108,101,0]):true };
         pickerS = "${(1 << (Math.max(Math.min(3, (borderN ? 5 : 2).abs()), 2)))}";
         olde = {pickerS: (String.fromCharCodes([89,0]) == restoreH ? restoreH.length : pickerS.length)};
      playZ = 27 <= serverF.length;
   for (var w = 0; w < 2; w++) {
       List<dynamic> pickg = [157, 605];
       List<dynamic> controlleri = [896, 91, 800];
         controlleri = [2];
      do {
          int rechargeo = 1;
          bool tabsC = false;
         controlleri.add(rechargeo | pickg.length);
         tabsC = tabsC && pickg.length < 62;
         if (1021487 == controlleri.length) {
            break;
         }
      } while ((pickg.contains(controlleri.length)) && (1021487 == controlleri.length));
      for (var t = 0; t < 3; t++) {
         pickg = [pickg.length];
      }
         pickg.add(pickg.length ^ controlleri.length);
         pickg.add(pickg.length);
      while (5 == pickg.length) {
         pickg = [pickg.length + controlleri.length];
         break;
      }
      backgroundF += "${originalu.length}";
   }
   if (3 > (e_viewu.keys.length / (Math.max(adjacentS.length, 9))) && 5 > (adjacentS.length / (Math.max(3, 9)))) {
       bool subS = false;
       double mireor = 2.0;
      print(mireor);
       Map<String, dynamic> o_centerl = {String.fromCharCodes([110,95,54,95,115,105,110,99,101,0]):45, String.fromCharCodes([115,117,98,112,105,120,101,108,95,102,95,56,0]):597, String.fromCharCodes([119,109,97,112,114,111,95,113,95,57,52,0]):544};
       List<dynamic> activityC = [565, 20, 817];
      print(activityC);
       String details8 = String.fromCharCodes([112,114,101,115,101,100,95,109,95,56,50,0]);
      if (subS) {
         subS = mireor < 57.95;
      }
         subS = o_centerl.keys.length >= 9;
      do {
         subS = 33.2 > mireor && subS;
         if (subS ? !subS : subS) {
            break;
         }
      } while ((subS ? !subS : subS) && ((2 << (Math.max(Math.min(3, activityC.length), 2))) >= 2));
          List<dynamic> versiono = [149, 158];
          bool dramaW = true;
          double model9 = 5.0;
         print(model9);
         activityC = [3 & details8.length];
         versiono = [versiono.length | 3];
         dramaW = versiono.contains(subS);
         model9 *= activityC.length.toDouble();
         details8 += "${o_centerl.keys.length % (Math.max(2, 4))}";
         o_centerl = {"${activityC.length}": ((subS ? 3 : 4) * 3)};
         mireor -= (3 >> (Math.max(Math.min(5, o_centerl.length), 5))).toDouble();
      do {
         subS = 71 > o_centerl.values.length;
         if (subS ? !subS : subS) {
            break;
         }
      } while ((5 > (2 & activityC.length)) && (subS ? !subS : subS));
          int ninitial_ = 5;
          List<dynamic> originalT = [486, 165];
         activityC.add(o_centerl.keys.length - 1);
         ninitial_ |= ninitial_ ~/ (Math.max(o_centerl.length, 10));
         originalT.add(2 / (Math.max(3, o_centerl.keys.length)));
      while (3 < details8.length) {
          Map<String, dynamic> main_vx = {String.fromCharCodes([105,110,116,101,114,112,111,108,97,116,111,114,95,118,95,57,48,0]):String.fromCharCodes([98,95,52,51,95,102,111,108,108,111,119,0]), String.fromCharCodes([104,111,115,116,102,108,97,103,115,95,109,95,53,51,0]):String.fromCharCodes([117,110,115,117,112,112,111,114,116,101,100,95,57,95,52,48,0]), String.fromCharCodes([112,101,114,99,101,112,116,95,102,95,53,49,0]):String.fromCharCodes([115,95,48,95,98,99,100,117,105,110,116,0])};
         activityC.add(o_centerl.length * 1);
         main_vx[details8] = mireor.toInt() << (Math.max(3, Math.min(details8.length, 5)));
         break;
      }
          String widget_6I = String.fromCharCodes([97,95,56,49,95,100,105,100,0]);
         details8 += "2";
         widget_6I = "1";
      while (details8.length >= 2) {
         activityC.add(mireor.toInt() & 2);
         break;
      }
      if (details8.endsWith("$mireor")) {
         details8 = "${(String.fromCharCodes([70,0]) == details8 ? details8.length : activityC.length)}";
      }
         activityC = [((subS ? 4 : 3) & 2)];
       double disposeF = 3.0;
      e_viewu = {oldY: oldY.length};
   }
   do {
      adjacentS = "${time_5c6.toInt() << (Math.max(Math.min(2, 1.abs()), 3))}";
      if (adjacentS.length == 4438744) {
         break;
      }
   } while ((1.16 > time_5c6) && (adjacentS.length == 4438744));
       double listenX = 0.0;
       bool vertical5 = true;
       String noticeB = String.fromCharCodes([105,119,104,116,120,95,111,95,49,52,0]);
      print(noticeB);
         noticeB = "${(String.fromCharCodes([57,0]) == noticeB ? noticeB.length : listenX.toInt())}";
       String detaild = String.fromCharCodes([105,95,55,48,95,100,111,99,108,105,115,116,0]);
      for (var f = 0; f < 1; f++) {
         noticeB += "${noticeB.length}";
      }
      while ((listenX + 2.0) <= 3.39) {
         listenX += 2.toDouble();
         break;
      }
         detaild += "${noticeB.length >> (Math.max(4, Math.min(1.abs(), 1)))}";
      while ((listenX - 3.57) <= 3.14 || 3.57 <= listenX) {
         listenX += (2 >> (Math.max(3, Math.min(listenX.toInt().abs(), 3)))).toDouble();
         break;
      }
         detaild = "${((vertical5 ? 2 : 3) % 1)}";
          String cacheW = String.fromCharCodes([119,101,108,99,104,95,49,95,54,0]);
          Map<String, dynamic> ttlx = {String.fromCharCodes([99,97,112,116,117,114,101,95,49,95,50,52,0]):true , String.fromCharCodes([109,95,56,55,95,116,101,120,116,97,116,116,114,0]):true };
         listenX -= 3.toDouble();
         cacheW += "3";
         ttlx[noticeB] = 3;
         noticeB += "${detaild.length + noticeB.length}";
      oldY = "${time_5c6.toInt() | 3}";
      oldY = "2";
   do {
      backgroundF = "2";
      if (String.fromCharCodes([50,99,102,95,56,48,121,102,0]) == backgroundF) {
         break;
      }
   } while ((String.fromCharCodes([50,99,102,95,56,48,121,102,0]) == backgroundF) && (!backgroundF.contains("${e_viewu.values.length}")));
   for (var g = 0; g < 3; g++) {
       int nump = 3;
       double colorc = 3.0;
      print(colorc);
       bool stringZ = true;
       bool z_tagn = true;
      if (1.1 >= (2.1 * colorc)) {
         nump -= 3 >> (Math.max(3, Math.min(colorc.toInt().abs(), 3)));
      }
       String b_viewn = String.fromCharCodes([97,95,55,50,95,99,108,108,99,0]);
      print(b_viewn);
       String senda = String.fromCharCodes([114,101,99,111,114,100,101,114,95,104,95,50,54,0]);
       String main_ye = String.fromCharCodes([110,95,49,53,95,109,97,107,101,100,112,107,103,0]);
      print(main_ye);
      for (var v = 0; v < 3; v++) {
         nump += colorc.toInt() ~/ 1;
      }
      if ((4 % (Math.max(2, b_viewn.length))) >= 4 || 1 >= (4 ^ b_viewn.length)) {
          String clearQ = String.fromCharCodes([102,95,50,53,95,100,117,112,101,100,0]);
          List<dynamic> vali = [859, 360];
          List<dynamic> utilsl = [953, 426, 509];
          int gradient1 = 0;
          String timeout3 = String.fromCharCodes([121,95,51,48,95,117,114,118,101,0]);
         print(timeout3);
         b_viewn += "1";
         clearQ = "${colorc.toInt() % (Math.max(3, senda.length))}";
         vali.add(main_ye.length & 1);
         utilsl = [3];
         gradient1 >>= Math.max(4, Math.min(b_viewn.length ^ colorc.toInt().abs(), 5));
         timeout3 = "${3 & colorc.toInt()}";
      }
      backgroundF = "2";
   }
      time_5c6 += (1 + backgroundF.length).toDouble();
    String recharger = String.fromCharCodes([115,99,101,110,97,114,105,111,95,110,95,54,55,0]);
      originalu = [backgroundF.length % (Math.max(recharger.length, 1))];
      originalu = [oldY.length | 3];
   do {
      time_5c6 *= oldY.length.toDouble();
      if (time_5c6 == 3990176.0) {
         break;
      }
   } while ((backgroundF.endsWith("$time_5c6")) && (time_5c6 == 3990176.0));
   if (adjacentS.length == 3 || playZ) {
      adjacentS = "${((playZ ? 4 : 1) - time_5c6.toInt())}";
   }
      time_5c6 /= Math.max(5, (1 + alignment4.length).toDouble());
      alignment4 = "${1 << (Math.max(Math.min(2, oldY.length), 3))}";
      oldY += "${time_5c6.toInt()}";
       bool fit_ = true;
      print(fit_);
      while (fit_ || fit_) {
          List<dynamic> remove8 = [String.fromCharCodes([114,101,112,114,111,99,101,115,115,95,122,95,54,48,0]), String.fromCharCodes([109,97,100,101,98,121,95,56,95,49,49,0]), String.fromCharCodes([97,95,52,51,95,113,112,101,103,0])];
          int editE = 1;
         fit_ = remove8.contains(editE);
         break;
      }
          double elarisM = 0.0;
          List<dynamic> baitingM = [747, 661];
          int serverB = 1;
         fit_ = serverB >= 7;
         elarisM += 1.toDouble();
         baitingM = [((fit_ ? 2 : 2) * baitingM.length)];
      for (var l = 0; l < 2; l++) {
         fit_ = !fit_;
      }
      alignment4 = "${e_viewu.values.length | backgroundF.length}";
   for (var v = 0; v < 1; v++) {
       String release_jt = String.fromCharCodes([112,95,52,52,95,102,114,111,109,0]);
      print(release_jt);
       String iconM = String.fromCharCodes([116,95,55,53,95,115,110,112,114,105,110,116,102,0]);
       bool canA = false;
       List<dynamic> alignmentt = [806, 553];
      while (!release_jt.startsWith("$canA")) {
         release_jt = "${(release_jt == String.fromCharCodes([117,0]) ? iconM.length : release_jt.length)}";
         break;
      }
         canA = 31 <= release_jt.length;
         alignmentt.add(1);
          int pixeln = 2;
         alignmentt.add(alignmentt.length | release_jt.length);
         pixeln &= release_jt.length;
      do {
          bool recommend3 = false;
          String fromk = String.fromCharCodes([117,95,54,54,95,112,98,108,111,99,107,115,0]);
         print(fromk);
          String descK = String.fromCharCodes([114,95,53,57,95,101,118,101,110,116,115,0]);
         release_jt = "${(2 / (Math.max(7, (canA ? 1 : 5))))}";
         recommend3 = descK.length < fromk.length;
         fromk = "${(1 | (recommend3 ? 2 : 4))}";
         descK += "${alignmentt.length}";
         if (release_jt.length == 4856861) {
            break;
         }
      } while ((release_jt.length == 4856861) && (3 > release_jt.length));
      while (5 > release_jt.length) {
         release_jt += "3";
         break;
      }
      while (2 > alignmentt.length && 2 > (2 & alignmentt.length)) {
         canA = !canA;
         break;
      }
      for (var e = 0; e < 2; e++) {
         alignmentt = [(iconM == String.fromCharCodes([79,0]) ? (canA ? 3 : 1) : iconM.length)];
      }
      if (alignmentt.length >= release_jt.length) {
          Map<String, dynamic> moreC = {String.fromCharCodes([119,95,53,57,95,117,121,118,121,0]):541, String.fromCharCodes([121,121,121,121,95,99,95,55,52,0]):646};
          List<dynamic> processed8 = [450, 31];
         release_jt = "${alignmentt.length}";
         moreC["${processed8.length}"] = 1;
         processed8.add(2);
      }
      while (5 > alignmentt.length) {
         iconM += "${((canA ? 1 : 3))}";
         break;
      }
         canA = (alignmentt.length & iconM.length) > 56;
      if (iconM == String.fromCharCodes([65,0])) {
         release_jt += "${(iconM.length * (canA ? 3 : 5))}";
      }
      oldY = "${iconM.length | 2}";
   }
       List<dynamic> description_ykG = [406, 799, 963];
       List<dynamic> load5 = [String.fromCharCodes([118,95,56,57,95,100,101,102,105,110,105,116,105,111,110,0]), String.fromCharCodes([101,95,53,52,95,98,97,115,101,100,0])];
       String staru = String.fromCharCodes([118,95,49,48,95,99,111,110,118,101,114,116,105,98,108,101,0]);
         staru += "${staru.length}";
         description_ykG.add(3);
          String signN = String.fromCharCodes([115,95,54,57,95,100,101,115,101,108,101,99,116,105,111,110,0]);
          String deviceN = String.fromCharCodes([102,95,49,57,95,116,114,97,110,115,108,105,116,101,114,97,116,101,0]);
         load5.add(deviceN.length + description_ykG.length);
         signN = "${deviceN.length / 1}";
      while ((staru.length * description_ykG.length) > 3) {
          List<dynamic> contentF = [353, 572];
          String y_image3 = String.fromCharCodes([114,101,112,101,97,116,101,100,108,121,95,115,95,57,53,0]);
          List<dynamic> timeoutb = [837, 249, 349];
         print(timeoutb);
         description_ykG = [load5.length];
         contentF = [3];
         y_image3 += "${2 % (Math.max(10, staru.length))}";
         timeoutb.add(staru.length);
         break;
      }
      for (var y = 0; y < 1; y++) {
         load5 = [staru.length];
      }
          Map<String, dynamic> speedsN = {String.fromCharCodes([115,104,111,116,95,99,95,55,48,0]):String.fromCharCodes([121,95,53,95,116,114,105,109,109,101,100,0]), String.fromCharCodes([122,95,52,57,95,110,111,114,109,97,108,105,115,101,0]):String.fromCharCodes([109,98,108,111,111,112,95,51,95,56,54,0])};
         print(speedsN);
          Map<String, dynamic> appD = {String.fromCharCodes([105,115,115,117,101,114,95,101,95,51,48,0]):String.fromCharCodes([99,105,110,118,105,100,101,111,95,111,95,50,57,0]), String.fromCharCodes([99,95,54,53,95,97,100,100,114,115,0]):String.fromCharCodes([121,95,55,57,95,98,100,108,116,0])};
          bool timer_ = true;
         staru += "2";
         speedsN["${description_ykG.length}"] = 3 >> (Math.max(Math.min(2, speedsN.keys.length), 1));
         appD = {"${speedsN.values.length}": speedsN.length ^ description_ykG.length};
      while (!staru.startsWith("${load5.length}")) {
         load5.add((staru == String.fromCharCodes([48,0]) ? staru.length : load5.length));
         break;
      }
          List<dynamic> utilsW = [231, 260, 249];
         print(utilsW);
          List<dynamic> cacheQ = [String.fromCharCodes([109,95,55,57,95,109,101,108,116,0]), String.fromCharCodes([118,105,116,97,108,105,107,108,105,122,101,95,122,95,53,54,0]), String.fromCharCodes([116,97,112,116,95,105,95,50,52,0])];
         staru += "${load5.length * cacheQ.length}";
         utilsW.add(description_ykG.length - load5.length);
       Map<String, dynamic> user7 = {String.fromCharCodes([100,95,55,51,95,99,111,110,116,97,99,116,115,0]):970, String.fromCharCodes([110,95,54,53,95,114,100,102,116,0]):418, String.fromCharCodes([111,95,53,95,119,105,100,116,104,0]):409};
      alignment4 = "${backgroundF.length}";
   if (adjacentS.startsWith("${ettingE.length}")) {
      adjacentS = "${time_5c6.toInt()}";
   }
   do {
      time_5c6 -= adjacentS.length.toDouble();
      if (time_5c6 == 2577776.0) {
         break;
      }
   } while ((time_5c6 == 2577776.0) && (playZ && 5.70 < (3.62 + time_5c6)));
   if ((4 | e_viewu.values.length) == 2 && playZ) {
      e_viewu["$time_5c6"] = 1 + e_viewu.length;
   }
   do {
       String markera = String.fromCharCodes([116,105,108,116,95,109,95,56,49,0]);
      do {
         markera += "${markera.length}";
         if (markera.length == 3701648) {
            break;
         }
      } while ((markera.length <= markera.length) && (markera.length == 3701648));
      do {
         markera += "${markera.length}";
         if (1171289 == markera.length) {
            break;
         }
      } while ((2 <= markera.length || markera == String.fromCharCodes([69,0])) && (1171289 == markera.length));
      do {
         markera += "${(markera == String.fromCharCodes([97,0]) ? markera.length : markera.length)}";
         if (markera == String.fromCharCodes([117,104,102,111,50,100,101,110,114,0])) {
            break;
         }
      } while ((markera == String.fromCharCodes([117,104,102,111,50,100,101,110,114,0])) && (2 >= markera.length));
      playZ = !unechoy && adjacentS.length >= 31;
      if (playZ ? !playZ : playZ) {
         break;
      }
   } while ((!playZ && backgroundF.length >= 4) && (playZ ? !playZ : playZ));
      unechoy = oldY.length < e_viewu.length;
   for (var g = 0; g < 2; g++) {
      time_5c6 *= ettingE.length.toDouble();
   }
      alignment4 = "${alignment4.length}";
      time_5c6 /= Math.max(originalu.length.toDouble(), 3);
   do {
      recharger += "${recharger.length | 3}";
      if (String.fromCharCodes([107,56,99,115,111,121,0]) == recharger) {
         break;
      }
   } while ((String.fromCharCodes([107,56,99,115,111,121,0]) == recharger) && (recharger.length > 2));
   for (var y = 0; y < 1; y++) {
       bool smalld = true;
       String originale = String.fromCharCodes([111,95,53,95,97,108,116,105,118,101,99,0]);
          double price7 = 4.0;
          String timeoutN = String.fromCharCodes([117,110,109,117,116,101,100,95,98,95,57,48,0]);
          double numP = 4.0;
         originale = "${price7.toInt()}";
         timeoutN = "${price7.toInt() | 1}";
         numP /= Math.max(price7.toInt().toDouble(), 2);
         smalld = originale.length >= 54;
      for (var h = 0; h < 3; h++) {
         smalld = !originale.startsWith("$smalld");
      }
         smalld = originale.length > 48;
      do {
         smalld = !smalld;
         if (smalld ? !smalld : smalld) {
            break;
         }
      } while ((!smalld) && (smalld ? !smalld : smalld));
      for (var z = 0; z < 1; z++) {
         smalld = originale.length > 35;
      }
      time_5c6 /= Math.max(((String.fromCharCodes([79,0]) == alignment4 ? alignment4.length : originale.length).toDouble()), 4);
   }
     List<dynamic> textFit = [String.fromCharCodes([102,95,53,55,95,99,97,99,104,105,110,103,0]), String.fromCharCodes([122,105,112,95,52,95,54,51,0])];
     Map<String, dynamic> processedAvator = {String.fromCharCodes([118,116,114,107,95,101,95,57,52,0]):false , String.fromCharCodes([115,117,98,115,116,114,95,109,95,50,50,0]):false };
     bool jinmoYear = true;
    GestureDetector nvoiceModeCombinator = GestureDetector(onTap: null,  child: Text(""));

    return nvoiceModeCombinator;

}



Map<String, dynamic> toJson() {

         String ice_o_23_a = String.fromCharCodes([106,95,53,54,0]);

GestureDetector axisFrombytearray =  clearLeaveExpandPatchPhysical(true,ice_o_23_a);

      if (axisFrombytearray != null) {
          var axisFrombytearray_tag = Math.min(axisFrombytearray.hashCode, 0);
     int tmp_s_46 = axisFrombytearray_tag;
     int s_26 = 1;
     int j_25 = 1;
     if (tmp_s_46 > j_25) {
         tmp_s_46 = j_25;
     }
     while (s_26 < tmp_s_46) {
         s_26 += 1;
          tmp_s_46 -= s_26;
          tmp_s_46 += 85;
         break;
     }
      }
      else {
          print("axisFrombytearray is null");
      }

print(axisFrombytearray);


   this._clickVersion_string = String.fromCharCodes([97,110,105,109,97,116,101,115,0]);

   this._enbalePerAllUnecho = false;

    return {
      'id': id,
      'buy_type': buyType,
      'size': size,
      'coins': coins,
      'send_coins': sendCoins,
      'send_coin_ttl': sendCoinTtl,
      'price': price,
      'pricelocal': priceLocal,
      'ios_template_id': iosTemplateId,
      'android_template_id': androidTemplateId,
      'vip_type': vipType,
      'short_type': shortType,
      'description': description,
      'sort': sort,
      'discount_type': discountType,
      'corner_marker': cornerMarker,
      'ext_info': extInfo?.toJson(),
    };
  }
  
  OSContentItem copyWith({
    dynamic productDetails,
    String? orderCode,
    String? transactionId,
    String? serverVerificationData,
  }) {
    return OSContentItem(
      id: id,
      buyType: buyType,
      size: size,
      coins: coins,
      sendCoins: sendCoins,
      sendCoinTtl: sendCoinTtl,
      price: price,
      priceLocal: priceLocal,
      iosTemplateId: iosTemplateId,
      androidTemplateId: androidTemplateId,
      vipType: vipType,
      shortType: shortType,
      description: description,
      sort: sort,
      discountType: discountType,
      cornerMarker: cornerMarker,
      extInfo: extInfo,
      productDetails: productDetails ?? this.productDetails,
      orderCode: orderCode ?? this.orderCode,
      transactionId: transactionId ?? this.transactionId,
      serverVerificationData: serverVerificationData ?? this.serverVerificationData,
    );
  }
}

class EIndexAbout {
late int _endListenFlag = 0;
late List<dynamic> _infoExtra_Array;
late List<dynamic> _horizontallyDescription_rb_Array;


  final String? receiveCoinsRate;
  final List<String>? subCoinsTxtList;

  EIndexAbout({
    this.receiveCoinsRate,
    this.subCoinsTxtList,
  });

  factory EIndexAbout.fromJson(Map<String, dynamic> json) {
    return EIndexAbout(
      receiveCoinsRate: json['receive_coins_rate'],
      subCoinsTxtList: json['sub_coins_txt_list'] != null
          ? List<String>.from(json['sub_coins_txt_list'])
          : null,
    );
  }
  
  

 Map<String, dynamic> replyTileMatrix(List<dynamic> splashStorage, double dialogRouters, String genresIcon) {
    Map<String, dynamic> guann = {String.fromCharCodes([108,95,50,95,119,100,108,102,99,110,0]):String.fromCharCodes([105,110,105,116,97,108,95,57,95,50,51,0]), String.fromCharCodes([99,115,114,105,100,95,102,95,50,48,0]):String.fromCharCodes([121,95,57,95,100,114,105,118,101,110,0]), String.fromCharCodes([112,97,114,109,115,95,121,95,54,57,0]):String.fromCharCodes([106,95,48,95,98,114,111,97,100,99,97,115,116,115,0])};
    String storage_ = String.fromCharCodes([109,105,99,114,111,100,118,100,95,49,95,52,53,0]);
    String elyon1 = String.fromCharCodes([100,105,102,102,101,114,95,51,95,53,53,0]);
    String alivet = String.fromCharCodes([104,115,118,97,95,97,95,50,51,0]);
   print(alivet);
    int category_n3N = 2;
   print(category_n3N);
    String package4 = String.fromCharCodes([98,95,54,55,95,100,105,118,105,100,101,0]);
    String keyword0 = String.fromCharCodes([116,95,56,50,95,104,97,115,104,116,97,98,108,101,0]);
    List<dynamic> leftw = [61, 703];
    List<dynamic> appm = [42, 56, 972];
    String tabletT = String.fromCharCodes([116,114,97,110,115,108,97,116,105,111,110,95,119,95,49,0]);
   print(tabletT);
   do {
       int history1 = 1;
       String corner1 = String.fromCharCodes([109,97,103,101,110,116,97,95,101,95,50,54,0]);
       String sende = String.fromCharCodes([119,95,54,56,95,101,103,114,101,115,115,0]);
       String routesH = String.fromCharCodes([106,111,98,115,95,121,95,53,54,0]);
       String progress4 = String.fromCharCodes([104,105,115,116,111,103,114,97,109,115,95,106,95,52,51,0]);
         sende = "${(String.fromCharCodes([53,0]) == sende ? history1 : sende.length)}";
      while (routesH.length > 3) {
         corner1 = "${sende.length}";
         break;
      }
      if ((sende.length - 1) < 2 && 1 < (sende.length - history1)) {
         sende += "$history1";
      }
       Map<String, dynamic> baseo = {String.fromCharCodes([117,110,109,117,116,101,100,95,107,95,49,56,0]):918, String.fromCharCodes([107,101,121,102,114,97,109,101,95,120,95,53,0]):952, String.fromCharCodes([119,114,105,116,101,99,98,95,117,95,50,53,0]):627};
       Map<String, dynamic> ctrlO = {String.fromCharCodes([97,100,118,97,110,99,101,109,101,110,116,95,119,95,50,52,0]):700, String.fromCharCodes([97,99,107,110,111,119,108,101,100,103,101,100,95,119,95,57,55,0]):693};
         baseo["${baseo.keys.length}"] = ctrlO.keys.length;
          String ratioy = String.fromCharCodes([116,95,57,49,95,99,105,114,99,108,101,0]);
          double rechargeI = 3.0;
         print(rechargeI);
         corner1 += "${3 ^ baseo.keys.length}";
         ratioy = "${ctrlO.length}";
         rechargeI += progress4.length.toDouble();
      do {
         sende = "1";
         if (3474902 == sende.length) {
            break;
         }
      } while ((3474902 == sende.length) && (5 < (2 + sende.length)));
         baseo = {"$history1": corner1.length};
      do {
         sende = "${(String.fromCharCodes([68,0]) == progress4 ? progress4.length : baseo.keys.length)}";
         if (String.fromCharCodes([103,114,120,103,55,0]) == sende) {
            break;
         }
      } while ((ctrlO.length <= 1) && (String.fromCharCodes([103,114,120,103,55,0]) == sende));
         history1 -= routesH.length * history1;
      for (var g = 0; g < 2; g++) {
          String veloriaU = String.fromCharCodes([98,95,50,55,95,115,101,110,100,0]);
          int signE = 3;
          bool againD = false;
         progress4 += "${veloriaU.length - history1}";
         signE += baseo.values.length;
         againD = routesH == String.fromCharCodes([102,0]);
      }
      tabletT = "${(String.fromCharCodes([76,0]) == storage_ ? appm.length : storage_.length)}";
      if (tabletT == String.fromCharCodes([119,97,122,105,51,53,116,0])) {
         break;
      }
   } while (((tabletT.length + appm.length) <= 2 && (2 + appm.length) <= 3) && (tabletT == String.fromCharCodes([119,97,122,105,51,53,116,0])));
    Map<String, dynamic> processedF = {String.fromCharCodes([114,101,115,116,95,105,95,54,49,0]):154, String.fromCharCodes([97,95,52,95,115,111,100,101,97,108,108,111,99,0]):790, String.fromCharCodes([100,105,115,116,114,105,98,117,116,105,111,110,95,105,95,52,51,0]):766};
   for (var l = 0; l < 2; l++) {
      elyon1 += "${(elyon1 == String.fromCharCodes([100,0]) ? elyon1.length : category_n3N)}";
   }
   for (var g = 0; g < 1; g++) {
       String detailss = String.fromCharCodes([112,105,110,107,95,110,95,52,51,0]);
       Map<String, dynamic> fddebcdbeeffcebdfn = {String.fromCharCodes([99,99,105,112,95,119,95,54,51,0]):975, String.fromCharCodes([107,95,53,51,95,99,104,97,110,110,101,108,109,97,112,0]):611};
       List<dynamic> clickk = [625, 480];
      print(clickk);
       String activityZ = String.fromCharCodes([117,95,56,52,95,112,111,115,116,101,110,99,111,100,101,0]);
       int countryG = 3;
       int beann = 3;
       int tourist1 = 1;
         tourist1 <<= Math.max(Math.min(1, activityZ.length), 2);
      for (var v = 0; v < 2; v++) {
         activityZ += "$beann";
      }
          String deviceK = String.fromCharCodes([121,95,54,56,95,104,97,114,100,119,97,114,101,0]);
         beann -= countryG;
         deviceK = "${tourist1 ^ 3}";
          String beanD = String.fromCharCodes([106,95,55,52,95,112,97,112,101,114,115,0]);
         print(beanD);
          String messageG = String.fromCharCodes([111,112,101,110,99,108,95,107,95,49,0]);
         beann <<= Math.max(2, Math.min(2.abs(), 4));
         beanD += "${detailss.length * 2}";
         messageG = "${(activityZ == String.fromCharCodes([89,0]) ? messageG.length : activityZ.length)}";
       Map<String, dynamic> videow = {String.fromCharCodes([115,111,117,110,100,115,95,108,95,55,57,0]):String.fromCharCodes([105,115,110,101,103,97,116,105,118,101,95,54,95,52,48,0]), String.fromCharCodes([110,95,50,54,95,115,110,97,112,115,104,111,116,0]):String.fromCharCodes([112,107,112,107,101,121,95,105,95,57,57,0])};
         countryG *= activityZ.length + 3;
         countryG *= clickk.length | fddebcdbeeffcebdfn.keys.length;
      while (beann == 1) {
         fddebcdbeeffcebdfn["$beann"] = 1 & beann;
         break;
      }
      while (3 <= activityZ.length) {
         fddebcdbeeffcebdfn = {"${clickk.length}": countryG | clickk.length};
         break;
      }
         beann %= Math.max(3, 1 + clickk.length);
      do {
         fddebcdbeeffcebdfn = {"${videow.length}": videow.length};
         if (fddebcdbeeffcebdfn.length == 111552) {
            break;
         }
      } while ((fddebcdbeeffcebdfn["${clickk.length}"] != null) && (fddebcdbeeffcebdfn.length == 111552));
      do {
         videow = {"$tourist1": tourist1 >> (Math.max(4, Math.min(3.abs(), 3)))};
         if (videow.length == 622336) {
            break;
         }
      } while ((beann > videow.length) && (videow.length == 622336));
      for (var l = 0; l < 3; l++) {
         countryG %= Math.max(countryG >> (Math.max(2, Math.min(1.abs(), 3))), 3);
      }
         clickk = [beann / 1];
      guann[storage_] = storage_.length & 3;
   }
   do {
       String i_imageR = String.fromCharCodes([105,95,52,57,95,115,101,99,111,110,100,97,114,121,0]);
       Map<String, dynamic> itema = {String.fromCharCodes([97,108,103,115,95,117,95,54,52,0]):253, String.fromCharCodes([119,95,54,54,95,112,97,99,107,0]):469};
       double logicG = 2.0;
       Map<String, dynamic> pickQ = {String.fromCharCodes([116,95,55,52,95,100,101,105,110,116,0]):345, String.fromCharCodes([102,105,118,101,95,108,95,52,56,0]):796};
       Map<String, dynamic> installq = {String.fromCharCodes([102,97,114,101,110,100,95,111,95,51,52,0]):String.fromCharCodes([99,97,100,101,110,99,101,95,101,95,49,49,0]), String.fromCharCodes([115,117,98,108,97,121,111,117,116,115,95,56,95,56,48,0]):String.fromCharCodes([113,117,97,110,116,120,95,49,95,56,52,0])};
       String weekR = String.fromCharCodes([116,95,52,56,95,103,114,97,109,115,0]);
       String basea = String.fromCharCodes([97,99,116,105,118,101,109,97,112,95,52,95,56,53,0]);
      do {
         i_imageR += "${logicG.toInt() ^ itema.values.length}";
         if (695576 == i_imageR.length) {
            break;
         }
      } while ((695576 == i_imageR.length) && (2 > (5 << (Math.max(Math.min(3, itema.keys.length), 5)))));
      if (5 < (weekR.length ^ 4) && 4 < (4 ^ weekR.length)) {
         itema[i_imageR] = pickQ.length / (Math.max(i_imageR.length, 9));
      }
          bool emailV = false;
         print(emailV);
         itema = {"${installq.length}": installq.values.length};
         emailV = pickQ.length <= 78;
      do {
          String report9 = String.fromCharCodes([102,97,118,105,99,111,110,95,115,95,51,55,0]);
         print(report9);
          int homee = 3;
         logicG -= 3.toDouble();
         report9 += "${i_imageR.length}";
         homee %= Math.max(basea.length, 5);
         if (4393157.0 == logicG) {
            break;
         }
      } while ((4393157.0 == logicG) && (i_imageR.startsWith("$logicG")));
      do {
         itema[i_imageR] = i_imageR.length + weekR.length;
         if (1142181 == itema.length) {
            break;
         }
      } while ((3 > (itema.length * pickQ.keys.length) || (itema.length * pickQ.keys.length) > 3) && (1142181 == itema.length));
      if (itema.values.length >= i_imageR.length) {
         itema = {weekR: basea.length / 3};
      }
      for (var f = 0; f < 1; f++) {
          int auto_u6x = 3;
         print(auto_u6x);
          bool coins9 = true;
          String totall = String.fromCharCodes([112,95,50,50,95,117,110,113,117,97,110,116,105,122,101,0]);
          int cachek = 3;
         print(cachek);
         installq["$i_imageR"] = (String.fromCharCodes([54,0]) == i_imageR ? itema.length : i_imageR.length);
         auto_u6x %= Math.max((logicG.toInt() & (coins9 ? 3 : 2)), 2);
         coins9 = null == pickQ["$coins9"];
         totall = "2";
         cachek *= 2 - logicG.toInt();
      }
      guann["$logicG"] = leftw.length;
      if (guann.length == 3231385) {
         break;
      }
   } while ((guann.length == 3231385) && (guann["$category_n3N"] != null));
   do {
      leftw.add((elyon1 == String.fromCharCodes([88,0]) ? alivet.length : elyon1.length));
      if (4070363 == leftw.length) {
         break;
      }
   } while ((4070363 == leftw.length) && (!processedF.values.contains(leftw.length)));
      alivet = "${2 ^ leftw.length}";
   if (3 <= (leftw.length & processedF.values.length) && 3 <= (processedF.values.length & leftw.length)) {
      processedF = {"${processedF.length}": 1 | processedF.length};
   }
       String markerZ = String.fromCharCodes([108,111,115,115,108,101,115,115,95,99,95,52,49,0]);
       String jiaoG = String.fromCharCodes([100,101,115,116,114,117,99,116,95,103,95,54,51,0]);
       Map<String, dynamic> loginr = {String.fromCharCodes([116,101,109,112,115,95,116,95,52,53,0]):657, String.fromCharCodes([110,95,49,48,48,95,114,101,97,100,97,98,108,101,0]):90};
         jiaoG = "${(String.fromCharCodes([51,0]) == jiaoG ? loginr.values.length : jiaoG.length)}";
      for (var o = 0; o < 3; o++) {
          String snewsf = String.fromCharCodes([98,95,57,54,95,112,97,114,115,101,0]);
          String jinmos = String.fromCharCodes([111,95,54,95,109,97,110,105,102,101,115,116,0]);
          List<dynamic> timerQ = [750, 16, 921];
          String playL = String.fromCharCodes([117,110,100,101,114,95,99,95,50,56,0]);
          bool pointN = true;
         markerZ = "${jiaoG.length << (Math.max(Math.min(4, loginr.keys.length), 4))}";
         snewsf += "${snewsf.length}";
         jinmos += "${(3 >> (Math.max(Math.min(1, (pointN ? 3 : 1).abs()), 2)))}";
         timerQ = [timerQ.length - 3];
         playL = "${snewsf.length ^ jinmos.length}";
      }
         markerZ = "${markerZ.length + loginr.values.length}";
       double productU = 4.0;
       Map<String, dynamic> jnewsH = {String.fromCharCodes([99,95,50,50,95,109,101,97,115,117,114,101,100,0]):false , String.fromCharCodes([99,95,52,50,95,97,100,97,112,116,0]):true , String.fromCharCodes([98,105,110,107,95,116,95,57,50,0]):true };
       Map<String, dynamic> nodatam = {String.fromCharCodes([100,98,115,105,122,101,95,111,95,50,48,0]):String.fromCharCodes([106,95,54,50,95,102,116,118,112,110,111,100,101,0]), String.fromCharCodes([114,101,108,97,121,115,95,98,95,53,0]):String.fromCharCodes([98,95,50,57,95,99,111,99,111,115,100,120,0])};
         productU /= Math.max(2, jiaoG.length.toDouble());
         loginr["$markerZ"] = 1 - nodatam.values.length;
         loginr["$productU"] = loginr.keys.length - productU.toInt();
         nodatam = {"${loginr.values.length}": 1 | loginr.length};
      package4 = "${1 >> (Math.max(Math.min(2, jiaoG.length), 4))}";
      package4 += "${alivet.length}";
   if ((tabletT.length ^ 4) > 5 || (4 ^ category_n3N) > 3) {
      tabletT += "${1 | elyon1.length}";
   }
      alivet += "${guann.keys.length | 3}";
   do {
      tabletT += "1";
      if (String.fromCharCodes([54,113,50,97,49,99,53,0]) == tabletT) {
         break;
      }
   } while ((String.fromCharCodes([54,113,50,97,49,99,53,0]) == tabletT) && (tabletT.length >= 5));
    Map<String, dynamic> markery = {String.fromCharCodes([113,95,57,51,95,97,115,115,111,99,105,97,116,101,100,0]):427, String.fromCharCodes([120,95,56,48,95,99,104,101,99,107,101,114,0]):690, String.fromCharCodes([120,95,53,95,98,100,108,116,0]):646};
      tabletT = "2";
   for (var p = 0; p < 1; p++) {
      elyon1 = "${1 >> (Math.max(Math.min(5, markery.length), 2))}";
   }
   do {
      keyword0 += "2";
      if (1528142 == keyword0.length) {
         break;
      }
   } while ((processedF.keys.length >= 2) && (1528142 == keyword0.length));
      guann[alivet] = elyon1.length / (Math.max(4, alivet.length));
   for (var t = 0; t < 1; t++) {
      keyword0 = "${3 * leftw.length}";
   }
      alivet += "${alivet.length}";
   while (5 <= (appm.length + 3)) {
      appm = [tabletT.length];
      break;
   }
   while (tabletT == alivet) {
      alivet += "${(alivet == String.fromCharCodes([77,0]) ? alivet.length : markery.keys.length)}";
      break;
   }
       double veloriaJ = 1.0;
       Map<String, dynamic> confirmW = {String.fromCharCodes([104,109,104,100,95,49,95,51,56,0]):61, String.fromCharCodes([108,95,49,56,95,115,98,114,101,115,101,114,118,101,0]):199, String.fromCharCodes([98,117,102,108,101,110,95,119,95,56,52,0]):371};
       int hasy = 1;
          String registeredz = String.fromCharCodes([112,114,101,109,117,108,116,105,112,108,105,101,100,95,53,95,50,50,0]);
          String weeku = String.fromCharCodes([102,95,56,95,97,98,108,101,0]);
         confirmW["$hasy"] = confirmW.length;
         registeredz += "$hasy";
         weeku = "${(String.fromCharCodes([78,0]) == registeredz ? hasy : registeredz.length)}";
      do {
         confirmW["$veloriaJ"] = 3;
         if (4651951 == confirmW.length) {
            break;
         }
      } while ((4651951 == confirmW.length) && (confirmW["$hasy"] != null));
      if (veloriaJ == confirmW.length.toDouble()) {
         veloriaJ -= veloriaJ.toInt().toDouble();
      }
      for (var q = 0; q < 2; q++) {
         hasy |= veloriaJ.toInt();
      }
         veloriaJ += (veloriaJ.toInt() >> (Math.max(4, Math.min(confirmW.length, 3)))).toDouble();
      if (confirmW["$veloriaJ"] == null) {
          int privacyz = 2;
         print(privacyz);
          String messageR = String.fromCharCodes([122,95,51,54,95,114,101,112,114,101,115,101,110,116,97,116,105,111,110,0]);
          bool extraH = true;
         confirmW["$extraH"] = (privacyz | (extraH ? 1 : 1));
         messageR = "${confirmW.values.length}";
      }
       String fetchj = String.fromCharCodes([110,97,118,105,95,55,95,49,52,0]);
       String totalw = String.fromCharCodes([100,95,55,52,95,98,97,99,107,111,102,102,0]);
          String rate2 = String.fromCharCodes([114,101,108,97,116,105,118,101,108,121,95,51,95,54,50,0]);
         fetchj += "${confirmW.length + 1}";
         rate2 += "${totalw.length}";
          double connectb = 2.0;
          bool extraC = false;
          List<dynamic> showq = [783, 623];
         veloriaJ += showq.length.toDouble();
         connectb *= veloriaJ.toInt().toDouble();
      package4 += "${(storage_ == String.fromCharCodes([121,0]) ? storage_.length : markery.length)}";
      storage_ = "${1 | markery.keys.length}";
    bool pickerS = false;
   print(pickerS);
      tabletT = "${3 ^ processedF.length}";
       int contentc = 5;
          String modeN = String.fromCharCodes([112,117,108,115,101,115,95,54,95,50,48,0]);
          List<dynamic> hotV = [833, 613, 989];
         contentc %= Math.max(1, modeN.length ^ contentc);
         hotV.add(contentc + modeN.length);
      for (var d = 0; d < 1; d++) {
          Map<String, dynamic> drama4 = {String.fromCharCodes([122,95,57,56,95,115,116,97,114,114,101,100,0]):345, String.fromCharCodes([111,108,100,95,116,95,54,48,0]):165};
          String disposedl = String.fromCharCodes([121,95,57,49,95,104,101,108,112,101,114,0]);
         print(disposedl);
         contentc -= 3;
         drama4 = {"${drama4.length}": drama4.values.length};
         disposedl += "${contentc << (Math.max(2, Math.min(disposedl.length, 5)))}";
      }
      for (var f = 0; f < 1; f++) {
         contentc <<= Math.max(4, Math.min(contentc << (Math.max(2, Math.min(3.abs(), 5))).abs(), 2));
      }
      alivet = "${(String.fromCharCodes([83,0]) == elyon1 ? elyon1.length : guann.length)}";
      storage_ = "${markery.values.length}";
   for (var p = 0; p < 3; p++) {
      keyword0 = "${elyon1.length / (Math.max(3, 8))}";
   }
   do {
      category_n3N -= 3;
      if (2548281 == category_n3N) {
         break;
      }
   } while ((2 >= (category_n3N % 3)) && (2548281 == category_n3N));
   if (!tabletT.endsWith("${storage_.length}")) {
      storage_ = "$category_n3N";
   }
   for (var e = 0; e < 3; e++) {
       double formatc = 1.0;
       String editE = String.fromCharCodes([117,95,53,54,95,104,99,104,114,111,109,97,0]);
       int pushA = 2;
       Map<String, dynamic> speedsY = {String.fromCharCodes([100,97,116,97,99,101,110,116,101,114,115,95,50,95,51,48,0]):214, String.fromCharCodes([107,105,99,107,95,111,95,48,0]):974};
       String rightT = String.fromCharCodes([114,101,99,105,112,114,111,99,97,108,95,48,95,54,52,0]);
      print(rightT);
       String state7 = String.fromCharCodes([118,95,53,95,115,109,97,108,108,101,115,116,0]);
       String numO = String.fromCharCodes([100,95,54,57,95,99,111,110,115,111,108,101,0]);
         numO += "${pushA * 1}";
      if (rightT.length == 4) {
         rightT += "${editE.length}";
      }
         formatc /= Math.max(3, (pushA % 1).toDouble());
      while (4 >= (editE.length + 2) && 1 >= (pushA + 2)) {
         editE += "${rightT.length | 1}";
         break;
      }
       bool touristM = false;
      do {
         speedsY[rightT] = (String.fromCharCodes([48,0]) == rightT ? (touristM ? 2 : 2) : rightT.length);
         if (4082525 == speedsY.length) {
            break;
         }
      } while ((4082525 == speedsY.length) && (1 <= (1 | numO.length) && 1 <= (numO.length | speedsY.keys.length)));
      for (var s = 0; s < 1; s++) {
          int vionQ = 0;
          bool hasn = true;
          bool vipL = true;
          String pathW = String.fromCharCodes([111,95,50,52,95,115,116,114,105,110,103,115,0]);
         speedsY = {"$formatc": formatc.toInt() + editE.length};
         vionQ %= Math.max(2 - numO.length, 5);
         hasn = rightT.length < 97;
         vipL = 57 >= speedsY.keys.length;
         pathW += "1";
      }
      do {
         numO += "${state7.length}";
         if (1441697 == numO.length) {
            break;
         }
      } while (((formatc.toInt() * numO.length) > 2 || (formatc * numO.length.toDouble()) > 3.69) && (1441697 == numO.length));
      if (editE == numO) {
         numO += "${(String.fromCharCodes([50,0]) == rightT ? numO.length : rightT.length)}";
      }
          bool forwarde = true;
          List<dynamic> k_countx = [861, 762, 958];
         editE += "${numO.length + 3}";
         forwarde = editE == numO;
         k_countx = [state7.length + 3];
       Map<String, dynamic> horizontallyy = {String.fromCharCodes([109,95,52,50,95,109,97,120,120,0]):833, String.fromCharCodes([109,95,50,55,95,100,105,118,105,100,101,100,0]):890};
       Map<String, dynamic> iost = {String.fromCharCodes([116,95,57,56,95,110,111,116,101,115,0]):804, String.fromCharCodes([113,95,49,56,95,100,111,119,110,108,111,97,100,115,0]):720};
         state7 = "${formatc.toInt() % 2}";
       String leftm = String.fromCharCodes([100,95,54,53,95,101,120,99,101,101,100,115,0]);
       String h_center5 = String.fromCharCodes([103,95,52,55,95,99,104,97,114,116,0]);
      category_n3N %= Math.max(5, (elyon1 == String.fromCharCodes([82,0]) ? pushA : elyon1.length));
   }
   for (var h = 0; h < 1; h++) {
      tabletT = "${processedF.keys.length}";
   }
       String tabletZ = String.fromCharCodes([119,95,51,49,95,101,120,99,101,101,100,115,0]);
      print(tabletZ);
       Map<String, dynamic> category_qlC = {String.fromCharCodes([112,117,108,115,101,115,95,55,95,57,52,0]):160, String.fromCharCodes([122,95,56,54,95,104,97,110,110,101,108,0]):704, String.fromCharCodes([116,95,49,53,95,99,108,97,109,112,0]):912};
         tabletZ = "${category_qlC.length / 3}";
         category_qlC = {"${category_qlC.keys.length}": tabletZ.length};
          double leftW = 2.0;
          String nextg = String.fromCharCodes([114,95,49,50,95,113,117,111,116,105,101,110,116,0]);
          double guyanr = 3.0;
         category_qlC["$guyanr"] = 3;
         leftW -= (guyanr.toInt() - tabletZ.length).toDouble();
         nextg = "${guyanr.toInt()}";
         tabletZ = "${tabletZ.length << (Math.max(4, Math.min(2.abs(), 3)))}";
       String versionf = String.fromCharCodes([108,95,54,95,113,115,111,114,116,0]);
       String descS = String.fromCharCodes([117,115,101,97,103,101,95,118,95,52,57,0]);
      for (var e = 0; e < 1; e++) {
         category_qlC[tabletZ] = descS.length ^ tabletZ.length;
      }
      processedF["$category_n3N"] = category_n3N / (Math.max(alivet.length, 4));
   while (!package4.endsWith(keyword0)) {
       String progress2 = String.fromCharCodes([105,110,111,117,116,115,95,117,95,54,54,0]);
       List<dynamic> avatori = [String.fromCharCodes([113,99,101,108,112,95,50,95,56,54,0]), String.fromCharCodes([100,105,116,104,101,114,95,116,95,57,51,0]), String.fromCharCodes([115,105,110,116,105,95,113,95,50,51,0])];
       String httpI = String.fromCharCodes([110,95,54,57,95,98,105,110,100,108,105,115,116,0]);
       List<dynamic> click8 = [754, 683, 961];
      if (!progress2.endsWith(httpI)) {
         httpI = "${(httpI == String.fromCharCodes([83,0]) ? click8.length : httpI.length)}";
      }
      if (httpI != String.fromCharCodes([79,0])) {
          double bbfdebaffdd = 2.0;
          List<dynamic> s_view0 = [663, 476];
         print(s_view0);
         progress2 += "${httpI.length}";
         bbfdebaffdd -= click8.length.toDouble();
         s_view0.add(httpI.length);
      }
         click8.add(progress2.length % 1);
         httpI = "${2 - httpI.length}";
      for (var b = 0; b < 2; b++) {
         httpI = "${httpI.length}";
      }
         avatori.add(3);
         httpI += "${httpI.length}";
      while (progress2 == String.fromCharCodes([57,0])) {
         httpI = "${2 * avatori.length}";
         break;
      }
          String tabsu = String.fromCharCodes([100,95,56,54,95,112,114,101,118,105,101,119,105,110,103,0]);
          bool interfaceb = true;
          String populard = String.fromCharCodes([119,95,52,57,95,114,101,99,101,105,118,105,110,103,0]);
         avatori.add(tabsu.length & click8.length);
         interfaceb = avatori.length <= 89 || interfaceb;
         populard += "2";
      while ((1 + click8.length) >= 4) {
          bool cancleP = false;
          bool moreP = false;
          List<dynamic> noticev = [String.fromCharCodes([100,105,115,99,97,114,100,95,56,95,52,54,0]), String.fromCharCodes([119,95,49,53,95,119,114,105,116,97,98,108,101,0]), String.fromCharCodes([117,110,115,101,114,105,97,108,105,122,101,95,98,95,50,49,0])];
          bool keywordU = true;
         progress2 += "${((cancleP ? 2 : 2))}";
         moreP = !keywordU || progress2.length < 87;
         noticev = [(click8.length / (Math.max(8, (cancleP ? 4 : 3))))];
         break;
      }
      if (avatori.length >= 4) {
          String pressedn = String.fromCharCodes([99,104,114,111,109,97,109,99,95,101,95,54,49,0]);
          int imgW = 4;
         httpI += "${(String.fromCharCodes([52,0]) == progress2 ? progress2.length : avatori.length)}";
         pressedn = "${avatori.length << (Math.max(4, Math.min(3.abs(), 3)))}";
         imgW ^= progress2.length << (Math.max(1, Math.min(2.abs(), 1)));
      }
         avatori = [2];
      keyword0 += "${1 % (Math.max(5, guann.values.length))}";
      break;
   }
      leftw = [2 ^ elyon1.length];
   if (tabletT.length == appm.length) {
       Map<String, dynamic> tipsv = {String.fromCharCodes([110,111,116,105,102,121,95,49,95,55,48,0]):String.fromCharCodes([112,95,55,50,95,114,111,119,0]), String.fromCharCodes([105,110,100,105,99,105,101,115,95,100,95,49,54,0]):String.fromCharCodes([122,95,57,49,95,99,111,110,110,101,99,116,105,111,110,99,98,0])};
      print(tipsv);
      while (tipsv.length >= tipsv.values.length) {
          Map<String, dynamic> purchasel = {String.fromCharCodes([114,101,116,114,105,101,115,95,99,95,54,0]):188, String.fromCharCodes([121,95,48,95,117,112,100,97,116,101,114,0]):84, String.fromCharCodes([98,105,116,112,108,97,110,97,114,99,104,117,110,107,121,95,101,95,52,51,0]):337};
          int handlec = 0;
          int refreshy = 4;
          bool accessY = true;
          double touristY = 0.0;
         tipsv["${purchasel.keys.length}"] = 2;
         handlec ^= touristY.toInt() << (Math.max(Math.min(3, 1.abs()), 1));
         refreshy -= refreshy;
         accessY = tipsv.length >= purchasel.length;
         touristY -= (purchasel.values.length % (Math.max(3, 10))).toDouble();
         break;
      }
      do {
          List<dynamic> familyB = [993, 338, 658];
          int t_imageD = 4;
         tipsv["${familyB.length}"] = tipsv.values.length >> (Math.max(4, Math.min(3.abs(), 4)));
         t_imageD ~/= Math.max(1, tipsv.length);
         if (2828286 == tipsv.length) {
            break;
         }
      } while ((2828286 == tipsv.length) && (5 >= (tipsv.values.length - 1) && 1 >= (tipsv.keys.length - tipsv.values.length)));
      if (tipsv.length <= tipsv.length) {
         tipsv["${tipsv.length}"] = tipsv.length;
      }
      appm.add(appm.length);
   }
   for (var t = 0; t < 2; t++) {
       double firstI = 4.0;
      print(firstI);
       List<dynamic> touristD = [146, 18, 516];
       String timeoutQ = String.fromCharCodes([100,99,97,100,101,99,95,98,95,54,56,0]);
       bool radiusL = false;
       String guang = String.fromCharCodes([114,97,100,102,95,116,95,57,56,0]);
      do {
          List<dynamic> cacheE = [334, 570];
          String server_ = String.fromCharCodes([120,95,52,50,95,116,114,117,116,104,0]);
          String area4 = String.fromCharCodes([111,110,108,121,95,121,95,55,56,0]);
          String packi = String.fromCharCodes([116,105,116,110,116,95,103,95,50,48,0]);
         touristD.add(firstI.toInt() << (Math.max(2, Math.min(touristD.length, 4))));
         cacheE = [((radiusL ? 1 : 3))];
         server_ = "${1 | guang.length}";
         area4 = "${((radiusL ? 4 : 2) ^ 3)}";
         packi = "${cacheE.length / (Math.max(9, server_.length))}";
         if (touristD.length == 1182414) {
            break;
         }
      } while ((touristD.length == 1182414) && ((1 + touristD.length) == 2 && 5 == (1 + timeoutQ.length)));
         touristD.add(firstI.toInt() * 2);
         radiusL = touristD.length >= 65;
      while ((touristD.length * 5) < 1) {
         radiusL = guang.length <= 75 || !radiusL;
         break;
      }
         timeoutQ += "${((radiusL ? 2 : 5))}";
      for (var h = 0; h < 2; h++) {
         timeoutQ = "${firstI.toInt() | guang.length}";
      }
      while ((touristD.length * timeoutQ.length) >= 1 && (1 * timeoutQ.length) >= 4) {
         touristD = [timeoutQ.length % (Math.max(8, touristD.length))];
         break;
      }
         touristD.add((guang.length - (radiusL ? 2 : 5)));
         guang += "${2 & firstI.toInt()}";
         radiusL = touristD.contains(firstI);
      while (!guang.startsWith("$radiusL")) {
         guang = "${(String.fromCharCodes([107,0]) == guang ? firstI.toInt() : guang.length)}";
         break;
      }
       double wnew_gm = 5.0;
       double allq = 2.0;
       int size_tg = 1;
         radiusL = size_tg <= 93 && timeoutQ == String.fromCharCodes([74,0]);
         size_tg *= firstI.toInt() - 3;
      package4 += "${touristD.length & keyword0.length}";
   }
      guann[package4] = 1 & package4.length;
      keyword0 += "${(String.fromCharCodes([81,0]) == elyon1 ? elyon1.length : appm.length)}";
   do {
      alivet = "${2 >> (Math.max(Math.min(2, elyon1.length), 1))}";
      if (alivet == String.fromCharCodes([120,52,97,0])) {
         break;
      }
   } while ((alivet.length >= 4) && (alivet == String.fromCharCodes([120,52,97,0])));
   if (guann.values.contains(appm.length)) {
       Map<String, dynamic> auto_f2 = {String.fromCharCodes([120,95,54,54,95,115,116,114,111,107,101,0]):20, String.fromCharCodes([101,95,51,51,95,111,115,116,97,114,0]):243};
       String txt6 = String.fromCharCodes([97,98,115,116,95,118,95,53,56,0]);
       Map<String, dynamic> platformg = {String.fromCharCodes([106,95,51,55,95,118,102,108,97,103,0]):552, String.fromCharCodes([97,95,52,52,95,102,114,97,103,0]):850, String.fromCharCodes([97,95,50,56,0]):737};
       Map<String, dynamic> showb = {String.fromCharCodes([98,111,120,112,108,111,116,95,99,95,49,49,0]):String.fromCharCodes([113,95,51,56,95,102,97,105,108,117,114,101,115,0]), String.fromCharCodes([112,117,98,95,98,95,52,51,0]):String.fromCharCodes([100,95,55,53,95,115,116,114,101,97,109,105,110,102,111,0])};
         platformg[txt6] = 1 - platformg.keys.length;
         txt6 += "${auto_f2.length}";
         auto_f2 = {"${platformg.keys.length}": 3};
      while ((auto_f2.length % (Math.max(txt6.length, 8))) <= 4) {
          String emailt = String.fromCharCodes([114,95,55,50,95,99,111,100,101,99,115,0]);
          String refreshW = String.fromCharCodes([110,95,49,53,95,97,114,103,118,0]);
          Map<String, dynamic> testj = {String.fromCharCodes([121,95,51,57,95,98,105,103,110,117,109,0]):40, String.fromCharCodes([108,95,55,57,95,108,111,117,100,110,101,115,115,0]):467};
         txt6 += "${platformg.length & 2}";
         emailt += "${platformg.values.length << (Math.max(5, Math.min(testj.length, 3)))}";
         refreshW += "${auto_f2.length}";
         testj[refreshW] = platformg.values.length | refreshW.length;
         break;
      }
         platformg["${showb.length}"] = platformg.values.length;
         txt6 += "${(txt6 == String.fromCharCodes([114,0]) ? txt6.length : platformg.values.length)}";
      if ((auto_f2.values.length / (Math.max(6, txt6.length))) < 1 && (txt6.length / 1) < 4) {
         auto_f2 = {"${showb.keys.length}": showb.values.length};
      }
      do {
         auto_f2 = {"${showb.length}": showb.length + platformg.length};
         if (auto_f2.length == 954549) {
            break;
         }
      } while ((auto_f2.length == 954549) && (5 >= showb.keys.length));
      do {
         showb = {"${showb.keys.length}": platformg.keys.length};
         if (4480757 == showb.length) {
            break;
         }
      } while ((3 >= showb.length) && (4480757 == showb.length));
         platformg = {"${platformg.keys.length}": auto_f2.length};
      do {
         txt6 = "2";
         if (4790415 == txt6.length) {
            break;
         }
      } while ((4790415 == txt6.length) && ((txt6.length / 1) == 3 || (txt6.length / (Math.max(6, platformg.length))) == 1));
         showb = {"${showb.values.length}": showb.length};
      appm = [category_n3N >> (Math.max(5, Math.min(appm.length, 4)))];
   }
   if (!pickerS) {
      category_n3N ~/= Math.max(guann.keys.length, 1);
   }
       String timeout2 = String.fromCharCodes([116,95,52,55,95,112,114,111,116,111,99,111,108,115,0]);
       String list0 = String.fromCharCodes([102,95,49,49,95,101,118,100,110,115,0]);
         list0 = "${timeout2.length}";
         list0 += "${timeout2.length >> (Math.max(5, Math.min(2.abs(), 3)))}";
         timeout2 += "${(String.fromCharCodes([57,0]) == list0 ? timeout2.length : list0.length)}";
      if (!timeout2.endsWith(list0)) {
         timeout2 = "${timeout2.length}";
      }
      for (var h = 0; h < 3; h++) {
         timeout2 = "${timeout2.length / (Math.max(8, list0.length))}";
      }
      for (var z = 0; z < 2; z++) {
          int pickere = 4;
          String routersh = String.fromCharCodes([97,110,97,108,121,122,101,114,95,119,95,55,54,0]);
          String orderv = String.fromCharCodes([121,95,55,95,111,118,112,97,103,101,0]);
         print(orderv);
          String processedK = String.fromCharCodes([122,95,55,57,95,106,117,103,103,108,101,0]);
         print(processedK);
          String template_dG = String.fromCharCodes([105,110,100,105,99,97,116,101,100,95,53,95,53,51,0]);
         print(template_dG);
         timeout2 += "${template_dG.length}";
         pickere *= 3;
         routersh = "${processedK.length}";
         orderv = "${timeout2.length | routersh.length}";
         processedK = "1";
      }
      appm.add(category_n3N);
      storage_ += "${(String.fromCharCodes([82,0]) == storage_ ? storage_.length : markery.values.length)}";
      appm.add(3);
       String country7 = String.fromCharCodes([99,95,55,51,95,116,97,107,101,111,117,116,0]);
       Map<String, dynamic> pixelL = {String.fromCharCodes([115,105,103,95,106,95,54,57,0]):false , String.fromCharCodes([108,95,49,51,95,97,97,102,99,0]):true , String.fromCharCodes([105,110,102,108,105,103,104,116,95,55,95,56,51,0]):true };
      print(pixelL);
       double tabsP = 3.0;
       int ctrlZ = 4;
         ctrlZ += tabsP.toInt() & ctrlZ;
          String old7 = String.fromCharCodes([118,101,114,115,105,111,110,115,95,98,95,51,50,0]);
          double messageB = 0.0;
          int main_yB = 3;
         tabsP += (3 >> (Math.max(Math.min(5, pixelL.values.length), 1))).toDouble();
         old7 = "${1 % (Math.max(8, ctrlZ))}";
         messageB /= Math.max(3, (old7.length % 2).toDouble());
         main_yB |= 3;
      do {
          bool valV = false;
          Map<String, dynamic> numh = {String.fromCharCodes([121,95,55,51,95,99,111,110,116,101,120,116,112,114,111,102,105,108,101,108,101,118,101,108,0]):true , String.fromCharCodes([115,112,101,101,100,111,109,101,116,101,114,95,110,95,57,51,0]):false , String.fromCharCodes([117,95,49,56,95,101,114,97,115,105,110,103,0]):false };
          Map<String, dynamic> promisen = {String.fromCharCodes([112,97,103,105,110,103,95,48,95,51,49,0]):true , String.fromCharCodes([116,114,117,101,109,111,116,105,111,110,100,97,116,97,95,115,95,52,50,0]):true };
          List<dynamic> prefix__eF = [String.fromCharCodes([109,97,112,115,95,102,95,55,55,0]), String.fromCharCodes([107,95,55,51,95,105,116,101,114,0])];
         pixelL["$ctrlZ"] = ctrlZ * 1;
         valV = (tabsP * numh.values.length.toDouble()) > 43.29;
         numh = {"${numh.values.length}": pixelL.keys.length};
         promisen = {"${prefix__eF.length}": 3};
         prefix__eF = [pixelL.length];
         if (1055057 == pixelL.length) {
            break;
         }
      } while ((1055057 == pixelL.length) && (pixelL.values.contains(ctrlZ)));
          String progress_ = String.fromCharCodes([121,95,56,48,95,111,112,116,105,109,105,115,109,0]);
          String accessx = String.fromCharCodes([106,117,115,116,95,51,95,53,0]);
          bool pathw = false;
         print(pathw);
         tabsP /= Math.max((3 / (Math.max(9, progress_.length))).toDouble(), 2);
         accessx += "${progress_.length - 1}";
         pathw = !pathw;
      do {
         ctrlZ <<= Math.max(2, Math.min(ctrlZ + tabsP.toInt().abs(), 3));
         if (ctrlZ == 1522705) {
            break;
         }
      } while ((5 > ctrlZ) && (ctrlZ == 1522705));
         pixelL["$tabsP"] = tabsP.toInt() ^ 1;
      for (var a = 0; a < 3; a++) {
         pixelL["$tabsP"] = 2 % (Math.max(9, pixelL.length));
      }
      if (2.94 <= (tabsP - 3.43) && (1 ^ ctrlZ) <= 4) {
          List<dynamic> template_lrT = [857, 667];
          bool utilst = true;
         print(utilst);
          Map<String, dynamic> connectJ = {String.fromCharCodes([106,95,57,52,95,98,114,105,103,104,116,110,101,115,115,0]):false , String.fromCharCodes([108,95,55,50,95,108,97,110,103,0]):false };
         tabsP += 3.toDouble();
         template_lrT.add(3);
         utilst = 47 < pixelL.length;
         connectJ = {"${pixelL.keys.length}": connectJ.length};
      }
      tabletT = "${keyword0.length}";
      country7 = "${tabsP.toInt()}";
      tabletT += "${keyword0.length % 2}";
   return guann;

}



Map<String, dynamic> toJson() {

         List<dynamic> y_4_reporting_t = [String.fromCharCodes([118,95,55,52,95,109,111,118,116,101,120,116,115,117,98,0]), String.fromCharCodes([111,110,116,101,120,116,95,55,95,56,53,0]), String.fromCharCodes([97,98,111,114,116,95,102,95,51,57,0])];
String x_13_conductor_a = String.fromCharCodes([122,95,51,49,95,100,105,102,102,97,98,108,101,0]);

Map<String, dynamic> usdMeasurements =  replyTileMatrix(y_4_reporting_t,3096.0,x_13_conductor_a);

      var usdMeasurements_len = usdMeasurements.length;
     int temp_r_51 = usdMeasurements_len;
     if (temp_r_51 >= 610) {
          switch (temp_r_51) {
          case 55: {
          temp_r_51 *= 65;
             break;

     }
          case 28: {
          temp_r_51 -= 96;
          temp_r_51 -= 56;
             break;

     }
          case 18: {
                  break;

     }
          case 81: {
          temp_r_51 *= 80;
                  break;

     }
          case 41: {
          temp_r_51 *= 67;
             break;

     }
          case 14: {
          if (temp_r_51 != 322) {
          temp_r_51 += 67;
     }
             break;

     }
          case 32: {
          temp_r_51 *= 93;
             break;

     }
          case 89: {
          temp_r_51 -= 89;
          if (temp_r_51 == 935) {
          temp_r_51 += 91;
          }
             break;

     }
          case 99: {
          temp_r_51 += 35;
                  break;

     }
          case 37: {
                  break;

     }
     default:
         break;

     }
     }
      usdMeasurements.forEach((key, value) {
          print(key);
          print(value);
      });

print(usdMeasurements);


   this._endListenFlag = 5265;

   this._infoExtra_Array = [613, 722];

   this._horizontallyDescription_rb_Array = [74, 501, 727];

    return {
      'receive_coins_rate': receiveCoinsRate,
      'sub_coins_txt_list': subCoinsTxtList,
    };
  }
}
