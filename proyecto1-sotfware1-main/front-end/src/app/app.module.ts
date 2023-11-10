import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';
import { AppRoutingModule } from './app.routing';
import { ComponentsModule } from './components/components.module';
import { AppComponent } from './app.component';
import { AdminLayoutComponent } from './layouts/admin-layout/admin-layout.component';
import { UserLayoutComponent } from './layouts/user-layout/user-layout.component';
import { PublicLayoutComponent } from './layouts/public-layout/public-layout.component';
import { JwtHelperService, JWT_OPTIONS } from '@auth0/angular-jwt';
import { TokenInterceptorService } from './services/token-interceptor.service';
import { DataTablesModule } from 'angular-datatables';
import { MatInputModule } from '@angular/material/input'
import { MatSelectModule  } from '@angular/material/select';
import { MatDialogModule} from '@angular/material/dialog';
//import { MatDatepickerModule } from '@angular/material/datepicker';




@NgModule({


  imports: [
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    ComponentsModule,
    RouterModule,
    AppRoutingModule,
    DataTablesModule,
    MatInputModule,
    MatSelectModule,
    //MatDatepickerModule,
    MatDialogModule,
    
    
  ],
  declarations: [
    AppComponent,
    PublicLayoutComponent,
    AdminLayoutComponent,
    UserLayoutComponent,
    

  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: TokenInterceptorService, multi: true},
    { provide: JWT_OPTIONS, useValue: JWT_OPTIONS }, JwtHelperService,
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
