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

/* H-ext CSR defined handles */
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

/* H-ext CSR read handles */
// function clause ext_read_CSR(0x34A) = Some() /* mtinst */
// function clause ext_read_CSR(0x34B) = Some() /* mtval2 */
function clause ext_read_CSR(0x600) = Some(get_hstatus()) /* hstatus */
function clause ext_read_CSR(0x602) = Some(get_hedeleg()) /* hedeleg */
// function clause ext_read_CSR(0x603) = Some() /* hideleg */
// function clause ext_read_CSR(0x604) = Some() /* hie */
// function clause ext_read_CSR(0x606) = Some() /* hcounteren */
// function clause ext_read_CSR(0x607) = Some() /* hgeie */
// function clause ext_read_CSR(0x643) = Some() /* htval */
// function clause ext_read_CSR(0x644) = Some() /* hip */
// function clause ext_read_CSR(0x645) = Some() /* hvip */
// function clause ext_read_CSR(0x64A) = Some() /* htinst */
// function clause ext_read_CSR(0xE12) = Some() /* hgeip */
// function clause ext_read_CSR(0x60A) = Some() /* henvcfg */
// function clause ext_read_CSR(0x61A) = Some() /* henvcfgh */
// function clause ext_read_CSR(0x680) = Some() /* hgatp */
// function clause ext_read_CSR(0x605) = Some() /* htimedelta */
// function clause ext_read_CSR(0x615) = Some() /* htimedeltah */
/* TODO: VS* CSR read access checks */
function clause ext_read_CSR(0x200) = Some(get_vsstatus()) /* vsstatus */
// function clause ext_read_CSR(0x204) = Some() /* vsie */
function clause ext_read_CSR(0x205) = Some(get_trap_vector(Supervisor, V1)) /* vstvec */
function clause ext_read_CSR(0x240) = Some(get_vsscratch()) /* vsscratch */
function clause ext_read_CSR(0x241) = Some(get_xret_target(Supervisor, V1)) /* vsepc */
function clause ext_read_CSR(0x242) = Some(get_vscause()) /* vscause */
function clause ext_read_CSR(0x243) = Some(get_vstval()) /* vstval */
// function clause ext_read_CSR(0x244) = Some() /* vsip */
// function clause ext_read_CSR(0x280) = Some() /* vsatp */

/* H-ext CSR write handles */
function clause ext_write_CSR(0x600, value) = { hstatus = legalize_hstatus(hstatus, value); Some(get_hstatus()) }
function clause ext_write_CSR(0x602, value) = { hedeleg = legalize_hedeleg(hedeleg, value); Some(get_hedeleg()) }
/* TODO: VS* CSR write access checks */
function clause ext_write_CSR(0x200, value) = { vsstatus = legalize_vsstatus(vsstatus, value); Some(get_vsstatus()) }
function clause ext_write_CSR(0x205, value) = { Some(set_trap_vector(Supervisor, V1, value)) }
function clause ext_write_CSR(0x240, value) = { vsscratch = value; Some(get_vsscratch()) }
function clause ext_write_CSR(0x241, value) = { Some(set_xret_target(Supervisor, V1, value)) }
function clause ext_write_CSR(0x242, value) = { vscause->bits() = value; Some(get_vscause()) }
function clause ext_write_CSR(0x243, value) = { vstval = value; Some(get_vstval()) }

/* Initialize hypervisor extension */
function init_hext() -> unit = {
  assert(sys_enable_hext());

  /* Start with V=0 */
  cur_virtualization = V0;

  /* Init M-mode CRSs */

  if sizeof(xlen) == 32
  then mstatush = set_mstatush_MPV(mstatush, virtMode_to_bits(V0))
  else mstatus = set_mstatus_MPV(mstatus, virtMode_to_bits(V0));

  if sizeof(xlen) == 32
  then mstatush = set_mstatush_GVA(mstatush, 0b0)
  else mstatus = set_mstatus_GVA(mstatus, 0b0);

  mtinst = zero_extend(0b0);
  mtval2 = zero_extend(0b0);

  /* TODO: mip */

  mie = update_SGEI(mie, 0b0);
  mie = update_VSEI(mie, 0b0);
  mie = update_VSTI(mie, 0b0);
  mie = update_VSSI(mie, 0b0);

  mideleg = update_SGEI(mideleg, 0b1); /* TODO: SGEIE is "read-only one" only if GEILEN > 0 */
  mideleg = update_VSEI(mideleg, 0b1);
  mideleg = update_VSTI(mideleg, 0b1);
  mideleg = update_VSSI(mideleg, 0b1);

  /* Init HS-mode CSRs */

  hstatus->bits() = zero_extend(0b0);
  hstatus = set_hstatus_VSXL(hstatus, misa.MXL()); /* Dynamic XLEN changes are not (yet) supported */

  hedeleg->bits() = zero_extend(0b0);
  /* TODO: init hideleg */
  /* TODO: init hie */
  /* TODO: init hcounteren */
  /* TODO: init hgeie */
  /* TODO: init htval */
  /* TODO: init hip */
  /* TODO: init hvip */
  /* TODO: init htinst */
  /* TODO: init hgeip */
  /* TODO: init henvcfg */
  /* TODO: init henvcfgh */
  /* TODO: init hgatp */
  /* TODO: init htimedelta */
  /* TODO: init htimedeltah */

  /* Init VS-mode CSRs */

  vsstatus->bits() = zero_extend(0b0);
  vsstatus = set_vsstatus_UXL(vsstatus, misa.MXL()); /* Dynamic XLEN changes are not (yet) supported */

  vstvec->bits() = zero_extend(0b0);
  vsscratch = zero_extend(0b0);
  vsepc = zero_extend(0b0);
  vscause->bits() = zero_extend(0b0);
  vstval = zero_extend(0b0);
  /* TODO: init vsie */
  /* TODO: init vsip */
  /* TODO: init vsatp */
}
