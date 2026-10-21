// SIMULATION. Reads nothing, sends nothing.
// Writes ONE file into the project that ran `npm install`, as proof that code ran.
const fs = require('fs');
const path = require('path');

const bar = '█'.repeat(52);
const banner = [
  bar,
  '  demo-utils 1.1.0 just ran code on this machine',
  '  It could have read: ~/.npmrc  ~/.aws  ~/.ssh  .env',
  '  It read nothing. It sent nothing. This time.',
  bar,
].join('\n');

const where = process.env.INIT_CWD || process.cwd();
fs.writeFileSync(
  path.join(where, 'demo-utils-was-here.txt'),
  `${banner}\nran at ${new Date().toISOString()}\nas user ${process.env.USER || process.env.USERNAME || 'unknown'}\n`
);
console.log(`\x1b[1;31m${banner}\x1b[0m`);
