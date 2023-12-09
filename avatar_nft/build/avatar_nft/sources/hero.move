module avatar_nft::hero{
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::display;
    use sui::package;
    use std::string::utf8;
    use sui::clock::{Self, Clock};
    struct HERO has drop {}

    struct MyHero has key{
        id: UID,
        tokenId: u64,
        hp: u64,
        mp: u64,
        xp: u64,
        level: u64,
        createTime: u64
    }
    
    struct State has key {
        id: UID,
        count: u64
    }

    fun init(witness: HERO, ctx:&mut TxContext){
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
            utf8(b"hp"),
            utf8(b"mp"),
            utf8(b"xp"),
            utf8(b"level"),
        ];

        let values = vector[
            utf8(b"Whitehare2023 MyHero #{tokenId}"),
            utf8(b"https://aquamarine-cheerful-giraffe-141.mypinata.cloud/ipfs/QmfCPNvgraRie4WuW6t92hzH8TcAiD2CYEhCNWvbBTHjSb"),
            utf8(b"{hp}"),
            utf8(b"{mp}"),
            utf8(b"{xp}"),
            utf8(b"{level}"),
        ];

        let publisher = package::claim(witness,ctx);
        let display = display::new_with_fields<MyHero>(&publisher, keys, values, ctx);
        display::update_version(&mut display);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));

        transfer::share_object(State{
            id: object::new(ctx),
            count: 0
        });
    
    }
    // clock: 0x6
    entry public fun mint( state:&mut State,clock: &Clock, ctx: &mut TxContext){
        let sender = tx_context::sender(ctx);
        state.count = state.count + 1;
        let nft = MyHero {
            id: object::new(ctx),
            tokenId: state.count,
            hp: 100,
            mp: 10,
            xp: 0,
            level: 1,
            createTime: clock::timestamp_ms(clock)/1000,
        };
        transfer::transfer(nft, sender);
    }

    public entry fun update_hero(hero: &mut MyHero, _ : &mut TxContext) {
        hero.xp = hero.xp + 1;
        if( hero.xp >= hero.level * 10 ){
            hero.level = hero.level + 1;
        }
    }

}