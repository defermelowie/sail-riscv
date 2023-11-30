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

/* Shared definitions for supervisor-mode page-table-entries and permission checks.
 *
 * These definitions are independent of xlen and do not involve
 * accessing physical memory.
 */

/* PageSize */

let PAGESIZE_BITS = 12

/*
 * Definitions for RV32, which has a single address translation mode: Sv32.
 */

type vaddr32 = bits(32)
type paddr32 = bits(34)
type pte32   = bits(32)

/* asid */
type asid32 = bits(9)

function curAsid32(s : bits(32)) -> asid32 = {
  let s = Mk_Satp32(s);
  s.Asid()
}

/* page table base from satp */
function curPTB32(s : bits(32)) -> paddr32 = {
  let s : Satp32 = Mk_Satp32(s);
  shiftl(zero_extend(s.PPN()), PAGESIZE_BITS)
}

/* Sv32 parameters and bitfield layouts */

let SV32_LEVEL_BITS = 10
let SV32_LEVELS     = 2
let PTE32_LOG_SIZE  = 2
let PTE32_SIZE      = 4

bitfield SV32_Vaddr : vaddr32 = {
  VPNi  : 31 .. 12,
  PgOfs : 11 .. 0
}

bitfield SV32_Paddr : paddr32 = {
  PPNi  : 33 .. 12,
  PgOfs : 11 .. 0
}

bitfield SV32_PTE : pte32 = {
  PPNi  : 31 .. 10,
  RSW   : 9  .. 8,
  BITS  : 7  .. 0
}

/*
 * Definitions for RV64, which has two defined address translation modes: Sv39 and Sv48.
 */

/* Sv48 and Sv64 are reserved but not defined.  The size of the VPN
 * increases by 9 bits through Sv39, Sv48 and Sv57, but not for Sv64.
 * Also, the 45-bit size of the VPN for Sv57 exceeds the 44-bit size
 * of the PPN in satp64.  Due to these corner cases, it is unlikely
 * that definitions can be shared across all four schemes, so separate
 * definitions might eventually be needed for each translation mode.
 *
 * But to keep things simple for now, since Sv39 and Sv48 have the
 * same PPN size, we share some definitions.
 */

type paddr64 = bits(56)
type pte64   = bits(64)

/* asid */

type asid64 = bits(16)
type vmid64 = bits(14)

function curAsid64(s : bits(64)) -> asid64 = {
  let s = Mk_Satp64(s);
  s.Asid()
}

/* page table base from satp */
function curPTB64(s : bits(64)) -> paddr64 = {
  let s = Mk_Satp64(s);
  shiftl(zero_extend(s.PPN()), PAGESIZE_BITS)
}

/* Sv39 parameters and bitfield layouts */

let SV39_LEVEL_BITS = 9
let SV39_LEVELS     = 3
let PTE39_LOG_SIZE  = 3
let PTE39_SIZE      = 8

type vaddr39 = bits(39)
type vpn39   = bits(27)
type pte39   = pte64

bitfield SV39_Vaddr : vaddr39 = {
  VPNi  : 38 .. 12,
  PgOfs : 11 .. 0
}

bitfield SV39_Paddr : paddr64 = {
  PPNi  : 55 .. 12,
  PgOfs : 11 .. 0
}

bitfield SV39_PTE : pte39 = {
  Ext   : 63 .. 54,
  PPNi  : 53 .. 10,
  RSW   : 9  .. 8,
  BITS  : 7  .. 0
}

/* Sv48 parameters and bitfield layouts */

let SV48_LEVEL_BITS = 9
let SV48_LEVELS     = 4
let PTE48_LOG_SIZE  = 3
let PTE48_SIZE      = 8

type vaddr48 = bits(48)
type vpn48   = bits(44)
type pte48   = pte64

bitfield SV48_Vaddr : vaddr48 = {
  VPNi  : 47 .. 12,
  PgOfs : 11 .. 0
}

bitfield SV48_Paddr : paddr64 = {
  PPNi  : 55 .. 12,
  PgOfs : 11 .. 0
}

bitfield SV48_PTE : pte48 = {
  Ext   : 63 .. 54,
  PPNi  : 53 .. 10,
  RSW   : 9  .. 8,
  BITS  : 7  .. 0
}

