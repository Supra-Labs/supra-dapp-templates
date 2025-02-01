// The two_by_two function will transfer the passed amount to both addresses passed as arguments.
module exampleAddress::transfer {

    use supra_framework::supra_coin;
    use supra_framework::coin;
    use std::signer;
    use std::account;
 
    // Function to transfer the specified amount to two destinations from the source signer
    public entry fun two_by_two(
        first: &signer,
        amount_first: u64,
        dst_first: address,
        dst_second: address,
    ) {
        // Transfer the specified amount to the first destination
        coin::transfer<supra_coin::SupraCoin>(first, dst_first,amount_first);
        // Transfer the same amount to the second destination
        coin::transfer<supra_coin::SupraCoin>(first,dst_second, amount_first);
    }

     // Function to view the balance of an address
    #[view]
    public fun view_balance(address: address): u64 {
        coin::balance<supra_coin::SupraCoin>(address)
    }

    #[test_only]
    use std::debug::print;
    use std::string::utf8;

    // Test function for end-to-end balance check after transfers
    #[test(supra_framework = @0x1, source = @0x123, destination1 = @0x111, destination2 = @0x222)]

    public entry fun test_end_to_end(
        supra_framework: signer,
        source: signer,
        destination1: signer,
        destination2: signer
    ) {
        // Setting up accounts for source and destinations
       let source_addr = signer::address_of(&source);
       account::create_account_for_test(source_addr); 

        let destination1_addr = signer::address_of(&destination1);
       account::create_account_for_test(destination1_addr); 

        let destination2_addr = signer::address_of(&destination2);
       account::create_account_for_test(destination2_addr); 

         // Initializing Supra Coin for test
        let (burn_cap, mint_cap) = supra_coin::initialize_for_test(&supra_framework);
        
        //Register SupraCoin coin store resource for each account
        coin::register<supra_coin::SupraCoin>(&source);
        coin::register<supra_coin::SupraCoin>(&destination1);
        coin::register<supra_coin::SupraCoin>(&destination2);
        
        // Mint some coins and deposit to source address
        let coins_minted = coin::mint<supra_coin::SupraCoin>(100, &mint_cap);
        coin::deposit(source_addr, coins_minted);

        //Dispose of burn and mint capability objects
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        //Store starting balance
        let source_balance_before : u64 = view_balance(source_addr);
        let destination1_balance_before : u64 = view_balance(destination1_addr);
        let destination2_balance_before : u64 = view_balance(destination2_addr);

        // Display initial balances
        print(&utf8(b"Source wallet balance before transfer:"));
        print(&source_balance_before);

        print(&utf8(b"Destination1 wallet balance before transfer:"));
        print(&destination1_balance_before);

        print(&utf8(b"Destination2 wallet balance before transfer:"));
        print(&destination2_balance_before);

        //Call the two_by_two function of this module to transfer 50 supra to each destination
        two_by_two(&source, 50, destination1_addr, destination2_addr);

        // Checking and displaying updated balances after transfer
        let source_balance_after : u64 = view_balance(source_addr);
        let destination1_balance_after : u64 = view_balance(destination1_addr);
        let destination2_balance_after : u64 = view_balance(destination2_addr);

        print(&utf8(b"Source wallet balance updated after transfer:"));
        print(&source_balance_after);

        print(&utf8(b"Destination1 wallet balance updated after transfer:"));
        print(&destination1_balance_after);

        print(&utf8(b"Destination2 wallet balance updated after transfer:"));
        print(&destination2_balance_after);

         // Verify final balances
        assert!(coin::balance<supra_coin::SupraCoin>(source_addr) == 0 , 0);
        assert!(coin::balance<supra_coin::SupraCoin>(destination1_addr) == 50 , 1);
        assert!(coin::balance<supra_coin::SupraCoin>(destination2_addr) == 50 , 2);
    }
}