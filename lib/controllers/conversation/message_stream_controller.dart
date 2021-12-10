import '../../models/message_model.dart';
import '../../models/conversation_model.dart';
import 'dart:async';
import 'conversation_controller.dart';
class MessageStreamModel{
  late Stream<List<Message>> stream;
  late bool hasMore;
  late bool _isLoading;
  late Conversation _data;
  late StreamController<List<Message>> _controller;
  late String chatId;
  MessageStreamModel(t_chatId,conversation) {
    _controller = StreamController<List<Message>>.broadcast();
    _data = conversation;
    _isLoading = false;
    stream = _controller.stream.map((List<Message> msgList) {
      return msgList;
    });
    hasMore = true;
    chatId = t_chatId;
    refresh();
  }
  Future<void> refresh() {
    return loadMore(clearCachedData: true, page : 0);
  }

  Future<void> loadMore({bool clearCachedData = false, int page = 0}) {
    if (clearCachedData) {
      // _data = <Message>[];
      _data.messages = <Message>[];
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return getMessagesAPI(this.chatId,page).then((List<Message> msgList){
      _isLoading = false;
      // var tmpls = msgList.reversed;
      // for (var msg in tmpls)
      // {
      //   _data.insert(0, msg);
      // };
      print('pre data');
      print(_data.messages.length);
      _data.messages.addAll(msgList);
      print('post data');
      print(_data.messages.length);
      hasMore = (msgList.length > 0);
      _controller.add(_data.messages);
    });

  }
}