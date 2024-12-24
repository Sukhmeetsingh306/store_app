import 'package:flutter_dotenv/flutter_dotenv.dart';

String uri = "http://${dotenv.env['IP_ADDRESS']}:3000";