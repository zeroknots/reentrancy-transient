# Transient Store Foundry Template

A foundry template with custom `solc` binaries (from [transient-storage](https://github.com/ethereum/solidity/tree/transient-store)) that supports transient storage opcodes in inline assembly.
```bash
forge build --use bin/solc
forge test  --use bin/solc
```

## Example

```solidity
import { ReentrancyGuard } from "reentrancy-transient/ReentrancyGuard.sol";
contract MyContract is ReentrancyGuard {

    function criticalFunction() nonReentrant("critical") external {
        //..
    }
}
```
