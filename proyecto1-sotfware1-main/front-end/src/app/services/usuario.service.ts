import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Usuario } from 'app/models/Usuario';

@Injectable({
  providedIn: 'root'
})
export class UsuarioService {

  BASE_URL = 'http://localhost:3000'

  constructor(private http: HttpClient) { }

  getUsuarios(){
    return this.http.get<Usuario[]>(`${this.BASE_URL}/usuario`);
  }

  getUsuario(id: string){
    return this.http.get<Usuario[]>(`${this.BASE_URL}/usuario/${id}`);
  }

  addUsuario(usuario: Usuario){
    return this.http.post<string>(`${this.BASE_URL}/usuario`, usuario);
  }

  updateUsuario(usuario: Usuario){
    return this.http.put<string>(`${this.BASE_URL}/usuario/${usuario.id}`, usuario);
  }
}
