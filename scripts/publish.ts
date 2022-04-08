import fs from "fs";
import chalk from "chalk";
import hh from "hardhat";

const publishDir = process.env.PUBLISH_DIRECTORY || "";

const publishContract = (contractName: string) => {
  console.log(
    "Publishing",
    chalk.cyan(contractName),
    "to",
    chalk.yellow(publishDir)
  );
  try {
    let contractString = fs
      .readFileSync(
        `${hh.config.paths.artifacts}/contracts/${contractName}.sol/${contractName}.json`
      )
      .toString();
    const address = fs
      .readFileSync(`${hh.config.paths.artifacts}/${contractName}.address`)
      .toString();
    let contract = JSON.parse(contractString);

    fs.writeFileSync(
      `${publishDir}/abis/${contractName}.ts`,
      `export default ${JSON.stringify(contract.abi, null, 2)};`
    );

    return address;
  } catch (e) {
    console.log(e);
    return null;
  }
};

const main = async () => {
  if (!fs.existsSync(publishDir)) {
    fs.mkdirSync(publishDir);
  }
  const finalContractList: { [key: string]: string } = {};
  fs.readdirSync(hh.config.paths.sources).forEach((file) => {
    if (file.indexOf(".sol") >= 0) {
      const contractName = file.replace(".sol", "");
      // Add contract to list if publishing is successful
      const publishedAddress = publishContract(contractName);
      if (publishedAddress) {
        finalContractList[contractName] = publishedAddress;
      }
    }
  });
  fs.writeFileSync(
    `${publishDir}/addresses.ts`,
    `export default ${JSON.stringify(finalContractList)};`
  );
};
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
