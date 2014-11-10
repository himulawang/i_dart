part of i_dart;

class IRouteClientException extends IException {
  static final Map _CODES = {
      '50001': 'Invalid response json: %%.',
      '50002': 'Invalid json format for framework: %%.',
      '50003': 'Server error, api: %%, code: %%, message: "%%".',
      '50004': 'Invalid api name: %%.',
      '50005': 'Invalid data format.',
  };

  IRouteClientException(int inputCode, [List inputParameters]) {
    super.shout(inputCode, inputParameters, _CODES);
  }
}
