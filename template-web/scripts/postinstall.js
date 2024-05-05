const fs = require('fs');
const path = require('path');

/**
 * Look ma, it's cp -R.
 * @param {string} src  The path to the thing to copy.
 * @param {string} dest The path to the new copy.
 */
var copyRecursiveSync = function (src, dest) {
  var exists = fs.existsSync(src);
  var stats = exists && fs.statSync(src);
  var isDirectory = exists && stats.isDirectory();
  if (isDirectory) {
    try {
      fs.mkdirSync(dest);
    } catch (e) {
      if (e.code !== 'EEXIST') throw e;
    }
    fs.readdirSync(src).forEach(function (childItemName) {
      copyRecursiveSync(
        path.join(src, childItemName),
        path.join(dest, childItemName)
      );
    });
  } else {
    fs.copyFileSync(src, dest);
  }
};

const copyDirectory = [
  ['packages/shared/public', 'packages/home/public/shared'],
  ['packages/shared/public', 'packages/webapp/public/shared'],
];

copyDirectory.forEach((entry) => {
  const [from, to] = entry;

  copyRecursiveSync(from, to);
});
