module dice_addr::dice_roll {

    use supra_framework::event;
    use supra_addr::supra_vrf;

    use std::error;
    use std::signer;
    use std::string::{Self, String};
    use std::vector;
    use aptos_std::table::{Self, Table};

    struct DiceRequest has key, store, copy {
        user_address: address,
        dice_range: u256, // Max dice number
        rolled_number: u256,
        is_resolved: bool,
    }

    struct DiceMapper has key {
        requests: Table<u64, DiceRequest>,
    }

    #[event]
    struct DiceRollEvent has drop, store {
        user_address: address,
        request_id: u64,
        dice_range: u256,
    }

    #[event]
    struct DiceResultEvent has drop, store {
        user_address: address,
        request_id: u64,
        rolled_number: u256,
    }

    /// Error: The request does not exist.
    const ERROR_REQUEST_DOES_NOT_EXIST: u64 = 0;

    /// Initialize the module by creating a `DiceMapper` resource
    entry fun init_module(sender: &signer) {
        move_to(sender, DiceMapper { requests: table::new<u64, DiceRequest>() });
    }

    /// Request a dice roll from Supra VRF
    public entry fun roll_dice(
        sender: &signer,
        dice_range: u256 // Max dice number (e.g., 6 for a 6-sided dice)
    ) acquires DiceMapper {
        let rng_count = 1;
        let client_seed = 0; // Use 0 as default
        let callback_address = @dice_addr;
        let callback_module = string::utf8(b"dice_roll");
        let callback_function = string::utf8(b"resolve_dice_roll");
        let num_confirmations = 1;

        // Request random number generation from Supra VRF
        let request_id = supra_vrf::rng_request(
            sender,
            callback_address,
            callback_module,
            callback_function,
            rng_count,
            client_seed,
            num_confirmations
        );

        // Store the request
        let mapper = borrow_global_mut<DiceMapper>(@dice_addr);
        let user = signer::address_of(sender);
        table::add(&mut mapper.requests, request_id, DiceRequest {
            user_address: user,
            dice_range,
            rolled_number: 0,
            is_resolved: false,
        });

        // Emit an event to notify about the dice roll request
        event::emit(DiceRollEvent { user_address: user, request_id, dice_range });
    }

    /// Callback function to resolve the dice roll
    public entry fun resolve_dice_roll(
        request_id: u64,
        message: vector<u8>,
        signature: vector<u8>,
        caller_address: address,
        rng_count: u8,
        client_seed: u64
    ) acquires DiceMapper {
        // Ensure the request mapper exists
        assert!(exists<DiceMapper>(@dice_addr), error::unavailable(ERROR_REQUEST_DOES_NOT_EXIST));

        // Verify the VRF response
        let verified_vec = supra_vrf::verify_callback(
            request_id,
            message,
            signature,
            caller_address,
            rng_count,
            client_seed
        );

        // Extract the random number
        let verified_num: &u256 = vector::borrow(&verified_vec, 0);

        // Process the result
        let mapper = borrow_global_mut<DiceMapper>(@dice_addr);
        let request = table::borrow_mut(&mut mapper.requests, request_id);
        let rolled_number = *verified_num % request.dice_range + 1; // Ensure range is [1, dice_range]
        request.rolled_number = rolled_number;
        request.is_resolved = true;

        // Emit an event for the result
        event::emit(DiceResultEvent { user_address: request.user_address, request_id, rolled_number });
    }

    /// View the result of a dice roll
    #[view]
    public fun get_dice_result(request_id: u64): (bool, u256) acquires DiceMapper {
        // Ensure the request exists
        assert!(exists<DiceMapper>(@dice_addr), error::unavailable(ERROR_REQUEST_DOES_NOT_EXIST));
        let mapper = borrow_global<DiceMapper>(@dice_addr);
        let request = table::borrow(&mapper.requests, request_id);

        // Return whether resolved and the rolled number
        (request.is_resolved, request.rolled_number)
    }
}
