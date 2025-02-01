module deploy_addr::SpinTheWheel {

    use aptos_std::vector;
    use aptos_std::signer;
    use supra_framework::timestamp;

    struct Result has key {
        value: u8,
    }

    public fun initialize(account: &signer) {
        let result = Result { value: 0 };
        move_to(account, result);
    }

    public fun spin(account: &signer) {
        let outcomes = vector::empty<u8>();
        vector::push_back(&mut outcomes, 0); // Win
        vector::push_back(&mut outcomes, 1); // Lose
        vector::push_back(&mut outcomes, 2); // Try Again

        let current_time: u64 = timestamp::now_seconds();
        let random_index: u64 = current_time % 3;
        let outcome_ref = vector::borrow(&outcomes, random_index);
        let outcome = *outcome_ref;
        let result = Result { value: outcome };
        move_to(account, result);
    }
}
