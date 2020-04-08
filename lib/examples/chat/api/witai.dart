import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:modernui/examples/chat/models/message.dart';

class WitAI {
  final String _userId = "wit";
  Map<String, List<String>> _responses = {
    "greetings": ["Hey, how's it going?", "What's good with you?"],
    "jokes": [
      'Do I lose when the police officer says papers and I say scissors?',
      'I have clean conscience. I haven’t used it once till now.',
      'Did you hear about the crook who stole a calendar? He got twelve months.',
    ],
    "bye": ["Good bye 🤟. See you later my friend."]
  };

  List<Message> get _sorry {
    return [
      Message(
          userId: _userId,
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          value: "sorry i don't understand your message remember i'm a 🤖",
          type: MessageType.text)
    ];
  }

  // returns a list of messages
  Future<List<Message>> sendMessage(String query) async {
    try {
      final url = "https://api.wit.ai/message?q=$query";
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer IWACYIHY7PFRYG6CNW7T5NX7LYQNP56X'
      });

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);

        // we generate a list of message. For more info https://wit.ai/getting-started
        final entities = Map<String, List>.from(parsed['entities']);

        if (entities.length > 0) {
          //  if wit.ai returns entities
          // if we have many entities we get the best by the confidence
          String entity;
          double confidence = 0.0;
          entities.forEach((key, data) {
            final double tmpConfidence = data[0]['confidence'];
            if (tmpConfidence > confidence && tmpConfidence >= 0.8) {
              confidence = tmpConfidence;
              entity = key;
            }
          });

          if (entity != null && _responses.containsKey(entity)) {
            final responses = _responses[entity].map<Message>((item) {
              return Message(
                  userId: _userId,
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  value: item,
                  type: MessageType.text);
            }).toList();
            return responses;
          }
        }
      }
      return _sorry;
    } catch (e) {
      return _sorry;
    }
  }
}
