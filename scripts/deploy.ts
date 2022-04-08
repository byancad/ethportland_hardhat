/* eslint no-use-before-define: "warn" */
import fs from "fs";
import chalk from "chalk";
import { ethers } from "hardhat";
import { utils } from "ethers";
import R from "ramda";

const main = async () => {
  console.log("\n\n 📡 Deploying...\n");

  // const yourContract = await deploy("Greeter", ["this is my greeting"]); // <-- add in constructor args like line 16 vvvv
  // const SkaleStub = await deploy("SkaleStub", ["testing skale mint", "TEST"]);
  const SkaleStubFactory = await deploy("SkaleStubFactory", []);

  console.log(
    " 💾  Artifacts (address, abi, and args) saved to: ",
    chalk.blue("packages/hardhat/artifacts/"),
    "\n\n"
  );
};

const deploy = async (contractName: string, _args: any[]) => {
  console.log(` 🛰  Deploying: ${contractName}`);

  const contractArgs = _args || [];
  const contractArtifacts = await ethers.getContractFactory(contractName);
  const deployed = await contractArtifacts.deploy(...contractArgs);
  const encoded = abiEncodeArgs(deployed, contractArgs);
  fs.writeFileSync(`artifacts/${contractName}.address`, deployed.address);

  console.log(
    " 📄",
    chalk.cyan(contractName),
    "deployed to:",
    chalk.magenta(deployed.address)
  );

  if (!encoded || encoded.length <= 2) return deployed;
  fs.writeFileSync(`artifacts/${contractName}.args`, encoded.slice(2));

  return deployed;
};

// ------ utils -------

// abi encodes contract arguments
// useful when you want to manually verify the contracts
// for example, on Etherscan
const abiEncodeArgs = (deployed: any, contractArgs: any[]) => {
  // not writing abi encoded args if this does not pass
  if (
    !contractArgs ||
    !deployed ||
    !R.hasPath(["interface", "deploy"], deployed)
  ) {
    return "";
  }
  const encoded = utils.defaultAbiCoder.encode(
    deployed.interface.deploy.inputs,
    contractArgs
  );
  return encoded;
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
