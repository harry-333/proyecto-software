var connection = require('../conexion/index');

var clienteModel = {};

clienteModel.getClientes = function(callback)
{

    if (connection)
    {
        var sql = "SELECT id_cliente "
                        +", nom1_cliente "
                        +", nom2_cliente "
                        +", ape1_cliente "
                        +", ape2_cliente "
                        +", No_doc "
                        +", id_tipodoc "
                        +" FROM cliente  "
                        +" ORDER BY id_cliente"
                        

        connection.query(sql, function(error, rows)
        {
            if (error)
            {
                throw error;
            }
            else
            {
                callback(null, rows);
            }
        } );
    }

}

//---------------------------------------------------------------
//obtenemos un cliente por su id
clienteModel.getCliente = function (id, callback)
{
    
    if (connection)
    {
        var sql = "SELECT id_cliente "
                        +", nom1_cliente "
                        +", nom2_cliente "
                        +", ape1_cliente "
                        +", ape2_cliente "
                        +", No_doc "
                        +", id_tipodoc "
                        +" FROM cliente  "
                        +" WHERE id_cliente  = " 
                        + connection.escape(id) + ";";

        //console.log(id);
        //console.log(" 31  tal  " );
        connection.query(sql, function (error, row)
        {
            //se muestra el mensaje correspondiente
            if (error)
            {
                throw error;
            }
            else
            {
                callback(null, row);
            }
        });
    }
}

//---------------------------------------------------------------
//añadir un nuevo cliente

clienteModel.insertCliente = function (clienteData, callback)
{
    if (connection)
    {
        //console.log(clienteData)
        var sql = "INSERT INTO cliente SET ?";
        //console.log("  tal  " + sql);

        connection.query(sql, clienteData, function (error, result)
        {
            //se muestra el mensaje correspondiente
            if (error)
            {
                throw error;
            }
            else
            {
                callback(null,{"msg": "Registro Insertado"});
            }
        });
    }
}


//---------------------------------------------------------------
//actualizar un cliente

clienteModel.updateCliente = function (clienteData, callback)
 {
    //console.log(" 32  tal  ");

    if (connection)
    {
        var sql = "UPDATE cliente SET "
                    + " nom1_cliente = " + connection.escape(clienteData.nom1_cliente)
                    + ", nom2_cliente = " + connection.escape(clienteData.nom2_cliente)
                    + ", ape1_cliente = " + connection.escape(clienteData.ape1_cliente)
                    + ", ape2_cliente = " + connection.escape(clienteData.ape2_cliente)
                    + ", No_doc = " + connection.escape(clienteData.No_doc)
                    + " WHERE  id_cliente  =  " + connection.escape(clienteData.id_cliente) + ";";
        
        ///console.log(" 37  tal  " + sql);

        connection.query(sql, function (error, result)
        {
            //se muestra el mensaje correspondiente
            if (error)
            {
                throw error;
            }
            else
            {
                callback(null, {"msg": "Registro Actualizado"});
            }
        });
    }
}

module.exports = clienteModel;