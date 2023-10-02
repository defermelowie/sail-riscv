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

/* Sv39x4 constants */
let SV39x4_LEVELS     = 3
let SV39x4_LEVEL_BITS = 9
let PTE39x4_SIZE      = 8
let PTE39x4_LOG_SIZE  = 3

/* Sv39x4 types */
type vmid39x4  = vmid64
type pte39x4   = pte64
type paddr39x4 = paddr64
type vaddr39x4 = bits(41)

/* Sv39x4 bitfield layouts */
bitfield Sv39x4_VAddr : vaddr39x4 = {
  VPNi  : 40 .. 12,
  PgOfs : 11 .. 0
}

/* Check if upper bits are '0' */
function isValidSv39x4Addr(vAddr: xlenbits) -> bool = {
  vAddr[63 .. 41] == zeros()
}

/* Sv39x4 page walk */
val walk39x4 : (xlenbits, vaddr39x4, AccessType(ext_access_type), bool, bool, nat, ext_ptw) -> PTW_Result(paddr39x4, SV39_PTE)
function walk39x4(ptb, gpa, ac, mxr, sum, level, ext_ptw) = {
  // print_platform("[WARNING] Sv39x4 page walk is not yet fully implemented");
  /* Construct pte address */
  let va = Mk_Sv39x4_VAddr(gpa);
  let pt_ofs = PtOfs_from_VPNi(level, zero_extend(va.VPNi()), Sv39x4);
  let pte_addr = (ptb + pt_ofs)[55 .. 0];
  /* Read pte */
  match (mem_read_priv(Read(Data), Supervisor, zero_extend(pte_addr), 8, false, false, false)) {
    MemException(_) => PTW_Failure(PTW_Access(), ext_ptw),
    MemValue(v) => {
      // print("walk39x4(gpa=" ^ BitStr(gpa) ^ " level=" ^ string_of_int(level)
      //   ^ " pt_base=" ^ BitStr(ptb)
      //   ^ " pt_ofs=" ^ BitStr(pt_ofs)
      //   ^ " pte_addr=" ^ BitStr(pte_addr)
      //   ^ " pte=" ^ BitStr(v) ^ ")");
      let pte = Mk_SV39_PTE(v);
      let ext_pte = pte.Ext();
      let pattr = Mk_PTE_Bits(pte.BITS());

      if isInvalidPTE(pattr.bits(), ext_pte) then PTW_Failure(PTW_Invalid_PTE(), ext_ptw)
      else if isPTEPtr(pattr.bits(), ext_pte) then { /* page table pointer */
        if level > 0 then {
          let ptb_next : xlenbits = shiftl(zero_extend(pte.PPNi()), PAGESIZE_BITS);
          let level_next = level - 1;
          walk39x4(ptb_next, gpa, ac, mxr, sum, level_next, ext_ptw)
        } else PTW_Failure(PTW_Invalid_PTE(), ext_ptw)
      /* check access permissions */
      } else match checkPTEPermission(ac, User, mxr, sum, pattr, ext_pte, ext_ptw) {
        PTE_Check_Failure(ext_ptw, ext_ptw_fail) => PTW_Failure(ext_get_ptw_error(ext_ptw_fail), ext_ptw),
        PTE_Check_Success(ext_ptw)  => {
          // if level > 0 then { /* page table leaf -> superpage */
          //   let mask = shiftl(0b1, level * SV39x4_LEVEL_BITS) - 1;
          //   if (pte.PPNi() & mask) != zero_extend(0b0) then PTW_Failure(PTW_Misaligned(), ext_ptw) /* misaligned superpage */
          //   else {
          //     let p_addr = append((pte.PPNi | zero_extend(va.VPNi()) & mask), va.PgOfs());
          //     PTW_Success(p_addr, pte, pte_addr, level, false, ext_ptw)
          //   }
          // } else {  /* page table leaf -> normal page */
            let p_addr = append(pte.PPNi(), va.PgOfs());
            PTW_Success(p_addr, pte, pte_addr, level, false, ext_ptw)
          // }
        }
      }
    }
  }
}

/* Translate Sv39x4 guest virtual address to supervisor physical address
 *
 * NOTE: vmid is not used but is required for implementing TLBs in the future
 */
val translate39x4 : (vmid39x4, paddr39x4, vaddr39x4, AccessType(ext_access_type), bool, bool, ext_ptw) -> TR_Result(paddr39x4, PTW_Error)
function translate39x4(vmid, ptb, gpa, ac, mxr, sum, ext_ptw) = {
  match walk39x4(zero_extend(ptb), gpa, ac, mxr, sum, SV39x4_LEVELS - 1, ext_ptw) {
    PTW_Failure(f, ext_ptw) => TR_Failure(f, ext_ptw),
    PTW_Success(pAddr, pte, pteAddr, level, global, ext_ptw) => TR_Address(pAddr, ext_ptw)
    /* TODO: update A,D bits */
  }
}
