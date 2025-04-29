import { Component } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, HttpClientModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  form = new FormGroup({
    name: new FormControl('', Validators.required),
    email: new FormControl('', [Validators.required, Validators.email]),
    marks: new FormControl('', Validators.required)
  });

  students: any[] = [];
  editingId: string | null = null;

  constructor(private http: HttpClient) {
    this.fetchStudents();
  }

  fetchStudents() {
    this.http.get<any[]>('http://localhost:3003/students').subscribe(data => this.students = data);
  }

  submit() {
    if (this.form.invalid) return;

    if (this.editingId) {
      this.http.put(`http://localhost:3003/students/${this.editingId}`, {
        name: this.form.value.name,
        marks: this.form.value.marks
      }).subscribe(() => {
        this.fetchStudents();
        this.form.reset();
        this.editingId = null;
      });
    } else {
      this.http.post('http://localhost:3003/students', this.form.value).subscribe(() => {
        this.fetchStudents();
        this.form.reset();
      });
    }
  }

  edit(student: any) {
    this.editingId = student._id;
    this.form.setValue({
      name: student.name,
      email: student.email,
      marks: student.marks
    });
  }

  delete(id: string) {
    this.http.delete(`http://localhost:3003/students/${id}`).subscribe(() => this.fetchStudents());
  }
}
