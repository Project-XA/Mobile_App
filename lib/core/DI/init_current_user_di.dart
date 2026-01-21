import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/curren_user/Data/repo_imp/current_user_repo_imp.dart';
import 'package:mobile_app/core/curren_user/domain/repo/current_user_repo.dart';
import 'package:mobile_app/core/curren_user/domain/use_case/get_current_user_use_case.dart';
import 'package:mobile_app/core/curren_user/domain/use_case/update_profile_image_use_case.dart';
import 'package:mobile_app/core/curren_user/domain/use_case/update_user_use_case.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/services/register_lazy_if_not_registered.dart';

void initCurrentUserDi() {
  // Repository
  registerLazyIfNotRegistered<CurrentUserRepository>(
    () => CurrentUserRepositoryImpl(localDataSource: getIt()),
  );

  // Use Cases
  registerLazyIfNotRegistered<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt()),
  );
  registerLazyIfNotRegistered<UpdateProfileImageUseCase>(
    () => UpdateProfileImageUseCase(getIt()),
  );
  registerLazyIfNotRegistered<UpdateUserUseCase>(
    () => UpdateUserUseCase(getIt()),
  );

  registerLazyIfNotRegistered<CurrentUserCubit>(
    () => CurrentUserCubit(
      getCurrentUserUseCase: getIt(),
      updateProfileImageUseCase: getIt(),
      updateUserUseCase: getIt(),
    ),
  );
}