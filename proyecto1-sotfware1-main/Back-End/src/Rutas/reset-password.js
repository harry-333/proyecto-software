const express = require('express');
const router = express.Router();
var conexion = require('../conexion/index');
const nodemailer = require('nodemailer');
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");


// Configura el transporte para enviar correos
const transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: 'yimmernicolas@gmail.com',
        pass: 'wfey dmlg vjxv qqtz',
    },
});

router.post('/forget-password', async (req, res) => {

    try {
        const { correo } = req.body;
        console.log(correo);
        // Realiza una consulta a la base de datos para verificar si el correo existe
        conexion.query('SELECT * FROM usuario WHERE correo = ?', [correo], (error, results) => {
            if (error) {
                console.error(error);
                res.status(500).send('Error en la consulta de la base de datos');
            } else if (results.length === 0) {
                res.status(404).send('El correo no se encuentra en la base de datos');
            } else {
                // El correo existe en la base de datos, generar un token único
                const user = results[0];

                // Generar un token con información del usuario
                const token = jwt.sign({ id: user.id, email: correo }, "resetPass", { expiresIn: "10m" });

                // Construir el enlace de restablecimiento de contraseña
                const resetLink = `http://localhost:4200/public/change-password/${token}`;

                // Enviar el enlace de restablecimiento de contraseña por correo electrónico
                const mailOptions = {
                    from: '',
                    to: correo,
                    subject: 'Restablecimiento de contraseña',
                    text: `Haz clic en el siguiente enlace para restablecer tu contraseña: ${resetLink}`,
                };

                transporter.sendMail(mailOptions, (emailError, info) => {
                    if (emailError) {
                        console.error(emailError);
                        res.status(500).send('Error al enviar el correo');
                    } else {
                        console.log('Correo enviado: ' + info.response);
                        res.send('Correo enviado con éxito');
                    }
                });

                res.status(200).json({ message: 'Enlace de restablecimiento de contraseña enviado' });
            }
        });
    } catch (error) {
        console.log(error);
    }
});


router.post('/reset-password/:token', async (req, res) => {
    try {
        const { token } = req.params;
        const { contrasena } = req.body;

        console.log(token, contrasena);

        // Verifica el token
        jwt.verify(token, 'resetPass', (err, decoded) => {
            if (err) {
                console.error(err);
                return res.status(400).send('Token no válido o ha expirado');
            }

            const email = decoded.email;

            // Hashea la nueva contraseña
            bcrypt.hash(contrasena, 10, (hashErr, hashedPassword) => {
                if (hashErr) {
                    console.error(hashErr);
                    return res.status(500).send('Error al cambiar la contraseña');
                }

                // Actualiza la contraseña en la base de datos
                conexion.query('UPDATE usuario SET contrasena = ? WHERE correo = ?', [hashedPassword, email], (updateErr, result) => {
                    if (updateErr) {
                        console.error(updateErr);
                        return res.status(500).send('Error al cambiar la contraseña');
                    }

                    res.status(200).send('Contraseña restablecida con éxito');
                });
            });
        });
    } catch (error) {
        console.log(error);
    }
});

module.exports = router;