module poap::poap{
    
    use sui::object::{Self,UID};
    use sui::transfer;
    use sui::tx_context::{Self,TxContext};

    struct POAP has key {
        id:UID,
    }

    struct MintCap has key {
        id:UID,
    }

    public fun new(
        _: &MintCap,
        ctx: &mut TxContext,
    ):POAP {
        POAP {
            id: object::new(ctx)
        }
    }

    entry fun create (
        cap: &MintCap,
        to: address,
        ctx: &mut TxContext,
    ){
        let poap = new(cap, ctx);
        transfer::transfer(poap, to);
    }
}