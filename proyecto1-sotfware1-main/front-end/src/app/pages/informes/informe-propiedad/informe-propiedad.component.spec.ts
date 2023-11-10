import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InformePropiedadComponent } from './informe-propiedad.component';

describe('InformePropiedadComponent', () => {
  let component: InformePropiedadComponent;
  let fixture: ComponentFixture<InformePropiedadComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ InformePropiedadComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(InformePropiedadComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
