var conexion = require('../conexion/index');
const jwt = require("jsonwebtoken");
//const usuarioSchema = {};
const express = require('express');
const router = express.Router();
const bcrypt = require("bcrypt");


router.post('/login', async (req, res) => {
    try {
        const correo = req.body.correo;
        const contrasena = req.body.contrasena;
        console.log(correo + '-' + contrasena);
        if (!correo || !contrasena) {
            // Manejo de errores si el correo o la contraseña están ausentes
        } else {
            var sql = `SELECT * FROM usuario WHERE correo = "${correo}"`;
            conexion.query(sql, async (error, results) => {
                if (results.length == 0) {
                    res.status(400).send("Credenciales Incorrectas");
                } else {
                    const hashComparacion = await bcrypt.compare(contrasena, results[0].contrasena);
                    if (!hashComparacion) {
                        res.status(400).send("Credenciales Incorrectas");
                    } else {
                        const id = results[0].id;
                        const id_rol = results[0].id_rol;
                        const token = jwt.sign({ id: id, email: correo, role_id: id_rol}, "loginSecret", { expiresIn: "2h" });
                        
                        res.status(200).json({token});
                    }
                }
            })
        }
    } catch (error) {
        console.log(error);
        // Manejo de errores generales
    }
});



module.exports = router;