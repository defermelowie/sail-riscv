/* Hypervisor CSR and accessors */
function clause ext_is_CSR_defined(0x600, _) = haveHExt()  /* hstatus */
function clause ext_is_CSR_defined(0x602, _) = haveHExt()  /* hedeleg */
function clause ext_is_CSR_defined(0x603, _) = haveHExt()  /* hideleg */
function clause ext_is_CSR_defined(0x604, _) = haveHExt()  /* hie */
function clause ext_is_CSR_defined(0x606, _) = haveHExt()  /* hcounteren */
function clause ext_is_CSR_defined(0x607, _) = haveHExt()  /* hgeie */
function clause ext_is_CSR_defined(0x643, _) = haveHExt()  /* htval */
function clause ext_is_CSR_defined(0x644, _) = haveHExt()  /* hip */
function clause ext_is_CSR_defined(0x645, _) = haveHExt()  /* hvip */
function clause ext_is_CSR_defined(0x64A, _) = haveHExt()  /* htinst */
function clause ext_is_CSR_defined(0xE12, _) = haveHExt()  /* hgeip */
function clause ext_is_CSR_defined(0x60A, _) = haveHExt()  /* henvcfg */
function clause ext_is_CSR_defined(0x61A, _) = haveHExt()  /* henvcfgh */
function clause ext_is_CSR_defined(0x680, _) = haveHExt()  /* hgatp */
function clause ext_is_CSR_defined(0x605, _) = haveHExt()  /* htimedelta */
function clause ext_is_CSR_defined(0x615, _) = haveHExt()  /* htimedeltah */
function clause ext_is_CSR_defined(0x200, _) = haveHExt()  /* vsstatus */
function clause ext_is_CSR_defined(0x204, _) = haveHExt()  /* vsie */
function clause ext_is_CSR_defined(0x205, _) = haveHExt()  /* vstvec */
function clause ext_is_CSR_defined(0x240, _) = haveHExt()  /* vsscratch */
function clause ext_is_CSR_defined(0x241, _) = haveHExt()  /* vsepc */
function clause ext_is_CSR_defined(0x242, _) = haveHExt()  /* vscause */
function clause ext_is_CSR_defined(0x243, _) = haveHExt()  /* vstval */
function clause ext_is_CSR_defined(0x244, _) = haveHExt()  /* vsip */
function clause ext_is_CSR_defined(0x280, _) = haveHExt()  /* vsatp */

function init_hext() -> unit = {
  assert(sys_enable_hext());

  /* Start with V=0 */
  cur_virtualization = V0;

  /* Init M-mode CRS fields */

  if sizeof(xlen) == 32
  then mstatush = set_mstatush_MPV(mstatush, virt_to_bits(V0))
  else mstatus = set_mstatus_MPV(mstatus, virt_to_bits(V0));

  if sizeof(xlen) == 32
  then mstatush = set_mstatush_GVA(mstatush, 0b0)
  else mstatus = set_mstatus_GVA(mstatus, 0b0);

  /* TODO: mip */

  mie = update_SGEI(mie, 0b0);
  mie = update_VSEI(mie, 0b0);
  mie = update_VSTI(mie, 0b0);
  mie = update_VSSI(mie, 0b0);

  mideleg = update_SGEI(mideleg, 0b1); /* TODO: SGEIE is "read-only one" only if GEILEN > 0 */
  mideleg = update_VSEI(mideleg, 0b1);
  mideleg = update_VSTI(mideleg, 0b1);
  mideleg = update_VSSI(mideleg, 0b1);
}
