import { Component, OnInit, ElementRef, OnDestroy } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import { AuthService } from 'app/services/auth.service';
import { jwtDecode } from 'jwt-decode';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  user = {
    correo: '',
    contrasena: ''
  }


  private toggleButton: any;
  private sidebarVisible: boolean;
  private nativeElement: Node;

  constructor(private element: ElementRef,
    private authService: AuthService,
    private router: Router,
    private snackBar: MatSnackBar,
  ) {
    this.nativeElement = element.nativeElement;
    this.sidebarVisible = false;
  }

  ngOnInit() {
    var navbar: HTMLElement = this.element.nativeElement;
    this.toggleButton = navbar.getElementsByClassName('navbar-toggle')[0];
    const body = document.getElementsByTagName('body')[0];
    body.classList.add('login-page');
    body.classList.add('off-canvas-sidebar');
    const card = document.getElementsByClassName('card')[0];
    setTimeout(function () {
      // after 1000 ms we add the class animated to the login/register card
      card.classList.remove('card-hidden');
    }, 700);
  }
  sidebarToggle() {
    var toggleButton = this.toggleButton;
    var body = document.getElementsByTagName('body')[0];
    var sidebar = document.getElementsByClassName('navbar-collapse')[0];
    if (this.sidebarVisible == false) {
      setTimeout(function () {
        toggleButton.classList.add('toggled');
      }, 500);
      body.classList.add('nav-open');
      this.sidebarVisible = true;
    } else {
      this.toggleButton.classList.remove('toggled');
      this.sidebarVisible = false;
      body.classList.remove('nav-open');
    }
  }
  ngOnDestroy() {
    const body = document.getElementsByTagName('body')[0];
    body.classList.remove('login-page');
    body.classList.remove('off-canvas-sidebar');
  }

  login() {
    
    this.authService.singin(this.user).subscribe(
      (res: any) => {
        // Manejo del éxito
        localStorage.setItem('token', res.token);
  
        const decoded: any = jwtDecode(res.token);
        const role = decoded.role_id;
        
        // Redirigir al diseño correspondiente según el rol
        if (role === 1) {
          this.router.navigate(['/home']);
        } else if (role === 2 || role === 3) {
          this.router.navigate(['/user/home']);
        } else {
          // Redirigir a una página predeterminada en caso de otro rol desconocido
          this.router.navigate(['/public/login']);
        }
      },
      (error) => {
        // Manejo de errores
        //console.log(error);
  
        if (error.status === 400) {
          // Mensaje personalizado para el error 400
          this.mostrarNotificacion('Error: Usuario o contraseña incorrectos', true);
        } else {
          // Otro manejo de errores
          this.mostrarNotificacion('Error interno del servidor, por favor contactar con el soporte técnico', true);
        }
      }
    );
  }
  

  private mostrarNotificacion(mensaje: string, esError: boolean = false) {
    this.snackBar.open(mensaje, 'Cerrar', {
      duration: 5000,
      panelClass: esError ? ['error-notificacion'] : null,
    });
  }

}
