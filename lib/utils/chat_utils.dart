String getChatId(String userId1, String userId2) {
  List<String> ids = [userId1, userId2];
  ids.sort();
  return ids.join('_');
}
