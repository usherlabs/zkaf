import replace from 'replace-in-file';

const options = {
  files: 'output/*.sol',
  from: /import \"..\/../g,
  to: `import "@nilfoundation/evm-placeholder-verification/contracts`,
};

(async () => {
  try {
    const results = await replace(options)
    console.log('Replacement results:', results);
  }
  catch (error) {
    console.error('Error occurred:', error);
  }
})()