# StopLoss and TakeProfit Manager EA

## Overview
This Expert Advisor (EA) automatically manages stop loss and take profit levels for all open orders on the current symbol. Additionally, it includes functionality to move orders to break-even once they reach a specified profit level.

## Features
- Sets stop loss for orders that don't have one
- Sets take profit for orders that don't have one
- Automatically moves orders to break-even (plus a small profit) when they reach a specified level of profit
- Visual display of current settings on the chart
- Works with both buy and sell orders

## Input Parameters
| Parameter | Default | Description |
|-----------|---------|-------------|
| Stoploss | 100 | Stop loss in points. If set to 0, stop loss will not be applied. |
| Takeprofit | 50 | Take profit in points. If set to 0, take profit will not be applied. |
| NoLoss | 10 | Points of profit required to move position to break-even. If set to 0, break-even feature is disabled. |
| MinProfitNoLoss | 1 | Minimum profit in points to secure when moving to break-even. |

## How It Works

### Initialization
When the EA starts, it displays the current settings on the chart:
- Stop loss value
- Take profit value
- Break-even settings (threshold and minimum profit)

### Order Management
For each open order on the current symbol, the EA:

1. **For BUY orders:**
   - If stop loss is not set and the Stoploss parameter is enabled, sets stop loss at `OpenPrice - Stoploss * Point`
   - If take profit is not set and the Takeprofit parameter is enabled, sets take profit at `OpenPrice + Takeprofit * Point`
   - If NoLoss is enabled and the current price has moved favorably by at least NoLoss points, moves the stop loss to `OpenPrice + MinProfitNoLoss * Point`

2. **For SELL orders:**
   - If stop loss is not set and the Stoploss parameter is enabled, sets stop loss at `OpenPrice + Stoploss * Point`
   - If take profit is not set and the Takeprofit parameter is enabled, sets take profit at `OpenPrice - Takeprofit * Point`
   - If NoLoss is enabled and the current price has moved favorably by at least NoLoss points, moves the stop loss to `OpenPrice - MinProfitNoLoss * Point`

### Safety Features
- The EA checks the broker's stop level (minimum distance for setting stop loss and take profit) and only applies changes if they meet this requirement
- Error handling is implemented for failed order modifications
- The EA only processes orders on the current chart symbol

## Installation
1. Copy the .mq4 file to your MetaTrader 4 `Experts` folder
2. Restart MetaTrader 4 or refresh the Navigator panel
3. Drag the EA onto a chart of the currency pair you want to trade
4. Adjust the input parameters as needed
5. Ensure that "Allow live trading" is enabled in the EA settings

## Recommendations for Use
- Adjust the Stoploss and Takeprofit parameters based on the volatility of the currency pair
- The NoLoss parameter should be set according to your risk management strategy
- Test the EA in a demo account before using it with real funds
- Keep in mind that this EA only manages existing orders; it does not open new positions

## Dependencies
- No external dependencies or libraries required

## Limitations
- The EA only works with orders on the current chart symbol
- All distance parameters are in points (not pips)
- If broker restrictions prevent setting a stop loss or take profit at the specified level, the modification will fail

## Version History
- 1.0 (2014): Initial release by Khlystov Vladimir

## License
Copyright © 2014, Khlystov Vladimir. All rights reserved.

## Contact
For questions or support: cmillion@narod.ru
