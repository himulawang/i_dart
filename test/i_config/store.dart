library store;

Map store = {
  'redis': {
    'GameCache': [
      {'no': 0, 'host': 'sha-vila-001', 'port': 6379, 'pwd': null, 'db': '0'},
      {'no': 1, 'host': 'sha-vila-001', 'port': 6380, 'pwd': null, 'db': '0'},
    ],
    'GameCacheSlave': [
      {'no': 0, 'host': 'sha-vila-001', 'port': 6381, 'pwd': null, 'db': '0'},
      {'no': 1, 'host': 'sha-vila-001', 'port': 6382, 'pwd': null, 'db': '0'},
    ],
  },
  'mariaDB': {
    'GameDB': [
        {'no': 0, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
        {'no': 1, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
    ],
    'GameDBSlave': [
        {'no': 0, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
        {'no': 1, 'host': 'localhost', 'port': 3306, 'usr': 'root', 'pwd': '123', 'db': 'i_dart', 'maxHandler': 5 },
    ],
  },
};