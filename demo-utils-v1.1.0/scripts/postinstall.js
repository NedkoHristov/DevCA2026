// SIMULATION ONLY. This script reads nothing, sends nothing, writes nothing.
// It prints what a real payload would have touched, so the CI log shows the moment.
const red = (s) => `\x1b[1;31m${s}\x1b[0m`;
const looked = ['~/.npmrc', '~/.aws/credentials', '~/.ssh/', '.env', 'GITHUB_TOKEN', 'NPM_TOKEN'];
const bar = '#'.repeat(60);
console.log(red(bar));
console.log(red('#  SIMULATED SUPPLY-CHAIN PAYLOAD - demo-utils 1.1.0'));
console.log(red(bar));
console.log(red('A real payload would now read:'));
looked.forEach((p) => console.log(red(`  -> ${p}`)));
console.log(red('...and POST it to a host nobody allowlisted.'));
console.log(red('This demo did none of that. The job will still be green.'));
