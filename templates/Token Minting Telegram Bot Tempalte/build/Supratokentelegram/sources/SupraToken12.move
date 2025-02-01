module 0x1c5acf62be507c27a7788a661b546224d806246765ff2695efece60194c6df05::SupraToken12 {  
    use supra_framework::account;
    use supra_framework::signer;
struct Token has key {
        balance: u64
    }

    public fun mint(account: &signer, amount: u64) {
        let account_address = signer::address_of(account);
        assert!(!exists<Token>(account_address), 0);
        let token = Token { balance: amount };
        move_to(account, token);
    }

public fun get_balance(account: address): u64 acquires Token { let balance = if (exists<Token>(account)) { borrow_global<Token>(account).balance } else { 0 }; balance }
}