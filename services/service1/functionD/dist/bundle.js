"use strict";var v=exports&&exports.__awaiter||function(u,i,t,e){function a(o){return o instanceof t?o:new t(function(c){c(o)})}return new(t||(t=Promise))(function(o,c){function d(n){try{s(e.next(n))}catch(f){c(f)}}function r(n){try{s(e.throw(n))}catch(f){c(f)}}function s(n){n.done?o(n.value):a(n.value).then(d,r)}s((e=e.apply(u,i||[])).next())})};Object.defineProperty(exports,"__esModule",{value:!0});exports.main=exports.config=void 0;exports.config={method:"GET"};var l=u=>v(void 0,void 0,void 0,function*(){console.log("init...");let i=process.env.ENVIROMENT,t=process.env.USUARIO_BD;return console.log(`ENVIROMENT: ${i} - USUARIO_BD: ${t}`),{statusCode:200,body:JSON.stringify({message:"holaa from function D!",env:i})}});exports.main=l;
//# sourceMappingURL=bundle.js.map
