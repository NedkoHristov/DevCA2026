// Tiny app. Its only job is to depend on @nedkohristov/demo-utils with a caret range,
// exactly like most real package.json files do.
const { greet, version } = require('@nedkohristov/demo-utils');
console.log(greet('Sofia Tech Park'));
console.log(`demo-utils resolved to v${version}`);
