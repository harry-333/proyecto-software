var express = require('express');
var router = express.Router();
const bcrypt = require('bcrypt');

var usuarioModel = require('../modelo/usuarioModelo');

module.exports = function () {
    router.get("/", function (req, res) {
        usuarioModel.getUsuarios(function (error, data) {
            res.status(200).json(data);
        });
    });

    //---------------------------------------------------------------
    //Muestra el método CRUL read(leer), que muestra el cliente solicitado
    router.get("/:id", function (req, res) {
        var id = req.params.id;

        //solo actualizamos si la id es un número
        if (!isNaN(id)) {
            usuarioModel.getUsuario(id, function (error, data) {
                //si el cliente existe lo mostramos en formato json
                if (typeof data !== 'undefined' && data.length > 0) {
                    res.status(200).json(data);
                }
                //en otro caso mostramos una respuesta conforme no existe
                else {
                    res.json(404,
                        {
                            "msg": "Registro no Existe"
                        });
                }
            });
        }
        else //si hay algún error
        {
            res.status(500).json({ "msg": "No es un número" });
        }
    });

    //---------------------------------------------------------------
    //Muestra y captura los datos del método CRUL crear, usando el verbo post
    router.post("/", function (req, res) {
        //creamos un objeto Json con los datos del cliente
        var usuarioData =
        {
            id: null,
            nombre: req.body.nombre,
            apellido: req.body.apellido,
            correo: req.body.correo,
            contrasena: req.body.contrasena,
            telefono: req.body.telefono,
            descripcion: req.body.descripcion,
            documento: req.body.documento,
            tipo_documento: req.body.tipo_documento,
            id_rol: req.body.id_rol,
        };


        // Encriptamos la contraseña antes de almacenarla en la base de datos
        bcrypt.hash(req.body.contrasena, 10, function (err, hash) {
            if (err) {
                res.status(500).send({ error: "Error al encriptar la contraseña" });
            } else {
                usuarioData.contrasena = hash; // Almacenamos la contraseña encriptada
                // Usamos la función para insertar
                usuarioModel.insertUsuario(usuarioData, function (error, data) {
                    // Se muestra el mensaje correspondiente
                    if (data) {
                        res.status(200).json(data);
                    } else {
                        res.status(500).send({ error: "Error al insertar el usuario" });
                    }
                });
            }
        });
    });

    //---------------------------------------------------------------
    //Muestra y captura los datos para el método CRUL update (actualizar), usando el verbo put
    router.put("/:id", function (req, res) {
        //almacenamos los datos de la petición en un objeto

        var userId = req.params.id;

        var usuarioData =
        {
            id: userId,
            nombre: req.body.nombre,
            apellido: req.body.apellido,
            correo: req.body.correo,
            telefono: req.body.telefono,
            descripcion: req.body.descripcion,
            documento: req.body.documento,
            tipo_documento: req.body.tipo_documento,
            id_rol: req.body.id_rol,
        };


        //usamos la funcion para actualizar
        usuarioModel.updateUsuario(usuarioData, function (error, data) {
            //se muestra el mensaje correspondiente
            if (data && data.msg) {
                res.status(200).json(data);
            }
            else {
                res.status(500).send(
                    {
                        error: "boo:("
                    });
            }
        });
    });


    return router;
}
