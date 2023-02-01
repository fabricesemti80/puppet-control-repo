# patch_mgmt_win
class profile::patch_mgmt_win (
) {
  include os_patching

  class {'patching_as_code':
    classify_pe_patch => true,
    patch_choco       => true
  }
}
