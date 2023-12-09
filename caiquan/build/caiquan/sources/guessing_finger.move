module caiquan::guessing_finger{
    use std::vector;
    use std::string;
    use sui::event;
    use sui::coin::{Self,Coin};
    use sui::clock::{Self, Clock};
    use sui::sui::{Self,SUI};
    use sui::balance::{Self, Balance, Supply};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer::{Self};
    use sui::object::{Self,UID};


    const ENotEnoughFee :u64 = 0;
    const EInCorretGestures :u64 = 1;
    const Play_Fee:u64 = 10_000_000;

    struct Result has copy, drop {
        msg: string::String
    }

    struct SuiHolder has key{
        id : UID,
        balance: Balance<SUI>,
    }  
    
    fun init(ctx: &mut TxContext){
        let suiHolder = SuiHolder { 
            id:object::new(ctx), 
            balance:balance::zero(),
        };
        transfer::share_object(suiHolder);
    }
    

    //you can pass '0x6' as clock parameter for calling play function
    public fun play(sui_holder: &mut SuiHolder,input_gesture: vector<u8>, fee: &mut Coin<SUI>,clock: &Clock,ctx: &mut TxContext) {
        //assume it needs pay 0.1 sui to play this game one time
        //tranfer game fee to contract
        let amount = coin::value(fee);
        assert!(amount >= Play_Fee , ENotEnoughFee);

        let fee_balance = coin::balance_mut(fee);
        // let fee_balance = coin::balance_mut(&mut fee);
        let pay_balance = balance::split(fee_balance,Play_Fee);
        let pay_coin = coin::from_balance(pay_balance,ctx);
        coin::put(&mut sui_holder.balance,pay_coin);

        //get current block timestamp
        let timestamp_ms =  clock::timestamp_ms(clock);
        //compute a random num by timestamp_ms
        let random_num = timestamp_ms % 3;


        //encapsulate all gestures
        let all_gestures = vector::empty<vector<u8>>();
   
        vector::push_back(&mut all_gestures, b"Rock");
        vector::push_back(&mut all_gestures, b"Scissors");
        vector::push_back(&mut all_gestures, b"Paper");


        //random_num
        let random_gestures = vector::borrow(&all_gestures,random_num);

        let log1 = string::utf8(b", your input_gesture is :");
        string::append(&mut log1, string::utf8(input_gesture));

        let log2 = string::utf8(b"computer's gesture is :");
        string::append(&mut log2, string::utf8(*random_gestures));
        string::append(&mut log2, log1);

        let result1 = Result { msg: log2 };
        event::emit(result1);


        assert!((
            input_gesture == b"Rock" || 
            input_gesture == b"Scissors" || 
            input_gesture == b"Paper") ,EInCorretGestures);
        
        let log;
        if (input_gesture == *random_gestures) {
            log = b"dogfall";
            let refund = coin::take(&mut sui_holder.balance,Play_Fee,ctx);
            transfer::public_transfer(refund,tx_context::sender(ctx));
        }else if (
            (input_gesture == b"Scissors" && *random_gestures == b"Rock") || 
            (input_gesture == b"Rock" && *random_gestures == b"Paper") || 
            (input_gesture == b"Paper" && *random_gestures == b"Scissors")
        ) {
            log = b"you lost!";
        }else {
            log = b"you win!";
            // balance: &mut Balance<T>, value: u64, ctx: &mut TxContext,
            let refund = coin::take(&mut sui_holder.balance,Play_Fee * 2,ctx);
            transfer::public_transfer(refund,tx_context::sender(ctx));
        };

        let result = Result { msg: string::utf8(log) };
        event::emit(result);
    }
}