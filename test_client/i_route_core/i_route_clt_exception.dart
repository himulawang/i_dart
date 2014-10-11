part of lib_test_route;

class IRouteClientException extends IException {
  static final Map _CODES = {
      '50001': 'Invalid response json.',
      '50002': 'Invalid json format for framework.',
      '50003': 'Invalid data format.',
  };

  IRouteClientException(int inputCode, [List inputParameters]) {
    super.shout(inputCode, inputParameters, _CODES);
  }
}
