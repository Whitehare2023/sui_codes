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

    fun init(ctx: &mut TxContext) {
        let mint_cap = MintCap {
            id: object::new(ctx),
        };
        let deployer = sui::tx_context::sender(ctx);
        transfer::transfer(mint_cap,deployer);
    }

    public fun new_poap(
        _: &MintCap,
        ctx: &mut TxContext,
    ):POAP {
        POAP {
            id: object::new(ctx)
        }
    }

    entry fun create_poap (
        cap: &MintCap,
        to: address,
        ctx: &mut TxContext,
    ){
        let poap = new_poap(cap, ctx);
        transfer::transfer(poap, to);
    }

    entry fun create_mint_cap(
        _: &MintCap,
        to: address,
        ctx: &mut TxContext,
    ){
        let mint_cap = MintCap {
            id: object::new(ctx),
        };
        transfer::transfer(mint_cap, to);
    }

}
