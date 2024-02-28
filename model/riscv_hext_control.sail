/*=======================================================================================*/
/*  RISCV Sail Model                                                                     */
/*                                                                                       */
/*  This Sail RISC-V architecture model, comprising all files and                        */
/*  directories except for the snapshots of the Lem and Sail libraries                   */
/*  in the prover_snapshots directory (which include copies of their                     */
/*  licences), is subject to the BSD two-clause licence below.                           */
/*                                                                                       */
/*  Copyright (c) 2017-2023                                                              */
/*    Prashanth Mundkur                                                                  */
/*    Rishiyur S. Nikhil and Bluespec, Inc.                                              */
/*    Jon French                                                                         */
/*    Brian Campbell                                                                     */
/*    Robert Norton-Wright                                                               */
/*    Alasdair Armstrong                                                                 */
/*    Thomas Bauereiss                                                                   */
/*    Shaked Flur                                                                        */
/*    Christopher Pulte                                                                  */
/*    Peter Sewell                                                                       */
/*    Alexander Richardson                                                               */
/*    Hesham Almatary                                                                    */
/*    Jessica Clarke                                                                     */
/*    Microsoft, for contributions by Robert Norton-Wright and Nathaniel Wesley Filardo  */
/*    Peter Rugg                                                                         */
/*    Aril Computer Corp., for contributions by Scott Johnson                            */
/*    Philipp Tomsich                                                                    */
/*    VRULL GmbH, for contributions by its employees                                     */
/*                                                                                       */
/*  All rights reserved.                                                                 */
/*                                                                                       */
/*  This software was developed by the above within the Rigorous                         */
/*  Engineering of Mainstream Systems (REMS) project, partly funded by                   */
/*  EPSRC grant EP/K008528/1, at the Universities of Cambridge and                       */
/*  Edinburgh.                                                                           */
/*                                                                                       */
/*  This software was developed by SRI International and the University of               */
/*  Cambridge Computer Laboratory (Department of Computer Science and                    */
/*  Technology) under DARPA/AFRL contract FA8650-18-C-7809 ("CIFV"), and                 */
/*  under DARPA contract HR0011-18-C-0016 ("ECATS") as part of the DARPA                 */
/*  SSITH research programme.                                                            */
/*                                                                                       */
/*  This project has received funding from the European Research Council                 */
/*  (ERC) under the European Union’s Horizon 2020 research and innovation                */
/*  programme (grant agreement 789108, ELVER).                                           */
/*                                                                                       */
/*                                                                                       */
/*  Redistribution and use in source and binary forms, with or without                   */
/*  modification, are permitted provided that the following conditions                   */
/*  are met:                                                                             */
/*  1. Redistributions of source code must retain the above copyright                    */
/*     notice, this list of conditions and the following disclaimer.                     */
/*  2. Redistributions in binary form must reproduce the above copyright                 */
/*     notice, this list of conditions and the following disclaimer in                   */
/*     the documentation and/or other materials provided with the                        */
/*     distribution.                                                                     */
/*                                                                                       */
/*  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''                   */
/*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED                    */
/*  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A                      */
/*  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR                  */
/*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,                         */
/*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT                     */
/*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF                     */
/*  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND                  */
/*  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,                   */
/*  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT                   */
/*  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF                   */
/*  SUCH DAMAGE.                                                                         */
/*=======================================================================================*/

