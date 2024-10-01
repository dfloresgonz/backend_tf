export const config = {
  method: 'POST',
};

export const main = async (event: any) => {
  console.log('init...');
  console.log('event1:', event);
  console.log('event2:', JSON.stringify(event));

  const ENVIROMENT = process.env.ENVIROMENT;
  // const region = process.env.AWS_REGION;
  const USUARIO_BD = process.env.USUARIO_BD;
  console.log(`ENVIROMENT: ${ENVIROMENT} - USUARIO_BD: ${USUARIO_BD}`);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `holaa from function B!`, env: ENVIROMENT, test:0, new: true }),
  };
};