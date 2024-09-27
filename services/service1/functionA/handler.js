"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.main = exports.config = void 0;
// 'use strict';
// const uuid = require('uuid');
const uuid_1 = require("uuid");
const axios_1 = __importDefault(require("axios"));
const servicio_1 = require("./services/servicio");
exports.config = {
    method: 'POST', // Define el método HTTP que esta función admite
};
const main = (event) => __awaiter(void 0, void 0, void 0, function* () {
    const _uuid = (0, uuid_1.v4)();
    const name = (0, servicio_1.getName)();
    console.log(`Resultado del name: ${name}`);
    console.log(`Request ID: ${_uuid}`);
    const response = yield axios_1.default.get('https://jsonplaceholder.typicode.com/todos/1');
    const data = response.data;
    console.log(`Response from external API: ${JSON.stringify(data)}`);
    const ENVIRONMENT = process.env.ENVIRONMENT;
    const USUARIO_BD = process.env.USUARIO_BD;
    console.log(`ENVIRONMENT: ${ENVIRONMENT}`);
    console.log(`USUARIO_BD: ${USUARIO_BD}`);
    return {
        statusCode: 200,
        body: JSON.stringify({ message: `holaa from function Aaaaaaaa....!`, env: ENVIRONMENT }),
    };
});
exports.main = main;
