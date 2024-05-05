/* eslint-disable @typescript-eslint/no-var-requires */
const fs = require('fs');
const { buildClientSchema, printSchema } = require('graphql/utilities');

const path = require('path');

const schemaJSONPath = path.resolve(__dirname, './data/schema.json');

const schemaGraphqlPath = path.resolve(__dirname, './data/schema.graphql');

const schema = buildClientSchema(require(schemaJSONPath).data);
fs.writeFileSync(schemaGraphqlPath, printSchema(schema));

const artifactDirectory = path.resolve(__dirname, './packages/fragments/src');

fs.mkdirSync(artifactDirectory, { recursive: true });

module.exports = {
  src: '.',
  noFutureProofEnums: true,
  schema: schemaGraphqlPath,
  exclude: ['**/node_modules/**', '**/__mocks__/**', '**/fragments/src/**'],
  artifactDirectory: artifactDirectory,
  language: 'typescript',
  eagerEsModules: true,
};
