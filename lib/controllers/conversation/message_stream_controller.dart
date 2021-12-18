import '../../models/message_model.dart';
import '../../models/conversation_model.dart';
import 'dart:async';
import 'conversation_controller.dart';
import 'package:fluttergram/constants.dart';
class MessageStreamModel{
  late Stream<bool> stream;
  late bool hasMore;
  late bool _isLoading;
  late Conversation _data;
  late StreamController<bool> _controller;
  late String chatId;
  MessageStreamModel(t_chatId,conversation) {
    _controller = StreamController<bool>.broadcast();
    _data = conversation;

    _isLoading = false;
    stream = _controller.stream.map((bool signal) {
      return signal;
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

      _data.messages.addAll(msgList);

      hasMore = (msgList.length == numberMsgPerPage);

      _controller.add(_data.messages.length > 0);
    });

  }
}