/* Get the amount of VPN[i] bits for a given address translation mode */
function vpn_level_bits(i: nat, atm: AddressTranslationMode) -> range(9, 12) = {
  match (atm, i) {
    (Bare, _)   => internal_error(__FILE__, __LINE__, "get amount of VPN bits for Bare"),
    (Sv32, _)   => 10,
    (Sv32x4, 1) => 12,
    (Sv32x4, _) => 10,
    (Sv39x4, 2) => 11,
    (Sv48x4, 3) => 11,
    (Sv57x4, 4) => 11,
    (_, _)      =>  9
  }
}

/* Get log2 of address translation mode's page table entry size
 * (amount of bits to shift VPN[i] in order to get address offset)
 */
function pte_logsize(atm: AddressTranslationMode) -> nat = {
  match (atm) {
    Bare   => internal_error(__FILE__, __LINE__, "get log2 of pte size for Bare"),
    Sv32   => 2,
    Sv32x4 => 2,
    _      => 3
  }
}

/* The functions below are parameterized by 'ppnlen, 'vpnlen and
 * 'paddrlen, to support various address translation modes such
 * as Sv32, Sv32x4, Sv39, ...
 */

/* Get level i page table offset from virtual page number (VPN) */
val PtOfs_from_VPNi : forall 'vpnlen, 'vpnlen < xlen.
  (nat, bits('vpnlen), AddressTranslationMode) -> xlenbits
function PtOfs_from_VPNi(i, vpn, atm) =
  let vpn : xlenbits = zero_extend(vpn) in match (atm) {
    Bare => internal_error(__FILE__, __LINE__, "get page table offset for Bare"),
    _    => shiftl(zero_extend(shiftr(vpn, i * vpn_level_bits(0, atm))[vpn_level_bits(i, atm) - 1  .. 0]), pte_logsize(atm)),
  }

/* Check if a given PPN is a valid pointer to a level i superpage */
val is_valid_superpage_ppn : forall 'ppnlen, 'ppnlen > 0.
  (nat, bits('ppnlen), AddressTranslationMode) -> bool
function is_valid_superpage_ppn(i, ppn, atm) = {
  /* fixme hack: use a better idiom for masks */
  let mask : bits('ppnlen) = shiftl(ppn ^ ppn ^ zero_extend(0b1), i * vpn_level_bits(0, atm)) - 1;
  (ppn & mask) == zero_extend(0b0)
}

/* Build physical addresses */
val build_paddr : forall 'ppnlen, 'ppnlen > 0.
  (bits('ppnlen), bits(12)) -> bits('ppnlen + 12)
function build_paddr(ppn, pgofs) = append(ppn, pgofs)

val build_superpage_paddr : forall 'ppnlen 'vpnlen, ('ppnlen >= 'vpnlen & 'ppnlen > 0). /* FIXME: 'ppnlen >= 'vpnlen does not hold for Sv57 and Sv57x4 */
  (nat, bits('ppnlen), bits('vpnlen), bits(12), AddressTranslationMode) -> bits('ppnlen + 12)
function build_superpage_paddr(i, ppn, vpn, pgofs, atm) = {
  /* fixme hack: use a better idiom for masks */
  let mask : bits('ppnlen) = shiftl(ppn ^ ppn ^ zero_extend(0b1), i * vpn_level_bits(0, atm)) - 1;
  let ppn  : bits('ppnlen) = ppn | (zero_extend(vpn) & mask);
  append(ppn, pgofs)
}

/* The types below are parameterized by 'paddr and 'pte to support
 * various architectural widths (e.g. RV32, RV64).  ext_ptw supports
 * extensions to the default address translation and page-table-walk.
 */

/* Result of a page-table walk.  */

union PTW_Result('paddr : Type, 'pte : Type) = {
  PTW_Success: ('paddr, 'pte, 'paddr, nat, bool, ext_ptw),
  PTW_Failure: (PTW_Error, ext_ptw)
}

/* Result of address translation */

union TR_Result('paddr : Type) = {
  TR_Address : ('paddr, ext_ptw),
  TR_Failure : (ExceptionType, ExceptionContext, ext_ptw)
}

/* High level address translation */
val translateAddr : (xlenbits, AccessType(ext_access_type)) -> TR_Result(xlenbits)
val translateAddr_pv : (xlenbits, AccessType(ext_access_type), Privilege, Virtualization) -> TR_Result(xlenbits)
val sStageTranslateAddr : (xlenbits, AccessType(ext_access_type), Privilege, Virtualization) -> TR_Result(xlenbits)
val gStageTranslateAddr : (xlenbits, AccessType(ext_access_type), Privilege, Virtualization) -> TR_Result(xlenbits)
