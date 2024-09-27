export const config = {
  method: 'GET', // Define el método HTTP que esta función admite
};

export const main = async (event: any) => {
  console.log('init...')
  const ENVIROMENT = process.env.ENVIROMENT;
  // const region = process.env.AWS_REGION;
  const USUARIO_BD = process.env.USUARIO_BD;
  console.log(`ENVIROMENT: ${ENVIROMENT} - USUARIO_BD: ${USUARIO_BD}`);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `holaa from function D!`, env: ENVIROMENT }),
  };
};