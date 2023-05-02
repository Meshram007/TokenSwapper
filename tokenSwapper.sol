//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

interface IUniswapV2Router02 {
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
}

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract tokenSwapper is Initializable, UUPSUpgradeable {
    address public WETH;
    IUniswapV2Router02 public uniswapRouter;
    address public owner;
    uint256 public deadline; // 5 minute deadline for the swap
    uint256 public gasLimit; // limit the gas used for the swap
    event Swapped(address indexed user, uint256 ethAmount, address indexed tokenAddress, uint256 tokenAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner of the contract can call this function");
        _;
    }

    function initialize(IUniswapV2Router02 _uniswapRouter, address _weth) public initializer {
        __ERC20Swapper_init(_uniswapRouter, _weth);
    }

    function __ERC20Swapper_init(IUniswapV2Router02 _uniswapRouter, address _weth) internal {
        __UUPSUpgradeable_init();
        uniswapRouter = _uniswapRouter;
        WETH = _weth;
        deadline = block.timestamp + 300;
        gasLimit = 300000;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function swapEtherToToken(address token, uint256 minAmount) public payable returns (uint256) {
        require(address(uniswapRouter) != address(0), "Swapping is currently disabled");
        require(msg.value > 0, "Must send ether to perform swap");
        require(minAmount > 0, "Minimum amount must be greater than zero");

        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = token;

        uint[] memory amounts = uniswapRouter.getAmountsOut(msg.value, path);
        require(amounts[1] >= minAmount, "Received less than the minimum amount of tokens");

        // (bool success, ) = owner.call{value: msg.value, gas: gasLimit}("");
        // require(success, "Failed to transfer Ether to contract owner");

        uint256 tokenAmount = uniswapRouter.swapExactETHForTokens{value: msg.value, gas: gasLimit}(minAmount, path, msg.sender, deadline)[1];
        require(tokenAmount >= minAmount, "Received less than the minimum amount of tokens");

        emit Swapped(msg.sender, msg.value, token, tokenAmount);
        return tokenAmount;
    }

    function disableSwapping() public {
        require(msg.sender == owner, "Only owner can disable swapping");
        uniswapRouter = IUniswapV2Router02(address(0)); // set router address to 0 to disable swapping
    }

    function withdraw(address token, uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw tokens");
        require(IERC20(token).balanceOf(address(this)) >= amount, "Insufficient token balance");

        IERC20(token).transfer(owner, amount);
    }

    function setGasLimit(uint256 limit) public {
        require(msg.sender == owner, "Only owner can set gas limit");
        gasLimit = limit;
    }

    function setDeadline(uint256 newDeadline) public {
        require(msg.sender == owner, "Only owner can set deadline");
        deadline = newDeadline;
    }

    function setUniswapRouter(IUniswapV2Router02 _uniswapRouter) public {
        require(msg.sender == owner, "Only owner can set Uniswap router");
        uniswapRouter = _uniswapRouter;
    }
}
