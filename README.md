# TokenSwapper
The simple Solidity contract for exchanging Ether to an arbitrary ERC-20. 


# Questions and Answers
1. Are user's assets kept safe during the exchange transaction? Is the exchange rate fair and correct? Does the contract have an owner?
=> In the given ERC20Swapper contract, the user's assets are kept safe during the exchange transaction since the transaction is performed via the UniswapV2Router02 contract and the contract doesn't store any user assets.
The exchange rate is determined by the Uniswap algorithm based on the current liquidity pool and the amount of tokens and ether being swapped, so the exchange rate is considered fair and correct.
The contract does have an owner, which is set in the constructor. The owner can perform certain functions like disabling swapping, setting the gas limit, setting the deadline, withdrawing tokens, and setting the Uniswap router. It's important to note that the owner has control over the contract, so users should trust the owner before using the contract.

2. How much gas will the `swapEtherToToken` execution and the deployment take?
=> Transaction Fee: 0.00915646744421284 ETH
   Gas Price: 81.585175745 Gwei (0.000000081585175745 ETH)
   Gas Limit: 700,000

3. How can the contract be updated if e.g. the DEX it uses has a critical vulnerability and/or the liquidity gets drained? 
=> Used proxy upgradeable contract.
   Use disableSwapping() function to prevent vulnerability.

4. Is the contract usable for EOAs? Are other contracts able to interoperate with it?
=> Yes, the contract appears to be usable by externally owned accounts (EOAs) as it includes a swapEtherToToken function that allows EOAs to swap Ether for a specified ERC20 token. Other smart contracts can also interact with this contract, as long as they comply with the interface of the IUniswapV2Router02 and IERC20 contracts that the ERC20Swapper contract depends on.