/* Virtualization modes */

type virt_mode = bits(1)
enum Virtualization = {V0, V1}

val virtMode_to_bits : Virtualization -> virt_mode
function virtMode_to_bits (v) =
  match (v) {
    V0 => 0b0,
    V1 => 0b1
  }

val virtMode_of_bits : virt_mode -> Virtualization
function virtMode_of_bits(v) =
  match (v) {
    0b0 => V0,
    0b1 => V1
  }

val virtMode_to_str : Virtualization -> string
function virtMode_to_str (v) =
  match (v) {
    V0 => "V=0",
    V1 => "V=1"
  }

overload to_str = {virtMode_to_str}
