module your_address::autofinal {
    use supra_framework::coin;
    use supra_framework::supra_coin::SupraCoin;
    use supra_framework::event;
    use supra_framework::timestamp;
    use std::signer;
    use std::error;

    /// Module state - similar to Counter in your example
    struct TopUpManager has key {
        total_topups: u64,
        last_topup_time: u64,
        threshold: u64,
        topup_amount: u64,
        initialized: bool,
    }

    /// Error codes
    const E_NOT_INITIALIZED: u64 = 1;
    const E_ALREADY_INITIALIZED: u64 = 2;
    const E_INSUFFICIENT_BALANCE: u64 = 3;

    /// Event emitted when a top-up occurs
    #[event]
    struct AutoTopUpEvent has drop, store {
        deployer: address,
        target: address,
        amount: u64,
        target_balance_before: u64,
        target_balance_after: u64,
        execution_count: u64,
        timestamp: u64,
    }

    /// Event emitted every time automation runs (even if no transfer)
    #[event]
    struct AutomationExecutedEvent has drop, store {
        deployer: address,
        target: address,
        action_taken: vector<u8>,
        target_balance: u64,
        execution_count: u64,
        timestamp: u64,
    }

    /// Initialize module state when deployed - similar to your Counter example
    fun init_module(account: &signer) {
        let account_addr = signer::address_of(account);
        
        // Ensure not already initialized
        assert!(!exists<TopUpManager>(account_addr), error::already_exists(E_ALREADY_INITIALIZED));
        
        let current_time = timestamp::now_seconds();
        
        // Create the TopUpManager resource
        move_to(account, TopUpManager {
            total_topups: 0,
            last_topup_time: current_time,
            threshold: 600_000_000, // 600 SUPRA
            topup_amount: 50_000_000, // 50 SUPRA
            initialized: true,
        });
    }

    /// Main automation function that requires initialized state
    public entry fun auto_topup_with_state(
        deployer: &signer,
        target: address,
    ) acquires TopUpManager {
        let deployer_address = signer::address_of(deployer);
        let current_time = timestamp::now_seconds();
        
        // Ensure module is initialized (similar to Counter check)
        assert!(exists<TopUpManager>(deployer_address), error::not_found(E_NOT_INITIALIZED));
        
        let manager = borrow_global_mut<TopUpManager>(deployer_address);
        
        // Always emit execution event for tracking
        event::emit(AutomationExecutedEvent {
            deployer: deployer_address,
            target,
            action_taken: b"automation_started",
            target_balance: if (coin::is_account_registered<SupraCoin>(target)) coin::balance<SupraCoin>(target) else 0,
            execution_count: manager.total_topups,
            timestamp: current_time,
        });
        
        // Skip if target is not registered for SupraCoin
        if (!coin::is_account_registered<SupraCoin>(target)) {
            event::emit(AutomationExecutedEvent {
                deployer: deployer_address,
                target,
                action_taken: b"target_not_registered",
                target_balance: 0,
                execution_count: manager.total_topups,
                timestamp: current_time,
            });
            return
        };
        
        let target_balance = coin::balance<SupraCoin>(target);
        
        // Check if top-up needed
        if (target_balance < manager.threshold) {
            let deployer_balance = coin::balance<SupraCoin>(deployer_address);
            
            if (deployer_balance >= manager.topup_amount) {
                // Perform the transfer
                coin::transfer<SupraCoin>(deployer, target, manager.topup_amount);
                
                // Update state
                manager.total_topups = manager.total_topups + 1;
                manager.last_topup_time = current_time;
                
                let target_balance_after = coin::balance<SupraCoin>(target);
                
                // Emit top-up event
                event::emit(AutoTopUpEvent {
                    deployer: deployer_address,
                    target,
                    amount: manager.topup_amount,
                    target_balance_before: target_balance,
                    target_balance_after,
                    execution_count: manager.total_topups,
                    timestamp: current_time,
                });
                
                event::emit(AutomationExecutedEvent {
                    deployer: deployer_address,
                    target,
                    action_taken: b"topup_executed",
                    target_balance: target_balance_after,
                    execution_count: manager.total_topups,
                    timestamp: current_time,
                });
            } else {
                event::emit(AutomationExecutedEvent {
                    deployer: deployer_address,
                    target,
                    action_taken: b"insufficient_deployer_balance",
                    target_balance,
                    execution_count: manager.total_topups,
                    timestamp: current_time,
                });
            }
        } else {
            event::emit(AutomationExecutedEvent {
                deployer: deployer_address,
                target,
                action_taken: b"no_topup_needed",
                target_balance,
                execution_count: manager.total_topups,
                timestamp: current_time,
            });
        }
    }

    /// View functions to check state (similar to your Counter example)
    #[view]
    public fun get_topup_stats(deployer: address): (u64, u64, u64, u64) acquires TopUpManager {
        if (!exists<TopUpManager>(deployer)) {
            return (0, 0, 0, 0)
        };
        let manager = borrow_global<TopUpManager>(deployer);
        (manager.total_topups, manager.last_topup_time, manager.threshold / 1_000_000, manager.topup_amount / 1_000_000)
    }

    #[view]
    public fun is_initialized(deployer: address): bool {
        exists<TopUpManager>(deployer)
    }

    #[view]
    public fun will_topup_trigger(deployer: address, target: address): bool acquires TopUpManager {
        if (!exists<TopUpManager>(deployer) || !coin::is_account_registered<SupraCoin>(target)) {
            return false
        };
        let manager = borrow_global<TopUpManager>(deployer);
        let target_balance = coin::balance<SupraCoin>(target);
        target_balance < manager.threshold
    }

    /// Manual function for testing (similar to your manual_increment)
    public entry fun manual_topup_test(
        deployer: &signer,
        target: address,
    ) acquires TopUpManager {
        auto_topup_with_state(deployer, target);
    }
}