/* H-ext CSRs are defined whenever the hypervisor extension is present */
function clause ext_is_CSR_defined(0x34A, _) = haveHExt() /* mtinst */
function clause ext_is_CSR_defined(0x34B, _) = haveHExt() /* mtval2 */
function clause ext_is_CSR_defined(0x600, _) = haveHExt() /* hstatus */
function clause ext_is_CSR_defined(0x602, _) = haveHExt() /* hedeleg */
function clause ext_is_CSR_defined(0x603, _) = haveHExt() /* hideleg */
function clause ext_is_CSR_defined(0x604, _) = haveHExt() /* hie */
function clause ext_is_CSR_defined(0x606, _) = haveHExt() /* hcounteren */
function clause ext_is_CSR_defined(0x607, _) = haveHExt() /* hgeie */
function clause ext_is_CSR_defined(0x643, _) = haveHExt() /* htval */
function clause ext_is_CSR_defined(0x644, _) = haveHExt() /* hip */
function clause ext_is_CSR_defined(0x645, _) = haveHExt() /* hvip */
function clause ext_is_CSR_defined(0x64A, _) = haveHExt() /* htinst */
function clause ext_is_CSR_defined(0xE12, _) = haveHExt() /* hgeip */
function clause ext_is_CSR_defined(0x60A, _) = haveHExt() /* henvcfg */
function clause ext_is_CSR_defined(0x61A, _) = haveHExt() /* henvcfgh */
function clause ext_is_CSR_defined(0x680, _) = haveHExt() /* hgatp */
function clause ext_is_CSR_defined(0x605, _) = haveHExt() /* htimedelta */
function clause ext_is_CSR_defined(0x615, _) = haveHExt() /* htimedeltah */
function clause ext_is_CSR_defined(0x200, _) = haveHExt() /* vsstatus */
function clause ext_is_CSR_defined(0x204, _) = haveHExt() /* vsie */
function clause ext_is_CSR_defined(0x205, _) = haveHExt() /* vstvec */
function clause ext_is_CSR_defined(0x240, _) = haveHExt() /* vsscratch */
function clause ext_is_CSR_defined(0x241, _) = haveHExt() /* vsepc */
function clause ext_is_CSR_defined(0x242, _) = haveHExt() /* vscause */
function clause ext_is_CSR_defined(0x243, _) = haveHExt() /* vstval */
function clause ext_is_CSR_defined(0x244, _) = haveHExt() /* vsip */
function clause ext_is_CSR_defined(0x280, _) = haveHExt() /* vsatp */

function clause ext_read_CSR(0x200) = Some(vsstatus.bits())
function clause ext_read_CSR(0x204) = Some(lower_mie_to_vsie(mie, hideleg).bits())
function clause ext_read_CSR(0x205) = Some(get_trap_vector(Supervisor, V1))
function clause ext_read_CSR(0x240) = Some(vsscratch)
function clause ext_read_CSR(0x241) = Some(get_xret_target(Supervisor, V1))
function clause ext_read_CSR(0x242) = Some(vscause.bits())
function clause ext_read_CSR(0x243) = Some(vstval)
function clause ext_read_CSR(0x244) = Some(lower_mip_to_vsip(mip, hideleg).bits())
function clause ext_read_CSR(0x280) = Some(vsatp)
function clause ext_read_CSR(0x34A) = Some(mtinst)
function clause ext_read_CSR(0x34B) = Some(mtval2)
function clause ext_read_CSR(0x600) = Some(hstatus.bits())
function clause ext_read_CSR(0x602) = Some(hedeleg.bits())
function clause ext_read_CSR(0x603) = Some(hideleg.bits())
function clause ext_read_CSR(0x604) = Some(lower_mie_to_hie(mie).bits())
function clause ext_read_CSR(0x605) = Some(htimedelta[sizeof(xlen) - 1 .. 0])
function clause ext_read_CSR(0x606) = Some(zero_extend(hcounteren.bits()))
function clause ext_read_CSR(0x607) = Some(hgeie)
function clause ext_read_CSR(0x60A) = Some(henvcfg.bits()[sizeof(xlen) - 1 .. 0])
function clause ext_read_CSR(0x615) = Some(zero_extend(htimedelta[63 .. 32]))
function clause ext_read_CSR(0x61A) = Some(zero_extend(henvcfg.bits()[63 .. 32]))
function clause ext_read_CSR(0x643) = Some(htval)
function clause ext_read_CSR(0x644) = Some(lower_mip_to_hip(mip).bits())
function clause ext_read_CSR(0x645) = Some(lower_mip_to_hvip(mip).bits())
function clause ext_read_CSR(0x64A) = Some(htinst)
// Read of hgatp (0x680) is handled directly in inst_zicsr
// TODO: read handle for hcontext (0x6A8)
function clause ext_read_CSR(0xE12) = Some(hgeip)

