/* Virtualization modes */
enum Virtualization = {V0, V1}
type virt_mode = bits(1)

val virtualization : virt_mode -> Virtualization
function virtualization(v) =
    match (v) {
    0b0 => V0,
    0b1 => V1
  }

val virt_to_bits : Virtualization -> virt_mode
function virt_to_bits (v) =
  match (v) {
    V0 => 0b0,
    V1 => 0b1
  }

val virt_to_str : Virtualization -> string
function virt_to_str (v) =
  match (v) {
    V0 => "V=0",
    V1 => "V=1"
  }

overload to_str = {virt_to_str}
