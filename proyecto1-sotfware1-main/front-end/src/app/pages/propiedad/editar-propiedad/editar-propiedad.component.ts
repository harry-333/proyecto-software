import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Propiedad } from 'app/models/Propiedad';
import { AuthService } from 'app/services/auth.service';
import { PropiedadService } from 'app/services/propiedad.service';

@Component({
  selector: 'app-editar-propiedad',
  templateUrl: './editar-propiedad.component.html',
  styleUrls: ['./editar-propiedad.component.scss']
})
export class EditarPropiedadComponent implements OnInit {

  id = '';
  actualizando: boolean = false;
  propiedad: Propiedad = new Propiedad();

  
  usuarioId: number | null;

  constructor(
    private propiedadService: PropiedadService,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.usuarioId = this.authService.getUsuarioId();
    
    this.route.params.subscribe((params) => {
      if (params.id) {
        this.actualizando = true;
        this.propiedadService.getPropiedad(params.id).subscribe((data) => {
          if (data.length > 0) {
            this.propiedad = data[0];
          }
        });
      }
    });


  }

  guardarPropiedad() {
    
    if (this.propiedad.id_propiedad) {
      this.propiedadService.updatePropiedad(this.propiedad).subscribe((data) => {
        this.router.navigate(['/propiedades']);
      });
    } else {
      this.propiedad.id_vendedor = this.usuarioId;
      this.propiedadService.addPropiedad(this.propiedad).subscribe((data) => {
        this.router.navigate(['/propiedades']);
      });
    }
  }
}
