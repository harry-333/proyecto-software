import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ChangePasswordService } from 'app/services/change-password.service';


@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.scss']
})
export class ResetPasswordComponent implements OnInit {

  constructor(private resetPassService: ChangePasswordService) { }

  user = { email: '' }; // Modelo para el formulario

  forgetPassword() {

    console.log(this.user.email);
    // Llama a tu servicio de cambio de contraseña y pasa el correo
    this.resetPassService.forgetPassword({correo: this.user.email}).subscribe(response => {
      // Maneja la respuesta del backend (éxito o error)
      if (response) {
        // Aquí puedes manejar la respuesta exitosa, como redirigir al usuario a una página de confirmación o mostrar un mensaje de éxito
        console.log('Solicitud de restablecimiento de contraseña enviada con éxito');
      } else {
        // Aquí puedes manejar el error, como mostrar un mensaje de error
        console.error('Error al enviar la solicitud de restablecimiento de contraseña');
      }
    });
  }

  ngOnInit(): void {
  }

}
