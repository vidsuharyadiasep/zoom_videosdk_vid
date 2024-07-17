import 'dart:convert';

import 'package:events_emitter/emitters/event_emitter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_chat_message.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
import 'package:google_fonts/google_fonts.dart';


class CommentList extends HookWidget {
  final ZoomVideoSdk zoom;
  final ZoomVideoSdkEventListener eventListener;

  const CommentList(
      {super.key, required this.zoom, required this.eventListener});

  @override
  Widget build(BuildContext context) {
    ScrollController listScrollController = ScrollController();
    var chatMessages = useState(<ZoomVideoSdkChatMessage>[]);
    var messageLength = useState(0);

    useEffect(() {
      eventListener.addEventListener();
      EventEmitter emitter = eventListener.eventEmitter;

      final chatNewMessageNotify =
          emitter.on(EventType.onChatNewMessageNotify, (data) async {
        ZoomVideoSdkChatMessage newMessage =
            ZoomVideoSdkChatMessage.fromJson(jsonDecode(data.toString()));
        chatMessages.value.add(newMessage);
        messageLength.value += 1;
        if (listScrollController.hasClients) {
          listScrollController
              .jumpTo(listScrollController.position.maxScrollExtent);
        }
      });

      final deleteChatMessageNotify =
      emitter.on(EventType.onChatDeleteMessageNotify, (data) async {
        data = data as Map;
        var toRemove = [];
        for (var message in chatMessages.value) {
          if (message.messageID == data['msgID']) {
            toRemove.add(message);
          }
        }
        chatMessages.value.removeWhere( (e) => toRemove.contains(e));

        messageLength.value -= 1;
        if (listScrollController.hasClients) {
          listScrollController
              .jumpTo(listScrollController.position.maxScrollExtent);
        }
      });

      return () => {
            chatNewMessageNotify.cancel(),
        deleteChatMessageNotify.cancel(),
          };
    }, [zoom]);

    void deleteMessage(String msgId) async {
      await zoom.chatHelper.deleteChatMessage(msgId);
    }

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 250,
        margin: const EdgeInsets.only(left: 20, right: 100, bottom: 250),
        alignment: Alignment.bottomLeft,
        child: ListView.separated(
            controller: listScrollController,
            scrollDirection: Axis.vertical,
            itemCount: chatMessages.value.length,
            itemBuilder: (BuildContext context, int index) {
              VisualDensity.compact;
              return Row(
                children: [
                  Flexible(
                      child: Container(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.5),
                        width: 2,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${chatMessages.value[index].senderUser.userName}: ',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xCCCCCCFF),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: chatMessages.value[index].content,
                            recognizer: TapGestureRecognizer()..onTap = () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Message?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => {
                                      deleteMessage(chatMessages.value[index].messageID),
                                      Navigator.pop(context, 'Cancel')
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            ),
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
                  height: 4,
                )),
      ),
    );
  }
}