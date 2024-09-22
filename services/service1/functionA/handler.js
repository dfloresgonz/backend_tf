'use strict';
const uuid = require('uuid');
const calcular = require('./services/servicio')
const axios = require('axios');

module.exports.config = {
  method: 'POST', // Define el método HTTP que esta función admite
};

module.exports.main = async (event) => {
  const _uuid = uuid.v4();
  const name = calcular.getName();
  console.log(`Resultado del name: ${name}`);
  console.log(`Request ID: ${_uuid}`);

  const response = await axios.get('https://jsonplaceholder.typicode.com/todos/1');
  const data = response.data;
  console.log(`Response from external API: ${JSON.stringify(data)}`);

  const ENVIROMENT = process.env.ENVIROMENT;
  const USUARIO_BD = process.env.USUARIO_BD;
  console.log(`ENVIROMENT: ${ENVIROMENT}`);
  console.log(`USUARIO_BD: ${USUARIO_BD}`);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `holaa from function A! - ${_uuid} - name: ${name}`, data, env: ENVIROMENT }),
  };
};