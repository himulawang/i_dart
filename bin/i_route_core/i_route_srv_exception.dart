class IRouteServerException extends IException {
  static final Map _CODES = {
      // WebSocket Handler
      '40001': 'Invalid request json.',
      '40002': 'Invalid json format for framework: %%.',
      '40003': 'Invalid api type %%.',
      '40004': 'Api %% receive invalid params type.',
      '40005': 'Api %% is invalid.',
      // Route Validator
      '41001': 'Api %% parameter %% allowType is ALLOW_EMPTY, no parameter was given.',
      '41002': 'Api %% parameter %% allowType is REQUIRED, no parameter was given.',
      '41003': 'Api %% parameter %% dataType is %%, %% %% is given.',
      '41004': 'Api %% parameter %% dataType is %% and cannot be empty.',
  };

  IRouteServerException(int inputCode, [List inputParameters]) {
    super.shout(inputCode, inputParameters, _CODES);
  }
}
