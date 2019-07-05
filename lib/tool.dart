//用word方式计算正文字数
fnGetCpmisWords(String str) {
  String s = str;
  int sLen = 0;
  try {
    //先将回车换行符做特殊处理
    s = s.replaceAll(new RegExp('(\r\n+|\s+|　+) '), "龘");
    //处理英文字符数字，连续字母、数字、英文符号视为一个单词
    s = s.replaceAll(new RegExp("[\x00-\xff]"), "m"); //合并字符m，连续字母、数字、英文符号视为一个单词
    s = s.replaceAll(new RegExp("m+"), "*"); //去掉回车换行符
    s = s.replaceAll(new RegExp("龘+"), ""); //返回字数
    sLen = s.length;
  } catch (e) {
    print(e.toString());
  }
  return sLen;
}
fnGetNumWords(String str) {
  String s = str;
  int sLen = 0;
  try {
    //先将回车换行符做特殊处理
    s = s.replaceAll(new RegExp(r'[0-9]'), "龘");
    print(s);
    sLen = s.split('龘').length - 1;
  } catch (e) {
    print(e.toString());
  }
  return sLen;

}