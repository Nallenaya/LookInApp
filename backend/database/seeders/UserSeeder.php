<?php

namespace Database\Seeders;

use App\Models\Presensi;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        $admin = User::updateOrCreate(
            ['email' => 'admin@lookin.com'],
            [
                'name' => 'Jane Cooper',
                'password' => Hash::make('password123'),
                'role' => 'admin',
                'is_active' => true,
                'employee_id' => '20210000',
                'phone' => '0987654321',
                'division' => 'Manajemen',
                'position' => 'UI/UX DESIGNER',
                'address' => '534 Spear Street San Francisco, CA 94105 United States',
                'gender' => 'Laki-Laki',
                'birth_date' => '1997-01-06',
                'joined_date' => '2020-06-25',
                'shift_time' => '10:00:59 - 19:00:59',
                'branch' => 'Hyderabad',
            ]
        );

        User::updateOrCreate(
            ['email' => 'hrd@lookin.com'],
            [
                'name' => 'HRD LookIn',
                'password' => Hash::make('password123'),
                'role' => 'hrd',
                'is_active' => true,
                'employee_id' => 'HR-001',
                'phone' => '081122334455',
                'division' => 'Human Resources',
                'position' => 'HR Manager',
                'address' => 'Jakarta Selatan',
                'gender' => 'Perempuan',
                'birth_date' => '1992-05-14',
                'joined_date' => '2021-01-10',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Jakarta',
            ]
        );

        $sampleEmployees = [
            [
                'name' => 'Aldo Saputra',
                'email' => 'mas@example.com',
                'employee_id' => 'K-086',
                'phone' => '081234567890',
                'division' => 'Divisi IT',
                'position' => 'Programmer',
                'address' => 'Solo',
                'gender' => 'Laki-Laki',
                'birth_date' => '1998-03-22',
                'joined_date' => '2022-03-01',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Solo',
            ],
            [
                'name' => 'Mochammad Elang',
                'email' => 'elang@example.com',
                'employee_id' => 'K-001',
                'phone' => '081298765431',
                'division' => 'Divisi Operasional',
                'position' => 'Staff Operasional',
                'address' => 'Semarang',
                'gender' => 'Laki-Laki',
                'birth_date' => '1999-07-15',
                'joined_date' => '2022-06-15',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Semarang',
            ],
            [
                'name' => 'Khanza Nibras',
                'email' => 'karyawan@lookin.com',
                'employee_id' => 'K-002',
                'phone' => '081345678912',
                'division' => 'Divisi Desain',
                'position' => 'UI/UX Designer',
                'address' => 'Yogyakarta',
                'gender' => 'Perempuan',
                'birth_date' => '2000-02-18',
                'joined_date' => '2023-01-10',
                'shift_time' => '09:00:00 - 18:00:00',
                'branch' => 'Yogyakarta',
            ],
            [
                'name' => 'Nallenaya Ilham',
                'email' => 'ilham@example.com',
                'employee_id' => 'K-003',
                'phone' => '081398761234',
                'division' => 'Divisi IT',
                'position' => 'Mobile Developer',
                'address' => 'Bandung',
                'gender' => 'Laki-Laki',
                'birth_date' => '1997-11-20',
                'joined_date' => '2021-08-01',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Bandung',
            ],
            [
                'name' => 'Mohamad Rahmat',
                'email' => 'rahmat@example.com',
                'employee_id' => 'K-004',
                'phone' => '081277665544',
                'division' => 'Divisi HRD',
                'position' => 'Recruiter',
                'address' => 'Surabaya',
                'gender' => 'Laki-Laki',
                'birth_date' => '1995-09-09',
                'joined_date' => '2020-11-15',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Surabaya',
            ],
            [
                'name' => 'Faudhan Adzin',
                'email' => 'faudhan@example.com',
                'employee_id' => 'K-005',
                'phone' => '081266554433',
                'division' => 'Divisi Marketing',
                'position' => 'SEO Specialist',
                'address' => 'Jakarta Barat',
                'gender' => 'Laki-Laki',
                'birth_date' => '1996-04-12',
                'joined_date' => '2022-01-20',
                'shift_time' => '09:00:00 - 18:00:00',
                'branch' => 'Jakarta',
            ],
            [
                'name' => 'Ireng gendeng',
                'email' => 'ireng@example.com',
                'employee_id' => 'K-006',
                'phone' => '081255443322',
                'division' => 'Divisi Keuangan',
                'position' => 'Akuntan',
                'address' => 'Solo',
                'gender' => 'Laki-Laki',
                'birth_date' => '1994-12-05',
                'joined_date' => '2019-09-01',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Solo',
            ],
            [
                'name' => 'Andi Saputra',
                'email' => 'andi@example.com',
                'employee_id' => 'KRY001',
                'phone' => '081211223344',
                'division' => 'Divisi IT',
                'position' => 'Backend Developer',
                'address' => 'Jakarta Selatan',
                'gender' => 'Laki-Laki',
                'birth_date' => '1996-08-10',
                'joined_date' => '2021-04-01',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Jakarta',
            ],
            [
                'name' => 'Budi Santoso',
                'email' => 'budi@example.com',
                'employee_id' => 'KRY002',
                'phone' => '081233445566',
                'division' => 'Divisi Operasional',
                'position' => 'Field Officer',
                'address' => 'Tangerang',
                'gender' => 'Laki-Laki',
                'birth_date' => '1993-10-30',
                'joined_date' => '2020-02-15',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Jakarta',
            ],
            [
                'name' => 'Yogi Prasetyo',
                'email' => 'yogi@example.com',
                'employee_id' => 'K-008',
                'phone' => '081244556677',
                'division' => 'Divisi Marketing',
                'position' => 'Content Creator',
                'address' => 'Malang',
                'gender' => 'Laki-Laki',
                'birth_date' => '2001-01-25',
                'joined_date' => '2023-05-01',
                'shift_time' => '09:00:00 - 18:00:00',
                'branch' => 'Surabaya',
            ],
            [
                'name' => 'Arifin Pratama',
                'email' => 'arifin@example.com',
                'employee_id' => 'K-009',
                'phone' => '081255667788',
                'division' => 'Divisi IT',
                'position' => 'Quality Assurance',
                'address' => 'Bogor',
                'gender' => 'Laki-Laki',
                'birth_date' => '1997-06-14',
                'joined_date' => '2022-07-01',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Jakarta',
            ],
            [
                'name' => 'Bayu Nugroho',
                'email' => 'bayu@example.com',
                'employee_id' => 'K-010',
                'phone' => '081266778899',
                'division' => 'Divisi Logistik',
                'position' => 'Inventory Specialist',
                'address' => 'Bekasi',
                'gender' => 'Laki-Laki',
                'birth_date' => '1995-03-19',
                'joined_date' => '2021-10-10',
                'shift_time' => '08:00:00 - 17:00:00',
                'branch' => 'Jakarta',
            ],
        ];

        $today = today()->toDateString();

        foreach ($sampleEmployees as $empData) {
            $user = User::updateOrCreate(
                ['email' => $empData['email']],
                [
                    ...$empData,
                    'password' => Hash::make('password123'),
                    'role' => 'karyawan',
                    'is_active' => true,
                ]
            );

            // Create sample presensi for today for some users
            if (in_array($user->employee_id, ['KRY001', 'K-086', 'K-001', 'K-003', 'K-008', 'K-009', 'K-010'])) {
                Presensi::firstOrCreate(
                    [
                        'user_id' => $user->id,
                        'tanggal' => $today,
                    ],
                    [
                        'jam_masuk' => '08:00:00',
                        'status' => 'bekerja',
                        'foto_masuk' => 'presensi/sample.jpg',
                    ]
                );
            }
        }
    }
}
