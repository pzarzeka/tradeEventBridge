# Trade Event Bridge for MT5

## Installation

### 1. Open MetaTrader 5 Data Folder

In MetaTrader 5:

```text
File -> Open Data Folder
```

Navigate to:

```text
MQL5/Experts/
```

### 2. Copy the Expert Advisor

Copy `TradeEventBridge.mq5` into the `Experts` directory.

Example:

```text
MQL5/
└── Experts/
    └── TradeEventBridge.mq5
```

### 3. Compile the Expert Advisor

1. Open MetaEditor:

   ```text
   Tools -> MetaQuotes Language Editor
   ```

   or press:

   ```text
   F4
   ```

2. Open:

   ```text
   TradeEventBridge.mq5
   ```

3. Compile the file by pressing:

   ```text
   F7
   ```

4. Verify that compilation completed successfully:

   ```text
   0 errors
   ```

This will create:

```text
TradeEventBridge.ex5
```

### 4. Configure WebRequest

Open:

```text
Tools -> Options -> Expert Advisors
```

Enable:

```text
☑ Allow WebRequest for listed URL
```

Add your API host to the whitelist.

Example:

```text
https://api.example.com
```

For local development:

```text
http://127.0.0.1
```

### 5. Enable Algorithmic Trading

Open:

```text
Tools -> Options -> Expert Advisors
```

Enable:

```text
☑ Allow algorithmic trading
```

Also ensure the **Algo Trading** button in the MT5 toolbar is enabled.

### 6. Attach the Expert Advisor

1. Open any chart.

2. In the Navigator panel select:

   ```text
   Expert Advisors -> TradeEventBridge
   ```

3. Drag the EA onto the chart.

4. Enable:

   ```text
   ☑ Allow Algo Trading
   ```

### 7. Configure Parameters

Set the required values:

```text
API URL
API Key
```

### 8. Verify Installation

Open:

```text
Toolbox -> Experts
```

Check for initialization messages and verify that trade events are being sent to your API.

Expert Advisor for MetaTrader 5 that sends trade events to a remote API endpoint.

## Events

The EA sends information about:

* Position opened
* Position closed
* Position modified

## Requirements

* MetaTrader 5
* Internet connection
* Access to the configured API endpoint

### No events received

Check:

* Algo Trading is enabled
* API URL is correct
* Internet connection is available
* MT5 Experts tab for error messages
