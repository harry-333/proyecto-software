var express = require('express');//guarda express que nosotros intalamos
var bodyParser = require('body-parser'), port = 3000;//rmanejo de cuerpo de la "pagina" y puerto
var http = require('http');//protocolo de intercambio de archivos
var path = require('path');//direccion
const cors = require('cors');

//rutas
var conectado = require('./src/conexion/index');
var tipdoc = require('./src/Rutas/tipdocruta');
var propiedad = require('./src/Rutas/propiedadruta');
var agenda = require('./src/Rutas/agendaruta');
var tipoprop = require('./src/Rutas/TipoPropRuta');
var tiponeg = require('./src/Rutas/TipoNegRuta');
const login = require('./src/Rutas/login');
const registro = require('./src/Rutas/registro');
const usuario = require('./src/Rutas/usuarioRuta');
const resetPassword = require('./src/Rutas/reset-password');

const authMiddleware = require('./src/middlewares/auth');


var app = express();//recibe un constructor

// todos los entornos
app.set('port', process.env.PORT || port);//metodo para recibir puerto y proceso
app.use(bodyParser.json({type: 'application/json', limit: '10mb'}));//recibe un cuerpo y un objeto json
app.use(bodyParser.urlencoded({extended: false}));//recibe url codificada
app.use(express.static(path.join(__dirname, 'public')));//recibe direccion

//================================================================

/*
app.use(function (req, res, next)
{

    // Stio web al que desea permitir que se conecte
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:4200');

    // A que métodos que desea dar permisos
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    // A que  encabezados se les va a dar permiso
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

    //Establezca en verdadero si necesita que el sitio web incluya cookies en las solicitudes enviadas
    //a la API (por ejemplo, en caso de que use sesiones)
    res.setHeader('Access-Control-Allow-Credentials', true);

    // Pase a la siguiente capa de middleware
    next();
});
*/

//CORS
app.use(cors());

//============================================================

//rutas para el servicio
app.use('/tipdoc', authMiddleware, tipdoc());
app.use('/propiedad', authMiddleware, propiedad());
app.use('/agenda', authMiddleware, agenda());
app.use('/tipoprop', authMiddleware, tipoprop());
app.use('/tiponeg', authMiddleware, tiponeg());
app.use('/usuario', authMiddleware, usuario());
app.use('/api', login);
app.use('/api', registro);
app.use('/api', resetPassword);

http.createServer(app).listen(app.get('port'), function ( )
{
    console.log('Servidor Express escuchando por el puerto ' + app.get('port'));
});

module.exports = app;
