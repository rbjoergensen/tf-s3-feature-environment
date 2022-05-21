"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = void 0;
const getEnv = (request) => {
    const { host } = request.headers;
    if (!host) {
        throw new Error('Could not get host header');
    }
    const hostValue = host[0].value;
    if (!hostValue) {
        throw new Error('Host header does not contain any hosts');
    }
    const [env, ...domain] = hostValue.split('.');
    return [env, domain.join('.')];
};
const handler = (event, context, callback) => {
    const { request } = event.Records[0].cf;
    const [env, domain] = getEnv(request);
    if (request.uri.indexOf('.') < 1) {
        request.uri = '/index.html';
    }
    request.headers.host[0].value = domain;
    request.uri = `/${env}${request.uri}`;
    callback(undefined, request);
};
exports.handler = handler;