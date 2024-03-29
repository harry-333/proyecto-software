import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PublicLayoutRoutingModule } from './public-layout-routing.module';
import { LoginComponent } from 'app/pages/login/login.component';
import { RegisterComponent } from 'app/pages/register/register.component';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import {MatFormFieldModule} from '@angular/material/form-field';
import {MatTooltipModule} from '@angular/material/tooltip';
import {MatSelectModule} from '@angular/material/select';
import {MatButtonModule} from '@angular/material/button';
import {MatInputModule} from '@angular/material/input';
import { DataTablesModule } from 'angular-datatables';
import { PublicComponent } from '../../pages/home/public/public.component';
import { ResetPasswordComponent } from '../../pages/reset-password/reset-password.component';
import { ChangePasswordComponent } from '../../pages/reset-password/change-password/change-password.component';
import { HomePropiedadesComponent } from 'app/pages/propiedad/home-propiedades/home-propiedades.component';

@NgModule({
  declarations: [
    LoginComponent,
    RegisterComponent,
    PublicComponent,
    ResetPasswordComponent,
    ChangePasswordComponent,
    HomePropiedadesComponent
  ],
  imports: [
    CommonModule,
    PublicLayoutRoutingModule,
    FormsModule,
    HttpClientModule,
    MatFormFieldModule,
    MatSelectModule,
    MatTooltipModule,
    MatInputModule,
    MatButtonModule,
    DataTablesModule
  ]
})
export class PublicLayoutModule { }
