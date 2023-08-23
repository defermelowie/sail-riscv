/* **************************************************************** */
/* Virtualization Mode                                              */

register cur_virtualization : Virtualization

/* **************************************************************** */
/* Hypervisor Status Register                                       */

bitfield Hstatus : xlenbits = {
  /* VSXL only exists if HSXLEN == 64 so it's modelled via explicit an getter and setter below.*/
  /* VSXL : 33 .. 32 */
  VTSR  : 22,
  VTW   : 21,
  VTVM  : 20,
  VGEIN : 17 .. 12,
  HU    : 9,
  SPVP  : 8,
  SPV   : 7,
  GVA   : 6,
  VSBE  : 5
}
register hstatus : Hstatus

function get_hstatus_VSXL(h : Hstatus) -> arch_xlen = {
  if sizeof(xlen) == 32
  then arch_to_bits(RV32)
  else h.bits()[33 .. 32]
}

function set_hstatus_VSXL(h : Hstatus, a : arch_xlen) -> Hstatus = {
  if sizeof(xlen) == 32
  then h
  else {
    let h = vector_update_subrange(h.bits(), 33, 32, a);
    Mk_Hstatus(h)
  }
}

function get_hstatus() -> xlenbits = {
  hstatus.bits()
}

function legalize_hstatus(o : Hstatus, v : xlenbits) -> Hstatus = {
  let v = Mk_Hstatus(v);
  let h = Mk_Hstatus(zero_extend(0b0));

  let h = update_VTSR(h, v.VTSR());
  let h = update_VTW(h, v.VTW());
  let h = update_VTVM(h, v.VTVM());
  let h = update_VGEIN(h, v.VGEIN());  /* TODO: Legalize hstatus.vgein */
  let h = update_HU(h, v.HU());
  let h = update_SPVP(h, v.SPVP());
  let h = update_SPV(h, v.SPV());
  let h = update_GVA(h, v.GVA());
  let h = update_VSBE(h, v.VSBE());

  /* Dynamic XLEN changes are not (yet) supported */
  let h = set_hstatus_VSXL(h, get_hstatus_VSXL(o));

  h
}

/* **************************************************************** */
/* Hypervisor Trap Delegation Registers                             */

register hedeleg : Medeleg

function get_hedeleg() -> xlenbits = {
  hedeleg.bits()
}

function legalize_hedeleg(o: Medeleg, v: xlenbits) -> Medeleg = {
  let h = Mk_Medeleg(v);
  /* Mask read-only zero bits */
  let h = update_SAMO_GPage_Fault(h, 0b0);
  let h = update_Virtual_Instr(h, 0b0);
  let h = update_Load_GPage_Fault(h, 0b0);
  let h = update_Fetch_GPage_Fault(h, 0b0);
  let h = update_MEnvCall(h, 0b0);
  let h = update_VSEnvCall(h, 0b0);
  let h = update_HSEnvCall(h, 0b0);
  h
}

/* **************************************************************** */
/* Virtual Supervisor Status Register                               */

bitfield Vsstatus : xlenbits = {
  SD   : xlen - 1,
  /* UXL only exists if HSXLEN == 64 so it's modelled via explicit an getter and setter below.*/
  /* UXL  : 33 .. 32 */
  MXR  : 19,
  SUM  : 18,
  XS   : 16 .. 15,
  FS   : 14 .. 13,
  VS   : 10 .. 9,
  SPP  : 8,
  UBE  : 6,
  SPIE : 5,
  SIE  : 1
}
register vsstatus : Vsstatus

function get_vsstatus_UXL(v : Vsstatus) -> arch_xlen = {
  if sizeof(xlen) == 32
  then arch_to_bits(RV32)
  else v.bits()[33 .. 32]
}

function set_vsstatus_UXL(v : Vsstatus, a : arch_xlen) -> Vsstatus = {
  if sizeof(xlen) == 32
  then v
  else {
    let v = vector_update_subrange(v.bits(), 33, 32, a);
    Mk_Vsstatus(v)
  }
}

function get_vsstatus() -> xlenbits = {
  vsstatus.bits()
}

function legalize_vsstatus(vs: Vsstatus, v: xlenbits) -> Vsstatus = {
  let m = Mk_Mstatus(vs.bits());  /* Convert to Mstatus   */
  let s = legalize_sstatus(m, v); /* Legalize for Sstatus */
  Mk_Vsstatus(s.bits())           /* Convert back to Vsstatus  */
}

/* **************************************************************** */
/* Virtual Supervisor Trap Vector Base Address Register             */

register vstvec : Mtvec

/* get_vstvec is defined in ./model/riscv_sys_exceptions.sail */
/* set_vstvec is defined in ./model/riscv_sys_exceptions.sail */

/* **************************************************************** */
/* Virtual Supervisor Scratch Register                              */

register vsscratch : xlenbits

function get_vsscratch() -> xlenbits = {
  vsscratch
}

/* **************************************************************** */
/* Virtual Supervisor Exception Program Counter                     */

register vsepc : xlenbits

function get_vsepc() -> xlenbits = {
  vsepc
}

/* **************************************************************** */
/* Virtual Supervisor Cause Register                                */

register vscause : Mcause

function get_vscause() -> xlenbits = {
  vscause.bits()
}

/* **************************************************************** */
/* Virtual Supervisor Trap Value Register                           */

register vstval : xlenbits

function get_vstval() -> xlenbits = {
  vstval
}
