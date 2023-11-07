
/* ****************************************************************** */
/* This file specifies the instructions in the 'H' extension.         */

/* ****************************************************************** */

// TODO: hlv.b
// TODO: hlv.bu
// TODO: hlv.h
// TODO: hlv.hu
// TODO: hlv.w
// TODO: hlv.wu
// TODO: hlv.d

union clause ast = HLV : (word_width, bool, regidx, regidx)

mapping clause encdec = HLV(width, is_unsigned, rs1, rd)
  <-> 0b0110 @ size_bits(width) @ 0b0 @ 0b0000 @ bool_bits(is_unsigned) @ rs1 @ 0b100 @ rd @ 0b1110011

function clause execute(HLV(width, is_unsigned, rs1, rd)) =
  /* Unsigned loads are only valid for widths strictly less than xlen, signed loads also present for widths equal to xlen */
  if (is_unsigned & word_width_bytes(width) >= sizeof(xlen_bytes)) | (word_width_bytes(width) > sizeof(xlen_bytes))
  then { handle_illegal(); RETIRE_FAIL }
  /* Extensions can perform additional checks on address validity. */
  else match ext_data_get_addr(rs1, zeros(), Read(Data), width) {
    Ext_DataAddr_Error(e)  => { ext_handle_data_check_error(e); RETIRE_FAIL },
    Ext_DataAddr_OK(vaddr) =>
      /* Address could be misaligned */
      if check_misaligned(vaddr, width)
      then { handle_mem_exception(vaddr, E_Load_Addr_Align()); RETIRE_FAIL }
      /* Address translation en protection should be performed as if V=1 */
      else match translateAddr_pv(vaddr, Read(Data), privLevel_of_bits(zero_extend(hstatus.SPVP())), V1) {
        TR_Failure(e, _) => { handle_mem_exception(vaddr, e); RETIRE_FAIL },
        TR_Address(paddr, _) => match (width) {
          BYTE   => process_load(rd, vaddr, mem_read(Read(Data), paddr, 1, false, false, false), is_unsigned),
          HALF   => process_load(rd, vaddr, mem_read(Read(Data), paddr, 2, false, false, false), is_unsigned),
          WORD   => process_load(rd, vaddr, mem_read(Read(Data), paddr, 4, false, false, false), is_unsigned),
          DOUBLE if sizeof(xlen_bytes) >= 8 => process_load(rd, vaddr, mem_read(Read(Data), paddr, 8, false, false, false), is_unsigned),
        }
      }
  }

mapping clause assembly = HLV(width, is_unsigned, rs1, rd)
  <-> "hlv." ^ size_mnemonic(width) ^ maybe_u(is_unsigned) ^ spc() ^ reg_name(rd) ^ sep() ^ reg_name(rs1)

/* ****************************************************************** */

// TODO: hsv.b
// TODO: hsv.h
// TODO: hsv.w
// TODO: hsv.d

/* ****************************************************************** */

// TODO: hlvx.hu
// TODO: hlvx.wu

/* ****************************************************************** */

union clause ast = HFENCE_VVMA : (regidx, regidx)

mapping clause encdec = HFENCE_VVMA(rs1, rs2)
  <-> 0b0010001 @ rs2 @ rs1 @ 0b000 @ 0b00000 @ 0b1110011

function clause execute HFENCE_VVMA(rs1, rs2) = {
  let addr : option(xlenbits) = if rs1 == 0b00000 then None() else Some(X(rs1));
  let asid : option(xlenbits) = if rs2 == 0b00000 then None() else Some(X(rs2));
  match (cur_privilege, cur_virtualization) {
    (User, V1)       => { handle_virtual_instr(); RETIRE_FAIL },
    (User, V0)       => { handle_illegal(); RETIRE_FAIL },
    (Supervisor, V1) => { handle_virtual_instr(); RETIRE_FAIL },
    /* TLB is shared between S-stage & VS-stage address translation */
    (Supervisor, V0) => { flush_TLB(asid, addr); RETIRE_SUCCESS },
    (Machine, _)     => { flush_TLB(asid, addr); RETIRE_SUCCESS }
  }
}

mapping clause assembly = HFENCE_VVMA(rs1, rs2)
  <-> "hfence.vvma" ^ spc() ^ reg_name(rs1) ^ sep() ^ reg_name(rs2)

/* ****************************************************************** */

union clause ast = HFENCE_GVMA : (regidx, regidx)

mapping clause encdec = HFENCE_GVMA(rs1, rs2)
  <-> 0b0110001 @ rs2 @ rs1 @ 0b000 @ 0b00000 @ 0b1110011

function clause execute HFENCE_GVMA(rs1, rs2) = {
  let addr : option(xlenbits) = if rs1 == 0b00000 then None() else Some(X(rs1));
  let vmid : option(xlenbits) = if rs2 == 0b00000 then None() else Some(X(rs2));
  match (cur_privilege, cur_virtualization) {
    (User, V1)       => { handle_virtual_instr(); RETIRE_FAIL },
    (User, V0)       => { handle_illegal(); RETIRE_FAIL },
    (Supervisor, V1) => { handle_virtual_instr(); RETIRE_FAIL },
    (Supervisor, V0) => match mstatus.TVM() {
      0b1 => { handle_illegal(); RETIRE_FAIL },
      0b0 => { /* TODO: implement hfence.gvma */ RETIRE_SUCCESS }
      },
    (Machine, _)    => { /* TODO: implement hfence.gvma */ RETIRE_SUCCESS }
  }
}

mapping clause assembly = HFENCE_GVMA(rs1, rs2)
  <-> "hfence.gvma" ^ spc() ^ reg_name(rs1) ^ sep() ^ reg_name(rs2)

/* ****************************************************************** */
