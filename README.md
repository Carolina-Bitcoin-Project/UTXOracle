# UTXOracle.rb
Ruby implementation of https://utxo.live/oracle/

This is a work in progress; `0.0.1` will be coming soon.

All credit goes to @SteveSimple & @DanielLHinton who discovered and built the first offline bitcoin price oracle: https://utxo.live.


```
oracle = Oracle.new('username', 'password', '127.0.0.1', '8332', logs = true)
oracle.price('2021-10-01')
$27,364
```
