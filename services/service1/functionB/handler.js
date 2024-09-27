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
Object.defineProperty(exports, "__esModule", { value: true });
exports.main = exports.config = void 0;
exports.config = {
    method: 'GET', // Define el método HTTP que esta función admite
};
const main = (event) => __awaiter(void 0, void 0, void 0, function* () {
    console.log('init...');
    const ENVIROMENT = process.env.ENVIROMENT;
    // const region = process.env.AWS_REGION;
    const USUARIO_BD = process.env.USUARIO_BD;
    console.log(`ENVIROMENT: ${ENVIROMENT} - USUARIO_BD: ${USUARIO_BD}`);
    return {
        statusCode: 200,
        body: JSON.stringify({ message: `holaa from function B!`, env: ENVIROMENT }),
    };
});
exports.main = main;
