class IRouteException extends IException {
  static final Map _CODES = {
      '30001': 'Api %% parameter %% allowType is ALLOW_EMPTY, no parameter was given.',
      '30002': 'Api %% parameter %% allowType is REQUIRED, no parameter was given.',
      '30003': 'Api %% parameter %% dataType is %%.',
      '30004': 'Api %% parameter %% dataType is %% and cannot be empty.',

      '30101': 'Invalid request json.',
      '30102': 'Invalid json format for framework: %%.',
      '30103': 'Invalid api type %%.',
      '30104': 'Api %% receive invalid params type.',
      '30105': 'Api %% is invalid.',
  };

  IRouteException(int inputCode, [List inputParameters]) {
    super.shout(inputCode, inputParameters, _CODES);
  }
}
