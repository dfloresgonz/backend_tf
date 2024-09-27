import express from 'express';
import {glob} from 'glob';
import path from 'path';
import fs from 'fs';

// Definición de la interfaz para el handler
interface LambdaHandler {
  config: {
    method: string;
  };
  main: (event: any) => Promise<any>;
}

function loadTfvars(filePath: string) {
  const content = fs.readFileSync(filePath, 'utf-8');
  
  content.split('\n').forEach(line => {
      const trimmedLine = line.trim();
      if (trimmedLine && !trimmedLine.startsWith('#')) { // Ignorar líneas vacías y comentarios
          const [key, value] = trimmedLine.split('=').map(part => part.trim());
          process.env[key] = value.replace(/['"]/g, '');
      }
  });
}

loadTfvars('./infrastructure/terraform.tfvars');

const app = express();

// Middleware para parsear JSON
app.use(express.json());

// Función para transformar una solicitud HTTP en un evento Lambda
function createLambdaEvent(req: express.Request) {
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
  const functionFiles = glob.sync('./services/**/handler.ts'); // Busca todos los handler.ts en las funciones
  functionFiles.forEach((file) => {
    // Cambia require por import
    import(path.resolve(file)).then((handler: LambdaHandler) => {
      const method = handler.config.method.toLowerCase();

      console.log(`Cargando handler: ${file} - Método: ${method}`);
      // Obtener la ruta relativa al archivo handler (ej: /service1/functionA)
      const routePath = file
        .replace('services/', '') // Remover la parte inicial del path
        .replace('/handler.ts', ''); // Remover el handler.ts del final

      console.log(`Ruta encontrada: /${routePath}`);
      // Registrar una ruta para cada handler en Express
      (app as any)[method]( `/${routePath}`, async (req: express.Request, res: express.Response) => {
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
    }).catch(error => {
      console.error(`Error cargando handler: ${file}`, error);
    });
  });
}

// Cargar todas las rutas dinámicamente
loadHandlers();

// Levantar el servidor en local
const port = 3000;
app.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});