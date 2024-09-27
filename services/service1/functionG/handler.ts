export const config = {
  method: 'GET', // Define el método HTTP que esta función admite
};

type Event = {
  name: string;
  lastName: string;
};

export const main = async (event: any) => {
  console.log('init... con typescript');
  const persona: Event = {
    name: 'Juan',
    lastName: 'Perez',
  };
  console.log(`Hola ${persona.name} ${persona.lastName}`);
  const ENVIROMENT = process.env.ENVIROMENT;
  // const region = process.env.AWS_REGION;
  const USUARIO_BD = process.env.USUARIO_BD;
  console.log(`ENVIROMENT: ${ENVIROMENT} - USUARIO_BD: ${USUARIO_BD}`);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `holaa from function Ggggg!`, env: ENVIROMENT }),
  };
};