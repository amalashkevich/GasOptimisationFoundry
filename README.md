# GAS OPTIMSATION 

- Your task is to edit and optimise the Gas.sol contract. 
- You cannot edit the tests & 
- All the tests must pass.
- You can change the functionality of the contract as long as the tests pass. 
- Try to get the gas usage as low as possible. 



## To run tests & gas report with verbatim trace 
Run: `forge test --gas-report -vvvv`

## To run tests & gas report
Run: `forge test --gas-report`

## To run a specific test
RUN:`forge test --match-test {TESTNAME} -vvvv`
EG: `forge test --match-test test_onlyOwner -vvvv`


| src/Gas.sol:GasContract contract |                 |        |        |        |         |
|----------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                  | Deployment Size |        |        |        |         |
| 2790345                          | 12630           |        |        |        |         |
| Function Name                    | min             | avg    | median | max    | # calls |
| addToWhitelist                   | 35241           | 66709  | 85321  | 85321  | 8       |
| administrators                   | 2547            | 2547   | 2547   | 2547   | 5       |
| balanceOf                        | 660             | 2160   | 2660   | 2660   | 8       |
| balances                         | 598             | 1098   | 598    | 2598   | 4       |
| checkForAdmin                    | 12027           | 12027  | 12027  | 12027  | 1       |
| getPaymentStatus                 | 807             | 807    | 807    | 807    | 1       |
| transfer                         | 193637          | 212297 | 218470 | 218614 | 4       |
| whiteTransfer                    | 105417          | 105421 | 105417 | 105429 | 3       |
| whitelist                        | 642             | 642    | 642    | 642    | 2       |