function clause ext_write_CSR(0x200, value) = { vsstatus = legalize_vsstatus(vsstatus, value); Some(vsstatus.bits()) }
function clause ext_write_CSR(0x204, value) = { mie = legalize_vsie(mie, hideleg, value); Some(lower_mie_to_vsie(mie, hideleg).bits()) }
function clause ext_write_CSR(0x205, value) = { Some(set_trap_vector(Supervisor, V1, value)) }
function clause ext_write_CSR(0x240, value) = { vsscratch = value; Some(vsscratch) }
function clause ext_write_CSR(0x241, value) = { Some(set_xret_target(Supervisor, V1, value)) }
function clause ext_write_CSR(0x242, value) = { vscause->bits() = value; Some(vscause.bits()) }
function clause ext_write_CSR(0x243, value) = { vstval = value; Some(vstval) }
function clause ext_write_CSR(0x244, value) = { mip = legalize_vsip(mip, hideleg, value); Some(lower_mip_to_vsip(mip, hideleg).bits()) }
function clause ext_write_CSR(0x280, value) = { vsatp = value; Some(vsatp) }
function clause ext_write_CSR(0x34A, value) = { mtinst = value; Some(mtinst) }
function clause ext_write_CSR(0x34B, value) = { mtval2 = value; Some(mtval2) }
function clause ext_write_CSR(0x600, value) = { hstatus = legalize_hstatus(hstatus, value); Some(hstatus.bits()) }
function clause ext_write_CSR(0x602, value) = { hedeleg = legalize_hedeleg(hedeleg, value); Some(hedeleg.bits()) }
function clause ext_write_CSR(0x603, value) = { hideleg = legalize_hideleg(hideleg, value); Some(hideleg.bits()) }
function clause ext_write_CSR(0x604, value) = { mie = legalize_hie(mie, value); Some(lower_mie_to_hie(mie).bits()) }
function clause ext_write_CSR(0x605, value) = { htimedelta[(sizeof(xlen) - 1) .. 0] = value; Some(htimedelta[(sizeof(xlen) - 1) .. 0])}
function clause ext_write_CSR(0x606, value) = { hcounteren = legalize_hcounteren(hcounteren, value); Some(zero_extend(hcounteren.bits())) }
function clause ext_write_CSR(0x607, value) = { hgeie = legalize_hgeie(value); Some(hgeie) }
function clause ext_write_CSR(0x60A, value) = { henvcfg = if sizeof(xlen) == 32
                                                          then legalize_envcfg(henvcfg, henvcfg.bits()[63 .. 32] @ value)
                                                          else legalize_envcfg(henvcfg, value);
                                                Some(henvcfg.bits()[(sizeof(xlen) - 1) .. 0]) }
function clause ext_write_CSR(0x615, value) = { htimedelta[63 .. 32] = value[31 .. 0]; Some(zero_extend(htimedelta[63 .. 32]))} // zero_extend and value[31..0] to appease type checker
function clause ext_write_CSR(0x61A, value) = { henvcfg = legalize_envcfg(henvcfg, value[31 .. 0] @ henvcfg.bits()[31 .. 0]); Some(zero_extend(henvcfg.bits()[63 .. 32])) } // zero_extend and value[31..0] to appease type checker
function clause ext_write_CSR(0x643, value) = { htval = value; Some(htval) }
function clause ext_write_CSR(0x644, value) = { mip = legalize_hip(mip, value); Some(lower_mip_to_hip(mip).bits()) }
function clause ext_write_CSR(0x645, value) = { mip = legalize_hvip(mip, value); Some(lower_mip_to_hvip(mip).bits()) }
function clause ext_write_CSR(0x64A, value) = { htinst = value; Some(htinst) }
// Write of hgatp (0x680) is handled directly in inst_zicsr
// TODO: write handle for hcontext (0x6A8)
// Write handler for hgeip is not required since it's read-only

