import '../../entity/karyawan.entity.dart';
import '../../repository/master.repo.dart';

class FindKaryawanTupleUseCase {
  final MasterDataRepository repository;

  FindKaryawanTupleUseCase(this.repository);

  Future<List<KaryawanEntity>?> execute(String args) {
    return repository.getKaryawanTuple(args);
  }
}
