module transcript::transcript{
    use sui::object::{Self,UID};
    use sui::tx_context::{Self,TxContext};
    use sui::transfer;

    struct TranscriptObject has key{
        id:UID,
        history:u8,
        math:u8,
        literature:u8,
    }

    public entry fun create_transcript_object(history:u8,math:u8,literature:u8,ctx: &mut TxContext){
        let transcriptObject = TranscriptObject{
            id: object::new(ctx),
            history,
            math,
            literature,
        };
        transfer::transfer(transcriptObject,tx_context::sender(ctx))
    }
}