module supra_addr::oracle_example {
    use std::signer;
    use std::vector;
    use aptos_std::table::{Self, Table};
    use supra_framework::account;
    use supra_framework::event::{Self, EventHandle};
    use supra_oracle::supra_oracle_storage::{Self, Price};

    struct PriceConfiguration has key {
        feeds: Table<u32, PriceStrategy>,
    }
    struct PriceStrategy has store, copy, drop {
        high: u128,
        low: u128,
        start_time: u64,
        end_time: u64,
    }

    struct DerivedPair has drop, store {
        pair_id1: u32,
        pair_id2: u32,
        operation: u8,
        value: u128,
        decimal: u16,
        round_difference: u64,
        round_compare: u8,
    }
    struct EmitDerivePair has key {
        derived_pair: EventHandle<DerivedPair>,
    }
    fun init_module(owner: &signer) {
        move_to(owner, PriceConfiguration { 
            feeds: table::new<u32, PriceStrategy>() 
        });
        
        move_to(owner, EmitDerivePair { 
            derived_pair: account::new_event_handle<DerivedPair>(owner) 
        });
    }
    public entry fun set_high_low(supra_pair_id: u32) acquires PriceConfiguration {
        assert!(supra_oracle_storage::does_pair_exist(supra_pair_id), 0);
        let (current_price, _, _, current_round) = supra_oracle_storage::get_price(supra_pair_id);
        let price_configuration = borrow_global_mut<PriceConfiguration>(@supra_addr);
        let price_strategy = table::borrow_mut_with_default(
            &mut price_configuration.feeds,
            supra_pair_id,
            PriceStrategy { high: 0, low: 0, start_time: 0, end_time: 0 }
        );

        if ((price_strategy.high + price_strategy.low) == 0) {
            price_strategy.high = current_price;
            price_strategy.low = current_price;
            price_strategy.start_time = current_round;
            price_strategy.end_time = current_round;
        } else {
            if (current_price > price_strategy.high) {
                price_strategy.high = current_price;
            } else if (current_price < price_strategy.low) {
                price_strategy.low = current_price;
            };
            price_strategy.end_time = current_round;
        }
    }
    public entry fun set_high_low_batch(pair_ids: vector<u32>) acquires PriceConfiguration {
        let i = 0;
        let len = vector::length(&pair_ids);
        while (i < len) {
            let pair_id = *vector::borrow(&pair_ids, i);
            set_high_low(pair_id);
            i = i + 1;
        };
    }
    public entry fun get_derived_pair_price(
        pair_id1: u32,
        pair_id2: u32,
        operation: u8
    ) acquires EmitDerivePair {
        let (value, decimal, round_difference, round_compare) = 
            supra_oracle_storage::get_derived_price(pair_id1, pair_id2, operation);
        
        let event_handler = borrow_global_mut<EmitDerivePair>(@supra_addr);
        let derived_pair = DerivedPair { 
            pair_id1, 
            pair_id2, 
            operation, 
            value, 
            decimal, 
            round_difference, 
            round_compare 
        };
        event::emit_event<DerivedPair>(&mut event_handler.derived_pair, derived_pair);
    }
    #[view]
    public fun check_price_strategy(supra_pair_id: u32): PriceStrategy acquires PriceConfiguration {
        *table::borrow(&borrow_global<PriceConfiguration>(@supra_addr).feeds, supra_pair_id)
    }

    #[view]
    public fun get_current_price(supra_pair_id: u32): (u128, u16, u64, u64) {
        supra_oracle_storage::get_price(supra_pair_id)
    }

    #[view]
    public fun get_pair_price_sum(pairs: vector<u32>): u256 {
        let prices: vector<Price> = supra_oracle_storage::get_prices(pairs);
        let sum: u256 = 0;
        
        vector::for_each_reverse(prices, |price| {
            let (_, value, _, _, _) = supra_oracle_storage::extract_price(&price);
            sum = sum + (value as u256);
        });
        
        sum
    }

    #[view]
    public fun get_pair_price_average(pairs: vector<u32>): u256 {
        let sum = get_pair_price_sum(pairs);
        let count = vector::length(&pairs);
        if (count == 0) return 0;
        sum / (count as u256)
    }

    #[view]
    public fun get_multiple_prices(pairs: vector<u32>): vector<u128> {
        let prices: vector<Price> = supra_oracle_storage::get_prices(pairs);
        let result: vector<u128> = vector::empty();
        
        vector::for_each(prices, |price| {
            let (_, value, _, _, _) = supra_oracle_storage::extract_price(&price);
            vector::push_back(&mut result, value);
        });
        
        result
    }

    #[view]
    public fun view_derived_price(pair_id1: u32, pair_id2: u32, operation: u8): (u128, u16, u64, u8) {
        supra_oracle_storage::get_derived_price(pair_id1, pair_id2, operation)
    }

    #[view]
    public fun get_price_range(supra_pair_id: u32): u128 acquires PriceConfiguration {
        let strategy = check_price_strategy(supra_pair_id);
        strategy.high - strategy.low
    }

    #[view]
    public fun has_price_strategy(supra_pair_id: u32): bool acquires PriceConfiguration {
        let price_configuration = borrow_global<PriceConfiguration>(@supra_addr);
        table::contains(&price_configuration.feeds, supra_pair_id)
    }
}