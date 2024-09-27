import { v4 as uuidv4 } from 'uuid';
import axios from 'axios';

import { getName } from "./services/servicio";

export const config = {
  method: 'POST',
};

export const main = async (event: any) => {
  const _uuid = uuidv4();
  const name = getName();
  console.log(`Resultado del name: ${name}`);
  console.log(`Request ID: ${_uuid}`);

  const response = await axios.get('https://jsonplaceholder.typicode.com/todos/1');
  const data = response.data;
  console.log(`Response from external API: ${JSON.stringify(data)}`);

  const ENVIRONMENT = process.env.ENVIRONMENT;
  const USUARIO_BD = process.env.USUARIO_BD;
  console.log(`ENVIRONMENT: ${ENVIRONMENT}`);
  console.log(`USUARIO_BD: ${USUARIO_BD}`);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `holaa from function Aaaaaaaa....!`, env: ENVIRONMENT, foo: 'jaja' }),
  };
};