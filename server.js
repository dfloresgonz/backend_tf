const express = require('express');
const glob = require('glob');
const path = require('path');
const fs = require('fs');
const hcl = require('hcl-parser');

function loadTfvars(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const parsedVars = hcl.parse(content);
  const variables = parsedVars[0];

  Object.keys(variables).forEach((key) => {
    process.env[key.toUpperCase()] = variables[key];
    console.log(`Variable de entorno cargada: ${key.toUpperCase()}=${variables[key]}`);
  });
}

loadTfvars('./infrastructure/terraform.tfvars');

const app = express();

// Middleware para parsear JSON
app.use(express.json());



// Función para transformar una solicitud HTTP en un evento Lambda
function createLambdaEvent(req) {
  return {
    httpMethod: req.method,
    headers: req.headers,
    body: JSON.stringify(req.body),
    path: req.path,
    queryStringParameters: req.query,
  };
}

// Función para cargar los handlers dinámicamente
function loadHandlers() {
  const functionFiles = glob.sync('./services/**/handler.js'); // Busca todos los handlers.js en las funciones
  functionFiles.forEach((file) => {
    const handler = require(path.resolve(file));
    const method = handler.config.method.toLowerCase();

    console.log(`Cargando handler: ${file} - Método: ${method}`);
    // Obtener la ruta relativa al archivo handler (ej: /service1/functionA)
    const routePath = file
      .replace('services/', '') // Remover la parte inicial del path
      .replace('/handler.js', '') // Remover el handler.js del final
    // .toLowerCase(); // Convertir el path a minúsculas por convención
    console.log(`Ruta encontrada: /${routePath}`);
    // Registrar una ruta para cada handler en Express
    app[method](`/${routePath}`, async (req, res) => {
      const event = createLambdaEvent(req);
      try {
        const result = await handler.main(event);
        res.status(result.statusCode).send(result.body);
      } catch (error) {
        console.error('Error en la ejecución', error);
        res.status(500).send({ message: 'Error en la ejecución', error });
      }
    });

    console.log(`Ruta registrada: ${method} /${routePath}`);
  });
}

// Cargar todas las rutas dinámicamente
loadHandlers();

// Levantar el servidor en local
const port = 3000;
app.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});
