class ResourceConstants {
  const ResourceConstants();

  String get submitTitle => 'Konfirmasi';

  String get submitContent => 'Apakah data anda sudah sesuai?';

  String get signOutContent => 'Anda yakin ingin keluar?';

  String get baseDevDb => "inventory.dev.scaleocean.app";

  String get baseDemoDb => "inventory.demo.scaleocean.app";

  String get emptyHomeTitle => "Oops data kosong!";

  String get emptyHomeContent =>
      "Tidak ada data yang tersedia saat ini. Silahkan pilih\nwarehouse untuk memulai.";

  String get emptyOperationContent => "Tidak ada data yang tersedia saat ini.";

  String get emptyHomeContentStockOp =>
      "Maaf, data pemberitahuan stock opname masih kosong,\nSilahkan menunggu notifikasi.";

  String get onBoardTitle1 =>
      'Siap membantu anda mengatur stok barang dengan lebih baik.';

  String get onBoardTitle2 =>
      'Pemindaian memudahkan kelola barang masuk dan keluar.';

  String get onBoardDescription1 =>
      'Dengan menggunakan produk ini, Anda akan memiliki kontrol penuh atas stok barang Anda dengan mudah dan efisien.';

  String get onBoardDescription2 =>
      'Lebih cepat, lebih akurat, dan lebih efisien.';

  String get selectWarehouseFirst => 'Please select warehouse first';

  String get errorScanText => 'Error, Not the appropriate product';

  String get errorScanSameItemText => 'Please confirm previous product data';

  String get successScanText => 'Success Scan Barcode';

  String get disableCountQuantity =>
      "Unable to increase or decrease after confirm";

  String get successUpdateStock => 'Successfully update stock quantity';

  String get serverFieldErrorMessage => "Please fill in server details";

  String get emailFieldErrorMessage => "Please fill in your email";

  String get passwordFieldErrorMessage => "Please fill in your password";
}

class AssetConstans {
  const AssetConstans();

  String get splash => 'assets/icon/splash/logo.svg';

  String get onBoard1 => 'assets/images/onboarding/on_boarding_1.svg';

  String get onBoard2 => 'assets/images/onboarding/on_boarding_2.svg';

  // String get onBoard2 => 'assets/images/onboarding/on_boarding_2.svg';

  // String get onBoard3 => 'assets/images/onboarding/on_boarding_3.svg';

  String get signIn => 'assets/images/sign_in/sign_in.png';

  String get signInLogoBottom => 'assets/images/sign_in/logo.svg';

  String get finger => 'assets/images/sign_in/finger.svg';

  String get emptyHome => 'assets/images/home/empty_state.svg';

  String get filter => 'assets/icon/operation/filter.svg';

  String get scanBarcode => 'assets/icon/operation/scan.png';
}
