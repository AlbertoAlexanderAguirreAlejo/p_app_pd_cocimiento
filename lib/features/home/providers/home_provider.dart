import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:app_pd_cocimiento/data/repositories/con_pd_agua_repository.dart';
import 'package:app_pd_cocimiento/data/repositories/con_pd_nivel_repository.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/data/repositories/con_pd_det_repository.dart';
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final ConPdDetRepository _conPdDetRepository;
  final ConPdAguaRepository _conPdAguaRepository;
  final ConPdNivelRepository _conPdNivelRepository;
  final AppPreferences _appPreferences;

  HomeProvider({
    required ConPdDetRepository conPdDetRepository,
    required ConPdAguaRepository conPdAguaRepository,
    required ConPdNivelRepository conPdNivelRepository,
    required AppPreferences appPreferences,
  })  : _conPdDetRepository = conPdDetRepository,
        _conPdAguaRepository = conPdAguaRepository,
        _conPdNivelRepository = conPdNivelRepository,
        _appPreferences = appPreferences;

  int get activeCabeceraId => _appPreferences.activeCabeceraId;

  // Ahora la validación se realiza utilizando el valor declarado en el provider.
  Future<bool> validateDetalleForCabecera() async {
    return await _conPdDetRepository.existsDetalleForCabecera(activeCabeceraId);
  }

  Future<bool> validatePresionAgua() =>
    _conPdAguaRepository.existsAllAguaValidForCabecera(activeCabeceraId);

  Future<bool> validateNivelGraneros() =>
    _conPdNivelRepository.existsNivelByTipo(activeCabeceraId, AppConstants.tipoGraneros);

  Future<bool> validateNivelCristalizadores() =>
    _conPdNivelRepository.existsNivelByTipo(activeCabeceraId, AppConstants.tipoCristalizadorNivel);

  Future<bool> validateNivelTachosTanques() =>
    _conPdNivelRepository.existsAllTanquesValidos(activeCabeceraId);
}