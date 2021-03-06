import 'package:japanese_year_calculator/src/core/year_calculator.dart';

/// List of all the known Japanese eras.
const eras = [
  JapaneseEra(645, "大化", "たいか", "Taika"),
  JapaneseEra(650, "白雉", "はくち/びゃくち/しらきぎす", "Hakuchi"),
  // 孝徳天皇の崩御後、新たな元号は定められず。
  JapaneseEra.unknown(654),
  // For only 2 months, 8月14日 -> 10月1日
  JapaneseEra(686, "朱鳥", "しゅちょう/すちょう/あかみどり", "Shuchō/Suchō/Akamidori"),
  JapaneseEra.unknown(686),
  JapaneseEra(701, "大宝", "たいほう/だいほう", "Taihō/Daihō"),
  JapaneseEra(704, "慶雲", "けいうん/きょううん", "Keiun/Kyoūn"),
  JapaneseEra(708, "和銅", "わどう", "Wadō"),
  JapaneseEra(715, "霊亀", "れいき", "Reiki"),
  JapaneseEra(717, "養老", "ようろう", "Yōrō"),
  JapaneseEra(724, "神亀", "じんき", "Jinki"),
  JapaneseEra(729, "天平", "てんぴょう", "Tempyō"),
  JapaneseEra(749, "天平感宝", "てんぴょうかんぽう", "Tempyōkampō"),
  JapaneseEra(749, "天平勝宝", "てんぴょうしょうほう", "Tempyōshōhō"),
  JapaneseEra(757, "天平宝字", "てんぴょうほうじ", "Tempyōhōji"),
  JapaneseEra(765, "天平神護", "てんぴょうじんご", "Tempyōjingo"),
  JapaneseEra(767, "神護景雲", "じんごけいうん", "Jingokeiun"),
  JapaneseEra(770, "宝亀", "ほうき", "Hōki"),
  JapaneseEra(781, "天応", "てんおう/てんのう", "Ten'ō/Tennō"),
  JapaneseEra(782, "延暦", "えんりゃく", "Enryaku"),
  JapaneseEra(806, "大同", "だいどう", "Daidō"),
  JapaneseEra(810, "弘仁", "こうにん", "Kōnin"),
  JapaneseEra(824, "天長", "てんちょう", "Tenchō"),
  JapaneseEra(834, "承和", "じょうわ/しょうわ", "Jōwa/Shōwa"),
  JapaneseEra(848, "嘉祥", "かしょう/かじょう", "Kashō/Kajō"),
  JapaneseEra(851, "仁寿", "にんじゅ", "Ninju"),
  JapaneseEra(854, "斉衡", "さいこう", "Saikō"),
  JapaneseEra(857, "天安", "てんあん/てんなん", "Ten'an/Tennan"),
  JapaneseEra(859, "貞観", "じょうがん", "Jōgan"),
  JapaneseEra(877, "元慶", "がんぎょう", "Gangyō"),
  JapaneseEra(885, "仁和", "にんな/にんわ", "Ninna/Ninwa"),
  JapaneseEra(889, "寛平", "かんぴょう/かんぺい/かんへい", "Kampyō/Kampei/Kanhei"),
  JapaneseEra(898, "昌泰", "しょうたい", "Shōtai"),
  JapaneseEra(901, "延喜", "えんぎ", "Engi"),
  JapaneseEra(923, "延長", "えんちょう", "Enchō"),
  JapaneseEra(931, "承平", "じょうへい/しょうへい", "Jōhei/Shōhei"),
  JapaneseEra(938, "天慶", "てんぎょう/てんきょう", "Tengyō/Tenkyō"),
  JapaneseEra(947, "天暦", "てんりゃく", "Tenryaku"),
  JapaneseEra(957, "天徳", "てんとく", "Tentoku"),
  JapaneseEra(961, "応和", "おうわ", "Ōwa"),
  JapaneseEra(964, "康保", "こうほう", "Kōhō"),
  JapaneseEra(968, "安和", "あんな/あんわ", "Anna/Anwa"),
  JapaneseEra(970, "天禄", "てんろく", "Tenroku"),
  JapaneseEra(974, "天延", "てんえん", "Ten'en"),
  JapaneseEra(976, "貞元", "じょうげん", "Jōgen"),
  JapaneseEra(978, "天元", "てんげん", "Tengen"),
  JapaneseEra(983, "永観", "えいかん", "Eikan"),
  JapaneseEra(985, "寛和", "かんな/かんわ", "Kanna/Kanwa"),
  JapaneseEra(987, "永延", "えいえん", "Eien"),
  JapaneseEra(989, "永祚", "えいそ", "Eiso"),
  JapaneseEra(990, "正暦", "しょうりゃく", "Shōryaku"),
  JapaneseEra(995, "長徳", "ちょうとく", "Chōtoku"),
  JapaneseEra(999, "長保", "ちょうほう", "Chōhō"),
  JapaneseEra(1004, "寛弘", "かんこう", "Kankō"),
  JapaneseEra(1013, "長和", "ちょうわ", "Chōwa"),
  JapaneseEra(1017, "寛仁", "かんにん", "Kannin"),
  JapaneseEra(1021, "治安", "じあん", "Jian"),
  JapaneseEra(1024, "万寿", "まんじゅ", "Manju"),
  JapaneseEra(1028, "長元", "ちょうげん", "Chōgen"),
  JapaneseEra(1037, "長暦", "ちょうりゃく", "Chōryaku"),
  JapaneseEra(1040, "長久", "ちょうきゅう", "Chōkyū"),
  JapaneseEra(1044, "寛徳", "かんとく", "Kantoku"),
  JapaneseEra(1046, "永承", "えいしょう/えいじょう", "Eishō/Eijō"),
  JapaneseEra(1053, "天喜", "てんき/てんぎ", "Tenki/Tengi"),
  JapaneseEra(1058, "康平", "こうへい", "Kōhei"),
  JapaneseEra(1065, "治暦", "じりゃく", "Jiryaku"),
  JapaneseEra(1069, "延久", "えんきゅう", "Enkyū"),
  JapaneseEra(1074, "承保", "じょうほう/しょうほう", "Jōhō/Shōhō"),
  JapaneseEra(1077, "承暦", "じょうりゃく/しょうりゃく", "Jōryaku/Shōryaku"),
  JapaneseEra(1081, "永保", "えいほう", "Eihō"),
  JapaneseEra(1084, "応徳", "おうとく", "Ōtoku"),
  JapaneseEra(1087, "寛治", "かんじ", "Kanji"),
  JapaneseEra(1095, "嘉保", "かほう", "Kahō"),
  JapaneseEra(1097, "永長", "えいちょう", "Eichō"),
  JapaneseEra(1097, "承徳", "じょうとく/しょうとく", "Jōtoku/Shōtoku"),
  JapaneseEra(1099, "康和", "こうわ", "Kōwa"),
  JapaneseEra(1104, "長治", "ちょうじ", "Chōji"),
  JapaneseEra(1106, "嘉承", "かしょう/かじょう", "Kashō/Kajō"),
  JapaneseEra(1108, "天仁", "てんにん", "Tennin"),
  JapaneseEra(1110, "天永", "てんえい", "Ten'ei"),
  JapaneseEra(1113, "永久", "えいきゅう", "Eikyū"),
  JapaneseEra(1118, "元永", "げんえい", "Gen'ei"),
  JapaneseEra(1120, "保安", "ほうあん", "Hōan"),
  JapaneseEra(1124, "天治", "てんじ", "Tenji"),
  JapaneseEra(1126, "大治", "だいじ", "Daiji"),
  JapaneseEra(1131, "天承", "てんしょう/てんじょう", "Tenshō/Tenjō"),
  JapaneseEra(1132, "長承", "ちょうしょう", "Chōshō"),
  JapaneseEra(1135, "保延", "ほうえん", "Hōen"),
  JapaneseEra(1141, "永治", "えいじ", "Eiji"),
  JapaneseEra(1142, "康治", "こうじ", "Kōji"),
  JapaneseEra(1144, "天養", "てんよう", "Ten'yō"),
  JapaneseEra(1145, "久安", "きゅうあん", "Kyūan"),
  JapaneseEra(1151, "仁平", "にんぺい/にんぴょう", "Nimpei/Nimpyō"),
  JapaneseEra(1154, "久寿", "きゅうじゅ", "Kyūju"),
  JapaneseEra(1156, "保元", "ほうげん", "Hōgen"),
  JapaneseEra(1159, "平治", "へいじ", "Heiji"),
  JapaneseEra(1160, "永暦", "えいりゃく", "Eiryaku"),
  JapaneseEra(1161, "応保", "おうほう/おうほ", "Ōhō/Ōho"),
  JapaneseEra(1163, "長寛", "ちょうかん", "Chōkan"),
  JapaneseEra(1165, "永万", "えいまん", "Eiman"),
  JapaneseEra(1166, "仁安", "にんあん", "Nin'an"),
  JapaneseEra(1169, "嘉応", "かおう", "Kaō"),
  JapaneseEra(1171, "承安", "しょうあん", "Shōan"),
  JapaneseEra(1175, "安元", "あんげん", "Angen"),
  JapaneseEra(1177, "治承", "じしょう", "Jishō"),
  JapaneseEra(1181, "養和", "ようわ", "Yōwa"),
  JapaneseEra(1182, "寿永", "じゅえい", "Juei"),
  JapaneseEra(1184, "元暦", "げんりゃく", "Genryaku"),
  JapaneseEra(1185, "文治", "ぶんじ", "Bunji"),
  JapaneseEra(1190, "建久", "けんきゅう", "Kenkyū"),
  JapaneseEra(1199, "正治", "しょうじ", "Shōji"),
  JapaneseEra(1201, "建仁", "けんにん", "Kennin"),
  JapaneseEra(1204, "元久", "げんきゅう", "Genkyū"),
  JapaneseEra(1206, "建永", "けんえい", "Ken'ei"),
  JapaneseEra(1207, "承元", "じょうげん", "Jōgen"),
  JapaneseEra(1211, "建暦", "けんりゃく", "Kenryaku"),
  JapaneseEra(1214, "建保", "けんぽう", "Kempō"),
  JapaneseEra(1219, "承久", "じょうきゅう", "Jōkyū"),
  JapaneseEra(1222, "貞応", "じょうおう", "Jōō"),
  JapaneseEra(1224, "元仁", "げんにん", "Gennin"),
  JapaneseEra(1225, "嘉禄", "かろく", "Karoku"),
  JapaneseEra(1228, "安貞", "あんてい", "Antei"),
  JapaneseEra(1229, "寛喜", "かんき", "Kanki"),
  JapaneseEra(1232, "貞永", "じょうえい", "Jōei"),
  JapaneseEra(1233, "天福", "てんぷく", "Tempuku"),
  JapaneseEra(1234, "文暦", "ぶんりゃく", "Bunryaku"),
  JapaneseEra(1235, "嘉禎", "かてい", "Katei"),
  JapaneseEra(1238, "暦仁", "りゃくにん", "Ryakunin"),
  JapaneseEra(1239, "延応", "えんおう", "En'ō"),
  JapaneseEra(1240, "仁治", "にんじ", "Ninji"),
  JapaneseEra(1243, "寛元", "かんげん", "Kangen"),
  JapaneseEra(1247, "宝治", "ほうじ", "Hōji"),
  JapaneseEra(1249, "建長", "けんちょう", "Kenchō"),
  JapaneseEra(1256, "康元", "こうげん", "Kōgen"),
  JapaneseEra(1257, "正嘉", "しょうか", "Shōka"),
  JapaneseEra(1259, "正元", "しょうげん", "Shōgen"),
  JapaneseEra(1260, "文応", "ぶんおう", "Bun'ō"),
  JapaneseEra(1261, "弘長", "こうちょう", "Kōchō"),
  JapaneseEra(1264, "文永", "ぶんえい", "Bun'ei"),
  JapaneseEra(1275, "建治", "けんじ", "Kenji"),
  JapaneseEra(1278, "弘安", "こうあん", "Kōan"),
  JapaneseEra(1288, "正応", "しょうおう", "Shōō"),
  JapaneseEra(1293, "永仁", "えいにん", "Einin"),
  JapaneseEra(1299, "正安", "しょうあん", "Shōan"),
  JapaneseEra(1302, "乾元", "けんげん", "Kengen"),
  JapaneseEra(1303, "嘉元", "かげん", "Kagen"),
  JapaneseEra(1307, "徳治", "とくじ", "Tokuji"),
  JapaneseEra(1308, "延慶", "えんきょう", "Enkyō"),
  JapaneseEra(1311, "応長", "おうちょう", "Ōchō"),
  JapaneseEra(1312, "正和", "しょうわ", "Shōwa"),
  JapaneseEra(1317, "文保", "ぶんぽう", "Bumpō"),
  JapaneseEra(1319, "元応", "げんおう", "Gen'ō"),
  JapaneseEra(1321, "元亨", "げんこう", "Genkō"),
  JapaneseEra(1324, "正中", "しょうちゅう", "Shōchū"),
  JapaneseEra(1326, "嘉暦", "かりゃく", "Karyaku"),
  JapaneseEra(1329, "元徳", "げんとく", "Gentoku"),
  JapaneseEra(1331, "元弘", "げんこう", "Genkō"),
  JapaneseEra(1332, "正慶", "しょうきょう/しょうけい", "Shōkyō/Shōkei"),
  JapaneseEra(1334, "建武", "けんむ", "Kemmu"),
  JapaneseEra(1336, "延元", "えんげん", "Engen"),
  JapaneseEra(1338, "暦応", "りゃくおう/れきおう", "Ryakuō/Rekiō"),
  JapaneseEra(1340, "興国", "こうこく", "Kōkoku"),
  JapaneseEra(1342, "康永", "こうえい", "Kōei"),
  JapaneseEra(1345, "貞和", "じょうわ/ていわ", "Jōwa/Teiwa"),
  JapaneseEra(1347, "正平", "しょうへい", "Shōhei"),
  JapaneseEra(1350, "観応", "かんのう/かんおう", "Kannō/Kan'ō"),
  JapaneseEra(1352, "文和", "ぶんな/ぶんわ", "Bunna/Bunwa"),
  JapaneseEra(1356, "延文", "えんぶん", "Embun"),
  JapaneseEra(1361, "康安", "こうあん", "Kōan"),
  JapaneseEra(1362, "貞治", "じょうじ/ていじ", "Jōji/Teiji"),
  JapaneseEra(1368, "応安", "おうあん", "Ōan"),
  JapaneseEra(1370, "建徳", "けんとく", "Kentoku"),
  JapaneseEra(1372, "文中", "ぶんちゅう", "Bunchū"),
  JapaneseEra(1375, "天授", "てんじゅ", "Tenju"),
  JapaneseEra(1375, "永和", "えいわ", "Eiwa"),
  JapaneseEra(1379, "康暦", "こうりゃく", "Kōryaku"),
  JapaneseEra(1381, "弘和", "こうわ", "Kōwa"),
  JapaneseEra(1381, "永徳", "えいとく", "Eitoku"),
  JapaneseEra(1384, "元中", "げんちゅう", "Genchū"),
  JapaneseEra(1384, "至徳", "しとく", "Shitoku"),
  JapaneseEra(1387, "嘉慶", "かきょう/かけい", "Kakyō/Kakei"),
  JapaneseEra(1389, "康応", "こうおう", "Kōō"),
  JapaneseEra(1390, "明徳", "めいとく", "Meitoku"),
  JapaneseEra(1394, "応永", "おうえい", "Ōei"),
  JapaneseEra(1428, "正長", "しょうちょう", "Shōchō"),
  JapaneseEra(1429, "永享", "えいきょう", "Eikyō"),
  JapaneseEra(1441, "嘉吉", "かきつ", "Kakitsu"),
  JapaneseEra(1444, "文安", "ぶんあん", "Bun'an"),
  JapaneseEra(1449, "宝徳", "ほうとく", "Hōtoku"),
  JapaneseEra(1452, "享徳", "きょうとく", "Kyōtoku"),
  JapaneseEra(1455, "康正", "こうしょう", "Kōshō"),
  JapaneseEra(1457, "長禄", "ちょうろく", "Chōroku"),
  JapaneseEra(1461, "寛正", "かんしょう", "Kanshō"),
  JapaneseEra(1466, "文正", "ぶんしょう", "Bunshō"),
  JapaneseEra(1467, "応仁", "おうにん", "Ōnin"),
  JapaneseEra(1469, "文明", "ぶんめい", "Bummei"),
  JapaneseEra(1487, "長享", "ちょうきょう", "Chōkyō"),
  JapaneseEra(1489, "延徳", "えんとく", "Entoku"),
  JapaneseEra(1492, "明応", "めいおう", "Meiō"),
  JapaneseEra(1501, "文亀", "ぶんき", "Bunki"),
  JapaneseEra(1504, "永正", "えいしょう", "Eishō"),
  JapaneseEra(1521, "大永", "だいえい", "Daiei"),
  JapaneseEra(1528, "享禄", "きょうろく", "Kyōroku"),
  JapaneseEra(1532, "天文", "てんぶん", "Tembun"),
  JapaneseEra(1555, "弘治", "こうじ", "Kōji"),
  JapaneseEra(1558, "永禄", "えいろく", "Eiroku"),
  JapaneseEra(1570, "元亀", "げんき", "Genki"),
  JapaneseEra(1573, "天正", "てんしょう", "Tenshō"),
  JapaneseEra(1593, "文禄", "ぶんろく", "Bunroku"),
  JapaneseEra(1596, "慶長", "けいちょう", "Keichō"),
  JapaneseEra(1615, "元和", "げんな", "Genna"),
  JapaneseEra(1624, "寛永", "かんえい", "Kan'ei"),
  JapaneseEra(1645, "正保", "しょうほう", "Shōhō"),
  JapaneseEra(1648, "慶安", "けいあん", "Keian"),
  JapaneseEra(1652, "承応", "じょうおう", "Jōō"),
  JapaneseEra(1655, "明暦", "めいれき", "Meireki"),
  JapaneseEra(1658, "万治", "まんじ", "Manji"),
  JapaneseEra(1661, "寛文", "かんぶん", "Kambun"),
  JapaneseEra(1673, "延宝", "えんぽう", "Empō"),
  JapaneseEra(1681, "天和", "てんな", "Tenna"),
  JapaneseEra(1684, "貞享", "じょうきょう", "Jōkyō"),
  JapaneseEra(1688, "元禄", "げんろく", "Genroku"),
  JapaneseEra(1704, "宝永", "ほうえい", "Hōei"),
  JapaneseEra(1711, "正徳", "しょうとく", "Shōtoku"),
  JapaneseEra(1716, "享保", "きょうほう", "Kyōhō"),
  JapaneseEra(1736, "元文", "げんぶん", "Gembun"),
  JapaneseEra(1741, "寛保", "かんぽう", "Kampō"),
  JapaneseEra(1744, "延享", "えんきょう", "Enkyō"),
  JapaneseEra(1748, "寛延", "かんえん", "Kan'en"),
  JapaneseEra(1751, "宝暦", "ほうれき", "Hōreki"),
  JapaneseEra(1764, "明和", "めいわ", "Meiwa"),
  JapaneseEra(1772, "安永", "あんえい", "An'ei"),
  JapaneseEra(1781, "天明", "てんめい", "Temmei"),
  JapaneseEra(1789, "寛政", "かんせい", "Kansei"),
  JapaneseEra(1801, "享和", "きょうわ", "Kyōwa"),
  JapaneseEra(1804, "文化", "ぶんか", "Bunka"),
  JapaneseEra(1818, "文政", "ぶんせい", "Bunsei"),
  JapaneseEra(1831, "天保", "てんぽう", "Tempō"),
  JapaneseEra(1845, "弘化", "こうか", "Kōka"),
  JapaneseEra(1848, "嘉永", "かえい", "Kaei"),
  JapaneseEra(1855, "安政", "あんせい", "Ansei"),
  JapaneseEra(1860, "万延", "まんえん", "Man'en"),
  JapaneseEra(1861, "文久", "ぶんきゅう", "Bunkyū"),
  JapaneseEra(1864, "元治", "げんじ", "Genji"),
  JapaneseEra(1865, "慶応", "けいおう", "Keiō"),
  JapaneseEra(1868, "明治", "めいじ", "Meiji"),
  JapaneseEra(1912, "大正", "たいしょう", "Taishō"),
  JapaneseEra(1926, "昭和", "しょうわ", "Shōwa"),
  JapaneseEra(1989, "平成", "へいせい", "Heisei"),
  JapaneseEra(2019, "令和", "れいわ", "Reiwa"),
];
