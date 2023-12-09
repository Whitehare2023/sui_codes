module transfer_sui::sui_coin {
    use sui::transfer;
    use sui::coin::Coin;
    use sui::tx_context::{Self,TxContext};

    public entry fun transfer_sui(to: address, amount: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let coin = sui::coin::Coin::withdraw(sender, amount, ctx);
        transfer::transfer(coin, to);
    }
}
