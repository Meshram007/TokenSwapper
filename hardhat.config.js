require("@nomiclabs/hardhat-waffle");
require('hardhat-contract-sizer');

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "localhost",
  networks: {
    // hardhat: {
    //   gas: 7000000,
    //   gasPrice: 1000000000000,
    //   chainId: 31337,
    //   forking: {
    //     url: "https://eth-mainnet.alchemyapi.io/v2/7R18Ic1nTlgkd1-OJ2d5RCZdNxVli_nh",
    //     blockNumber: 13574347,
    //     //accounts: [process.env['MAINNET_PRIV_KEY']],
    //     live: false,
    //     saveDeployments: true,
    //   }
    // },
    localhost: {
      chainId: 31337,
      //url: 'http://localhost:8545',
      live: false,
      saveDeployments: true, // Issue is here
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/7R18Ic1nTlgkd1-OJ2d5RCZdNxVli_nh",
        blockNumber: 13574347
      },
      timeout: 200000
    },
    ropsten: {
      url: "https://ropsten.infura.io/v3/ac9ba8f06f474f439aa6408727aeacfa",
      accounts: ["87a5512dcf8aa3b028e9de5219e86c48b3cfa49628d0eb2bec20c41ee581e7cc"]
    }
  },
  //compilers:
  solidity: {
    compilers: [
      {
        version: "0.5.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  
};
