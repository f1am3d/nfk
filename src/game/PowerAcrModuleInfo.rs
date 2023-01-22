pub mod PowerAcrModuleInfo {
    const PowerArcModuleSignature: * [char] = "AA6F3C60-37D7-11D4-B4BF-D80DBEC04C01";

    #[derive(PackedStruct)]
    pub struct TPowerArcModuleInfo {
        Signature: char,
        // must be eq to PowerArcModuleSignature
        Name: char,
        // short name
        Description: char,
        // full description
        Options: char,
        // opt list delimited with #0
        // bit per char on calgary corpus *100
        DefaultBPC: i32,
        MaxBPC: i32,

        #[packed_field(bits = "0..=7")]
        ModuleID: Integer<char, packed_bits::Bits::<7>>,
        #[packed_field(bits = "0..=1")]
        ModuleIDW: Integer<i32, packed_bits::Bits::<2>>,
    }
}