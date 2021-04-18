part of 'sendbarcode_cubit.dart';

@immutable
abstract class SendBarCodeState {
  const SendBarCodeState();
}

class SendBarCodeInitial extends SendBarCodeState {
  const SendBarCodeInitial();
}

class BarCodeSending extends SendBarCodeState {
  const BarCodeSending();
}

class BarCodeSent extends SendBarCodeState {
  final String barCodeSent;
  const BarCodeSent(this.barCodeSent);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BarCodeSent && o.barCodeSent == barCodeSent;
  }

  @override
  int get hashCode => barCodeSent.hashCode;
}

// Error handling
class SendBarCodeError extends SendBarCodeState {
  final String message;
  const SendBarCodeError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SendBarCodeError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
