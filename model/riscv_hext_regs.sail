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
