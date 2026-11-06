<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

#[Fillable([
    'name',
    'email',
    'password',
    'role',
    'is_active',
    'employee_id',
    'phone',
    'division',
    'position',
    'address',
    'gender',
    'birth_date',
    'joined_date',
    'shift_time',
    'branch',
    'avatar',
    'face_depan',
    'face_samping_kiri',
    'face_samping_kanan',
    'face_menunduk',
    'face_menengadah',
])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_active' => 'boolean',
        ];
    }

    public function presensis()
    {
        return $this->hasMany(Presensi::class);
    }

    public function employeeRequests()
    {
        return $this->hasMany(EmployeeRequest::class);
    }
}
