import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Agenda } from 'app/models/Agenda';
import { AgendaService } from 'app/services/agenda.service';
import { AuthService } from 'app/services/auth.service';

@Component({
  selector: 'app-editar-agenda',
  templateUrl: './editar-agenda.component.html',
  styleUrls: ['./editar-agenda.component.scss']
})
export class EditarAgendaComponent implements OnInit {
  id = '';
  actualizando: boolean = false;
  agenda: Agenda = new Agenda();

  usuarioId: number | null;

  constructor(
    private agendaService: AgendaService,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.route.params.subscribe((params) => {
      if (params.id) {
        this.actualizando = true;
        this.agendaService.getAgenda(params.id).subscribe((data) => {
          if (data.length > 0) {
            this.agenda = data[0];
          }
        });
      }
    });
  }

  guardarAgenda() {
    if (this.agenda.id_agenda) {
      this.agendaService.updateAgenda(this.agenda).subscribe((data) => {
        this.router.navigate(['/agenda']);
      });
    } else {
      this.agenda.id_vendedor = this.usuarioId;
      this.agendaService.addAgenda(this.agenda).subscribe((data) => {
        this.router.navigate(['/agenda']);
      });
    }
  }
}
