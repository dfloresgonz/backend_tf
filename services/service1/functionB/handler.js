'use strict';

module.exports.config = {
  method: 'GET', // Define el método HTTP que esta función admite
};

module.exports.main = async (event) => {

  const ENVIRONMENT = process.env.ENVIRONMENT;
  const region = process.env.AWS_REGION;
  const USUARIO_BD = process.env.USUARIO_BD;
  console.log(`ENVIRONMENT: ${ENVIRONMENT} - region: ${region} - USUARIO_BD: ${USUARIO_BD}`);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `holaa from function B!`, env: ENVIRONMENT }),
  };
};