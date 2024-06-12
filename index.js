const express = require('express')
const httpProxy = require('http-proxy')
const { PrismaClient } = require('@prisma/client')
const app = express()
const PORT = 8000
const { stringify, parse } = require("uuid")

const proxy = httpProxy.createProxy()

const prisma = new PrismaClient({})

const bufferToUUID = (buffer) => {
    return stringify(Buffer.from(buffer));
};

const uuidToBuffer = (uuid) => {
    return Buffer.from(parse(uuid));
};

app.use(async (req, res) => {

    try {
        const hostname = req.hostname;
        const subdomain = hostname.split('.')[0];

        const userIdFromDB = await prisma.projectModel.findFirst({
            where: {
                sub_domain: subdomain
            }
        })

        const userId = bufferToUUID(userIdFromDB.user_id)
        const projectId = bufferToUUID(userIdFromDB.project_id)

        const deployment = await prisma.deploymentModel.findFirst({
            where: {
                project_id: userIdFromDB.project_id
            }
        })

        const deploymentId = bufferToUUID(deployment.deployment_id)

        const BASE_PATH = `https://swiftdeploy.s3.ap-south-1.amazonaws.com/${userId}/${projectId}/${deploymentId}/`

        const resolvesTo = BASE_PATH

        return proxy.web(req, res, { target: resolvesTo, changeOrigin: true })
    } catch (error) {
        console.log(error.message)
    }

})


proxy.on('proxyReq', (proxyReq, req, res) => {
    const url = req.url;
    if (url === '/')
        proxyReq.path += 'index.html'

})

app.listen(PORT, () => console.log(`Reverse Proxy Running..${PORT}`))