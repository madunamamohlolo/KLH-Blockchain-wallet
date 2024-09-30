// deploy-wallet.js

async function main() {
  const SmartWallet = await ethers.getContractFactory("SmartWallet");
  const smartWallet = await SmartWallet.deploy();
  await smartWallet.deployed();

  console.log("SmartWallet deployed to:", smartWallet.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });