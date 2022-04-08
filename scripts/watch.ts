import watch from "node-watch";
import { exec } from "child_process";

const run = () => {
  console.log("🛠  Compiling & Deploying...");
  exec("yarn deploy:publish", (error: any, stdout: any, stderr: any) => {
    console.log(stdout);
    if (error) console.log(error);
    if (stderr) console.log(stderr);
  });
};

console.log("🔬 Watching Contracts...");
watch("./contracts", { recursive: true }, (evt: any, name: any) => {
  console.log("%s changed.", name);
  run();
});

run();
