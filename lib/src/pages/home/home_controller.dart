import 'package:asyncstate/asyncstate.dart' as asyncState;
import 'package:fe_lab_clinicas_adm/src/models/patient_information_form_model.dart';
import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../repositories/attendant_desk_assignment/attendant_desk_assignment_repository.dart';
import '../../services/call_next_patient/call_next_patient_service.dart';

class HomeController with MessageStateMixin {
  final AttendantDeskAssignmentRepository _attendantDeskAssignmentRepository;
  final CallNextPatientService _callNextPatientService;

  HomeController(
      {required AttendantDeskAssignmentRepository
          attendantDeskAssignmentRepository,
      required CallNextPatientService callNextPatientService})
      : _attendantDeskAssignmentRepository = attendantDeskAssignmentRepository,
        _callNextPatientService = callNextPatientService;

  final _informationForm = signal<PatientInformationFormModel?>(null);
  PatientInformationFormModel? get informationForm => _informationForm();

  Future<void> startService(int deskNumber) async {
    asyncState.AsyncState.show();
    final result =
        await _attendantDeskAssignmentRepository.startService(deskNumber);
    switch (result) {
      case Left():
        asyncState.AsyncState.hide();
        showError('Erro ao iniciar Guiche');
        break;
      case Right():
        final resultNextPatient = await _callNextPatientService.execute();
        switch (resultNextPatient) {
          case Left():
            asyncState.AsyncState.hide();
            showError('Erro ao chamer proximo paciente');
          case Right(value: final form?):
            asyncState.AsyncState.hide();
            _informationForm.value = form;
          case Right(value: _):
            asyncState.AsyncState.hide();
            showInfo('Nenhum Paciente aguardando');
        }
    }
  }
}
