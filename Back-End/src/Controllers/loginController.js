const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const usuarioModel = require('../Models/usuarioModel');

const loginController = {};

loginController.login = async function (req, res) {
    try {
        const { correo, contrasena } = req.body;
        if (!correo || !contrasena) {
            res.status(400).send("Credenciales Incorrectas");
            return;
        }

        usuarioModel.buscarUsuarioPorCorreo(correo, async function (error, results) {
            if (error) {
                console.log(error);
                res.status(500).send("Error del servidor");
                return;
            }

            if (results.length == 0) {
                res.status(400).send("Credenciales Incorrectas");
                return;
            }

            const hashComparacion = await bcrypt.compare(contrasena, results[0].contrasena);
            if (!hashComparacion) {
                res.status(400).send("Credenciales Incorrectas");
                return;
            }

            const id = results[0].id;
            const id_rol = results[0].id_rol;
            const token = jwt.sign({ id: id, email: correo, role_id: id_rol }, "loginSecret", { expiresIn: "2h" });
            res.status(200).json({ token });
        });
    } catch (error) {
        console.log(error);
        res.status(500).send("Error del servidor");
    }
};

module.exports = loginController;
