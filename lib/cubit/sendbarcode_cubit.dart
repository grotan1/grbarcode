import 'package:bloc/bloc.dart';
import 'package:grbarcode/data/sendbarcoderepo.dart';
import 'package:meta/meta.dart';
import '../data/networkerror_helper.dart';
part 'sendbarcode_state.dart';

class SendBarCodeCubit extends Cubit<SendBarCodeState> {
  //SendbarcodeCubit() : super(SendbarcodeInitial());
  final BarCodeRepository _barCodeRepository;
  SendBarCodeCubit(this._barCodeRepository) : super(const SendBarCodeInitial());

  Future<void> sendBarCode(String barCode) async {
    try {
      emit(const BarCodeSending());
      final sendBarCode = await _barCodeRepository.sendBarCode(barCode);

      emit(BarCodeSent(sendBarCode));
    } on NetworkException {
      print('Error');
    }
  }
}
