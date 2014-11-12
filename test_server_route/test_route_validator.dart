import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:i_dart/i_dart_srv.dart';

import 'lib_test_server_route.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  num startTimestamp;
  num endTimestamp;
  startTimestamp = new DateTime.now().millisecondsSinceEpoch;
  String delimiter = ASCII.decode([0x1D]);

  group('Test Route Validator', () {

    group('allow none', () {

      test('param allow none and not provide', () {

        expect(() {
          var api = 'V1';
          var params = {
          };
          var config = {
            'n': 'ns',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow none and provide wrong type', () {

        expect(() {
          var api = 'V1';
          var params = {
            'n': 1000,
          };
          var config = {
            'n': 'ns',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('param allow none and provide right data type', () {

        expect(() {
          var api = 'V1';
          var params = {
            'n': 'HelloWorld.',
          };
          var config = {
            'n': 'ns',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

    });

    group('allow empty', () {

      test('param allow empty string and not provide', () {

        expect(() {
          var api = 'V1';
          var params = {
          };
          var config = {
              'n': 'es',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41001))
        );

      });

      test('param allow empty string and provide empty string', () {

        expect(() {
          var api = 'V1';
          var params = {
            'n': '',
          };
          var config = {
            'n': 'es',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty string and provide non-empty string', () {

        expect(() {
          var api = 'V1';
          var params = {
            'n': 'HelloWorld',
          };
          var config = {
            'n': 'es',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty list and not provide', () {

        expect(() {
          var api = 'V1';
          var params = {
          };
          var config = {
              'l': 'el',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41001))
        );

      });

      test('param allow empty list and provide empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'l': [],
          };
          var config = {
              'l': 'el',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty list and provide non-empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'l': [1],
          };
          var config = {
              'l': 'el',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty map and not provide', () {

        expect(() {
          var api = 'V1';
          var params = {
          };
          var config = {
              'm': 'em',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41001))
        );

      });

      test('param allow empty map and provide empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'm': {},
          };
          var config = {
              'm': 'em',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty map and provide non-empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'm': {'key': 'HelloWorld'},
          };
          var config = {
              'm': 'em',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty json and provide empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': [],
          };
          var config = {
              'j': 'ej',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty json and provide empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': {},
          };
          var config = {
              'j': 'ej',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty json and provide non-empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': ['HelloWorld'],
          };
          var config = {
              'j': 'ej',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('param allow empty json and provide non-empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': {'key': 'HelloWorld'},
          };
          var config = {
              'j': 'ej',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

    });

    group('required', () {

      test('param required and not provide', () {

        expect(() {
          var api = 'V1';
          var params = {
          };
          var config = {
              'n': 'rs',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41002))
        );

      });

      test('required string and provide empty string', () {

        expect(() {
          var api = 'V1';
          var params = {
            'n': '',
          };
          var config = {
            'n': 'rs',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41004))
        );

      });

      test('required string and provide non-empty string', () {

        expect(() {
          var api = 'V1';
          var params = {
              'n': 'HelloWorld',
          };
          var config = {
              'n': 'rs',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required int and provide int', () {

        expect(() {
          var api = 'V1';
          var params = {
              'n': 1000,
          };
          var config = {
              'n': 'ri',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required int and provide wrong data type', () {

        expect(() {
          var api = 'V1';
          var params = {
              'n': {},
          };
          var config = {
              'n': 'ri',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required unsigned int and provide wrong data type', () {

        expect(() {
          var api = 'V1';
          var params = {
              'n': .1,
          };
          var config = {
              'n': 'ru',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required unsigned int and provide negative int', () {

        expect(() {
          var api = 'V1';
          var params = {
              'n': -1000,
          };
          var config = {
              'n': 'ru',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required unsigned int and provide positive int', () {

        expect(() {
          var api = 'V1';
          var params = {
              'n': 1000,
          };
          var config = {
              'n': 'ru',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required unsigned double and provide wrong data type', () {

        expect(() {
          var api = 'V1';
          var params = {
              'd': 'HelloWorld',
          };
          var config = {
              'd': 'rd',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required unsigned double and provide int', () {

        expect(() {
          var api = 'V1';
          var params = {
              'd': 1000,
          };
          var config = {
              'd': 'rd',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required unsigned double and provide double', () {

        expect(() {
          var api = 'V1';
          var params = {
              'd': 1.23456,
          };
          var config = {
              'd': 'rd',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required map and provide wrong data type', () {

        expect(() {
          var api = 'V1';
          var params = {
              'm': 1.23456,
          };
          var config = {
              'm': 'rm',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required map and provide empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'm': {},
          };
          var config = {
              'm': 'rm',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41004))
        );

      });

      test('required map and provide non-empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'm': {'key': 'HelloWorld'},
          };
          var config = {
              'm': 'rm',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required list and provide wrong data type', () {

        expect(() {
          var api = 'V1';
          var params = {
              'l': {'key': 'HelloWorld'},
          };
          var config = {
              'l': 'rl',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required list and provide empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'l': [],
          };
          var config = {
              'l': 'rl',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41004))
        );

      });

      test('required list and provide non-empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'l': ['HelloWorld'],
          };
          var config = {
              'l': 'rl',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required json and provide wrong data type', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': 1000,
          };
          var config = {
              'j': 'rj',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required json and provide empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': {},
          };
          var config = {
              'j': 'rj',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41004))
        );

      });

      test('required json and provide empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': [],
          };
          var config = {
              'j': 'rj',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41004))
        );

      });

      test('required json and provide non-empty map', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': {'key': 'HelloWorld'},
          };
          var config = {
              'j': 'rj',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required json and provide non-empty list', () {

        expect(() {
          var api = 'V1';
          var params = {
              'j': [true],
          };
          var config = {
              'j': 'rj',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

      test('required boolean and provide wrong data type', () {

        expect(() {
          var api = 'V1';
          var params = {
              'b': 'HelloWorld',
          };
          var config = {
              'b': 'rb',
          };

          IRouteValidator.validateAll(params, config, api);
        },
          throwsA(predicate((e) => e is IRouteServerException && e.code == 41003))
        );

      });

      test('required boolean and provide boolean', () {

        expect(() {
          var api = 'V1';
          var params = {
              'b': true,
          };
          var config = {
              'b': 'rb',
          };

          IRouteValidator.validateAll(params, config, api);
        }, returnsNormally);

      });

    });

  });

  endTimestamp = new DateTime.now().millisecondsSinceEpoch;
  print('cost ${endTimestamp - startTimestamp} ms');
}
