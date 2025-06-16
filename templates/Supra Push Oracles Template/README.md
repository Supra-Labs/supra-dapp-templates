# Supra Oracle Example - Push Data Feeds on Supra L1 Move

A comprehensive example demonstrating how to integrate Supra's push oracle data feeds in Move smart contracts on Supra L1.

## Features
This example demonstrates:

- **Price Strategy Tracking**: Track high/low prices over time for any trading pair
- **Real-time Oracle Integration**: Get live price data from Supra's oracle network
- **Multiple Pair Operations**: Batch operations and aggregate calculations
- **Derived Pairs**: Create custom price pairs using multiplication/division
- **Event Emission**: Track price updates and derived pair calculations
- **View Functions**: Query oracle data without gas costs
- **Batch Operations**: Efficient multi-pair updates

## Oracle Configuration

**Supra Testnet Details:**
- **Package ID**: `0x5615001f63d3223f194498787647bb6f8d37b8d1e6773c00dcdd894079e56190`
- **Update Frequency**: 3 seconds
- **Deviation Threshold**: 10%
- **RPC URL**: `https://rpc-testnet.supra.com`


## Usage Examples

### Basic Price Tracking

```bash
# Set up price tracking for BTC/USD (pair ID 1)
supra move tool run \
    --function-id "0xYOUR_ADDRESS::oracle_example::set_high_low" \
    --args u32:1 \
    --rpc-url https://rpc-testnet.supra.com

# Check the price strategy
supra move tool view \
    --function-id "0xYOUR_ADDRESS::oracle_example::check_price_strategy" \
    --args u32:1 \
    --rpc-url https://rpc-testnet.supra.com
```

### Multiple Pair Operations

```bash
# Get sum of BTC and ETH prices
supra move tool view \
    --function-id "0xYOUR_ADDRESS::oracle_example::get_pair_price_sum" \
    --args "vector<u32>:[1,2]" \
    --rpc-url https://rpc-testnet.supra.com

# Batch update multiple pairs
supra move tool run \
    --function-id "0xYOUR_ADDRESS::oracle_example::set_high_low_batch" \
    --args "vector<u32>:[1,2,18]" \
    --rpc-url https://rpc-testnet.supra.com
```

### Derived Pairs

```bash
# Calculate BTC/USD * ETH/USD (multiplication)
supra move tool run \
    --function-id "0xYOUR_ADDRESS::oracle_example::get_derived_pair_price" \
    --args u32:1 u32:2 u8:0 \
    --rpc-url https://rpc-testnet.supra.com

# Calculate BTC/USD / ETH/USD (division) 
supra move tool run \
    --function-id "0xYOUR_ADDRESS::oracle_example::get_derived_pair_price" \
    --args u32:1 u32:2 u8:1 \
    --rpc-url https://rpc-testnet.supra.com
```

## Common Pair IDs

- **BTC/USD**: 1
- **ETH/USD**: 2  
- **SUPRA/USD**: 18
- **SOL/USD**: 6
- **AVAX/USD**: 7

## Monitoring

### SupraScan Explorer

Monitor your contract on [SupraScan](https://suprascan.io/):
- View transaction history
- Monitor events
- Check contract state

### Event Monitoring

Events are emitted for:
- Price strategy updates
- Derived pair calculations
- New highs/lows detected