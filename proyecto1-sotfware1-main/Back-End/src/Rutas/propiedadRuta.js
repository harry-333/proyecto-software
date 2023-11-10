var express = require('express');
var router = express.Router();

var propiedadModel = require('../modelo/propiedadModelo');

module.exports = function()
{
    router.get("/", function(req, res)
    {
        propiedadModel.getPropiedades(function(error, data)
        {
            res.status(200).json(data);
        });
    });
    
   //---------------------------------------------------------------
    //Muestra el método CRUL read(leer), que muestra la propiedad solicitada
    router.get("/:id", function (req, res)
    {
        var id = req.params.id;

        //solo actualizamos si la id es un número
        if (!isNaN(id))
        {
            propiedadModel.getPropiedad(id, function (error, data)
            {
                //si la propiedad existe lo mostramos en formato json
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

    //Obtener propiedades por el id del vendedor
    router.get("/misProps/:id", function (req, res)
    {
        var id = req.params.id;

        //solo actualizamos si la id es un número
        if (!isNaN(id))
        {
            propiedadModel.getMisPropiedades(id, function (error, data)
            {
                //si la propiedad existe lo mostramos en formato json
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
        //creamos un objeto Json con los datos de la propiedad
        var propiedadData =
            {
                id_propiedad: null,
                id_tipoNeg: req.body.id_tipoNeg,
                titulo: req.body.titulo,
                ciudad: req.body.ciudad,
                direccion: req.body.direccion,
                precio: req.body.precio,
                No_habitaciones: req.body.No_habitaciones,
                No_banos: req.body.No_banos,
                desc_prop: req.body.desc_prop,
                id_tipoProp: req.body.id_tipoProp,
                area_construida: req.body.area_construida,
                id_vendedor: req.body.id_vendedor
            };


        //usamos la funcion para insertar
        propiedadModel.insertPropiedad(propiedadData, function (error, data)
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
        var propiedadData =
            {
                id_propiedad: req.params.id,
                id_tipoNeg: req.body.id_tipoNeg,
                titulo: req.body.titulo,
                ciudad: req.body.ciudad,
                direccion: req.body.direccion,
                precio: req.body.precio,
                No_habitaciones: req.body.No_habitaciones,
                No_banos: req.body.No_banos,
                desc_prop: req.body.desc_prop,
                id_tipoProp: req.body.id_tipoProp,
                area_construida: req.body.area_construida,
            };


        //usamos la funcion para actualizar
        propiedadModel.updatePropiedad(propiedadData, function (error, data)
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
/*
var express = require('express');

var router = express.Router();

var propiedadModel = require ('../modelos/TipoDocModelo');

module.exports = function()
{
    router.get("/", function(req, res)

    {
        propiedadModel.getTipDocs(function(error, data)

        {????
            res.status(200).json(data);

        }????);

    }????);
    //---------------------------------------------------------------
    //Muestra el método CRUL read(leer), que muestra la propiedad solicitado
    router.get("/:id", function (req, res)
    {
        var id = req.params.id;

        //solo actualizamos si la id es un número
        if (!isNaN(id))
        {
            propiedadModel.getTipDoc(id, function (error, data)
            {
                //si la propiedad existe lo mostramos en formato json
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
            res.status(500).json({ "msg": "No Es Un Numero" });
        }
    });

//---------------------------------------------------------------
    //Muestra y captura los datos del método CRUL crear, usando el verbo post
    router.post("/", function (req, res)
    {
        //creamos un objeto Json con los datos dla propiedad
        var TipDocData =
            {
                id_tip_doc: null,
                tipo_documento: req.body.tipo_documento,
                iniciales_tip_doc: req.body.iniciales_tip_doc,
            };


        //usamos la funcion para insertar
        propiedadModel.insertTipDoc(TipDocData, function (error, data)
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

    return router;

}*/