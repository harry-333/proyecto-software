var connection = require('../conexion/index');

var usuarioModel = {};

//---------------------------------------------------------------
//Se obtiene toda la lista de usuarios
usuarioModel.getUsuarios = function (callback) {

    if (connection) {
        var sql = "SELECT u.id "
            + ", u.nombre "
            + ", u.apellido "
            + ", u.correo "
            + ", u.telefono "
            + ", u.descripcion "
            + ", u.documento "
            + ", u.tipo_documento "
            + ", u.id_rol "
            + ", r.descripcion AS " + "Rol"
            + " FROM usuario u INNER JOIN rol r ON u.id_rol = r.id"
            + " ORDER BY u.id"


        connection.query(sql, function (error, rows) {
            if (error) {
                throw error;
            }
            else {
                callback(null, rows);
            }
        });
    }

}

//---------------------------------------------------------------
//obtenemos un usuario por su id
usuarioModel.getUsuario = function (id, callback) {

    if (connection) {
        var sql = "SELECT u.id "
            + ", u.nombre "
            + ", u.apellido "
            + ", u.correo "
            + ", u.telefono "
            + ", u.descripcion "
            + ", u.documento "
            + ", u.tipo_documento "
            + ", u.id_rol "
            + " FROM usuario u INNER JOIN rol r ON u.id_rol = r.id"
            + " WHERE u.id  = " + connection.escape(id) + ";";

        //console.log(id);
        //console.log(" 31  tal  " );
        connection.query(sql, function (error, row) {
            //se muestra el mensaje correspondiente
            if (error) {
                throw error;
            }
            else {
                callback(null, row);
            }
        });
    }
}

//---------------------------------------------------------------
//añadir un nuevo usuario

usuarioModel.insertUsuario = function (usuarioData, callback) {
    if (connection) {
        //console.log(usuarioData)
        var sql = "INSERT INTO usuario SET ?";
        //console.log("  tal  " + sql);

        connection.query(sql, usuarioData, function (error, result) {
            //se muestra el mensaje correspondiente
            if (error) {
                throw error;
            }
            else {
                callback(null, { "msg": "Registro Insertado" });
            }
        });
    }
}


//---------------------------------------------------------------
//actualizar un usuario

usuarioModel.updateUsuario = function (usuarioData, callback) {
    //console.log(" 32  tal  ");

    if (connection) {
        var sql = "UPDATE usuario SET "
            + " nombre = " + connection.escape(usuarioData.nombre)
            + ", apellido = " + connection.escape(usuarioData.apellido)
            + ", correo = " + connection.escape(usuarioData.correo)
            + ", telefono = " + connection.escape(usuarioData.telefono)
            + ", descripcion = " + connection.escape(usuarioData.descripcion)
            + ", documento = " + connection.escape(usuarioData.documento)
            + ", tipo_documento = " + connection.escape(usuarioData.tipo_documento)
            + ", id_rol = " + connection.escape(usuarioData.id_rol)
            + " WHERE id  =  " + connection.escape(usuarioData.id) + ";";

        ///console.log(" 37  tal  " + sql);

        connection.query(sql, function (error, result) {
            //se muestra el mensaje correspondiente
            if (error) {
                throw error;
            }
            else {
                callback(null, { "msg": "Registro Actualizado" });
            }
        });
    }
}

module.exports = usuarioModel;