/* Initialize hypervisor extension */
function init_hext() -> unit = {
  /* Start with V=0 */
  cur_virtualization = V0;

  /* Init M-mode CRSs */

  if sizeof(xlen) == 32
  then mstatush = set_mstatush_MPV(mstatush, virtMode_to_bits(V0))
  else mstatus = set_mstatus_MPV(mstatus, virtMode_to_bits(V0));

  if sizeof(xlen) == 32
  then mstatush = set_mstatush_GVA(mstatush, 0b0)
  else mstatus = set_mstatus_GVA(mstatus, 0b0);

  mtinst = zeros();
  mtval2 = zeros();

  mideleg = update_SGEI(mideleg, 0b1); /* Note: SGEIE is "read-only one" only if GEILEN > 0 */
  mideleg = update_VSEI(mideleg, 0b1);
  mideleg = update_VSTI(mideleg, 0b1);
  mideleg = update_VSSI(mideleg, 0b1);

  /* Init HS-mode CSRs */

  hstatus->bits() = zeros();
  hstatus = set_hstatus_VSXL(hstatus, misa.MXL()); /* Dynamic XLEN changes are not (yet) supported */

  hedeleg->bits() = zeros();
  hideleg->bits() = zeros();
  hcounteren->bits() = zeros();
  htval = zeros();
  htinst = zeros();
  hgeie = legalize_hgeie(zeros());
  hgeip = zeros();
  /* TODO: init henvcfg */
  /* TODO: init henvcfgh */
  htimedelta = zeros();

  /* Init VS-mode CSRs */

  vsstatus->bits() = zeros();
  vsstatus = set_vsstatus_UXL(vsstatus, misa.MXL()); /* Dynamic XLEN changes are not (yet) supported */
  vstvec->bits() = zeros();
  vsscratch = zeros();
  vsepc = zeros();
  vscause->bits() = zeros();
  vstval = zeros();
  vsatp = zeros();
}

/* FIXME: The cases below should probably be checked in unittests instead of listed here
 *
 * According to the spec. (V20211203 - Section 9.6), this should happen in the following cases:
 *   [X] in VS-mode, attempts to access a non-high-half counter CSR when the corresponding bit
 *       in hcounteren is 0 and the same bit in mcounteren is 1;
 *   [ ] in VS-mode, if XLEN=32, attempts to access a high-half counter CSR when the
 *       corresponding bit in hcounteren is 0 and the same bit in mcounteren is 1;
 *   [X] in VU-mode, attempts to access a non-high-half counter CSR when the corresponding bit
 *       in either hcounteren or scounteren is 0 and the same bit in mcounteren is 1;
 *   [ ] in VU-mode, if XLEN=32, attempts to access a high-half counter CSR when the
 *       corresponding bit in either hcounteren or scounteren is 0 and the same bit in
 *       mcounteren is 1;
 *   [x] in VS-mode or VU-mode, attempts to access an implemented non-high-half hypervisor CSR
 *       or VS CSR when the same access (read/write) would be allowed in HS-mode, assuming
 *       mstatus.TVM=0;
 *   [ ] in VS-mode or VU-mode, if XLEN=32, attempts to access an implemented high-half
 *       hypervisor CSR or high-half VS CSR when the same access (read/write) to the CSR’s
 *       low-half partner would be allowed in HS-mode, assuming mstatus.TVM=0;
 *   [x] in VU-mode, attempts to access an implemented non-high-half supervisor CSR when the
 *       same access (read/write) would be allowed in HS-mode, assuming mstatus.TVM=0;
 *   [ ] in VU-mode, if XLEN=32, attempts to access an implemented high-half supervisor CSR
 *       when the same access to the CSR’s low-half
 *       partner would be allowed in HS-mode, assuming mstatus.TVM=0;
 *   [X] in VS-mode, attempts to access satp, when hstatus.VTVM=1
 */
/*! Determine if an illegal CSR access should raise a "virtual instruction exception" instead of an "illegal instruction exception" */
function csr_access_raises_virtual_instr(csr : csreg, p : Privilege, v: Virtualization, isWrite : bool) -> bool = {
  if v == V0
  then false
  // Would HS-access be allowed?
  // Note: Can't reuse check_CSR since it also checks TVM
  else is_CSR_defined(csr, Supervisor) &
       check_CSR_access(csrAccess(csr), csrPriv(csr), Supervisor, V0, isWrite) &
       check_Counteren(csr, Supervisor, V0) &
       check_seed_CSR(csr, Supervisor, isWrite)
}
