var express = require('express');
var router = express.Router();

var clienteModel = require('../modelo/clienteModelo');

module.exports = function()
{
    router.get("/", function(req, res)
    {
        clienteModel.getClientes(function(error, data)
        {
            res.status(200).json(data);
        });
    });
    
   //---------------------------------------------------------------
    //Muestra el método CRUL read(leer), que muestra el cliente solicitado
    router.get("/:id", function (req, res)
    {
        var id = req.params.id;

        //solo actualizamos si la id es un número
        if (!isNaN(id))
        {
            clienteModel.getCliente(id, function (error, data)
            {
                //si el cliente existe lo mostramos en formato json
                if (typeof data !== 'undefined' && data.length > 0)
                {
                    res.status(200).json(data);
                }
                //en otro caso mostramos una respuesta conforme no existe
                else
                {
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
    router.post("/", function (req, res)
    {
        //creamos un objeto Json con los datos del cliente
        var clienteData =
            {
                id_cliente: null,
                nom1_cliente: req.body.nom1_cliente,
                nom2_cliente: req.body.nom2_cliente,
                ape1_cliente: req.body.ape1_cliente,
                ape2_cliente: req.body.ape2_cliente,
                id_tipodoc: req.body.id_tipodoc,
                No_doc: req.body. No_doc,
            };


        //usamos la funcion para insertar
        clienteModel.insertCliente(clienteData, function (error, data)
        {
            //se muestra el mensaje correspondiente
            if (data)
            {
                res.status(200).json(data);
            }
            else
            {
                res.status(500).send({ error: "boo:(" });
            }
        });
    });

    //---------------------------------------------------------------
    //Muestra y captura los datos para el método CRUL update (actualizar), usando el verbo put
    router.put("/:id", function (req, res)
    {
        //almacenamos los datos de la petición en un objeto
        //console.log(" 38");
        var clienteData =
            {
                id_cliente: req.body.id_cliente,
                nom1_cliente: req.body.nom1_cliente,
                nom2_cliente: req.body.nom2_cliente,
                ape1_cliente: req.body.ape1_cliente,
                ape2_cliente: req.body.ape2_cliente,
                id_tipodoc: req.body.id_tipodoc,
                No_doc: req.body. No_doc,
            };


        //usamos la funcion para actualizar
        clienteModel.updateCliente(clienteData, function (error, data)
        {
            //se muestra el mensaje correspondiente
            if (data && data.msg)
            {
                res.status(200).json(data);
            }
            else
            {
                res.status(500).send(
                { 
                    error: "boo:(" 
                });
            }
        });
    });


    return router;
}
