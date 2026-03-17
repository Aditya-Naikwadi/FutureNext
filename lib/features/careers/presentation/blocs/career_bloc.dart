import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:futurenext/data/models/career_model.dart';
import 'package:futurenext/data/repositories/career_repository.dart';

// Events
abstract class CareerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CareerListRequested extends CareerEvent {}
class CareerCategorySelected extends CareerEvent {
  final String categoryId;
  CareerCategorySelected(this.categoryId);
}
class SubCareerSelected extends CareerEvent {
  final String categoryId;
  final String subCareerId;
  SubCareerSelected(this.categoryId, this.subCareerId);
}

// States
abstract class CareerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CareerInitial extends CareerState {}
class CareerLoading extends CareerState {}
class CareerCategoriesLoaded extends CareerState {
  final List<CareerCategory> categories;
  CareerCategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}
class CareerDetailLoaded extends CareerState {
  final SubCareer subCareer;
  final String categoryId;
  CareerDetailLoaded(this.subCareer, this.categoryId);
  @override
  List<Object?> get props => [subCareer, categoryId];
}
class CareerError extends CareerState {
  final String message;
  CareerError(this.message);
}

// Bloc
class CareerBloc extends Bloc<CareerEvent, CareerState> {
  final CareerRepository _repository;

  CareerBloc(this._repository) : super(CareerInitial()) {
    on<CareerListRequested>((event, emit) {
      emit(CareerLoading());
      final categories = _repository.getCategories();
      emit(CareerCategoriesLoaded(categories));
    });

    on<CareerCategorySelected>((event, emit) {
      // This might just be navigation, but can be used for deep state
    });

    on<SubCareerSelected>((event, emit) {
      emit(CareerLoading());
      final subCareer = _repository.getSubCareerById(event.categoryId, event.subCareerId);
      if (subCareer != null) {
        emit(CareerDetailLoaded(subCareer, event.categoryId));
      } else {
        emit(CareerError('Career not found'));
      }
    });
  }
}
