<?php

namespace Tests\Feature;

use App\Models\Presensi;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class AdminDesignPagesTest extends TestCase
{
    use RefreshDatabase;

    private User $admin;

    protected function setUp(): void
    {
        parent::setUp();
        $this->admin = User::create([
            'name' => 'Jane Cooper',
            'email' => 'admin@lookin.com',
            'password' => 'password123',
            'role' => 'admin',
            'is_active' => true,
        ]);
    }

    public function test_can_view_dashboard_with_insights_and_attendance(): void
    {
        $this->actingAs($this->admin)
            ->get(route('admin.dashboard'))
            ->assertOk()
            ->assertSee('Insights')
            ->assertSee('Persentase Tepat Waktu')
            ->assertSee('Attendance')
            ->assertSee('Jam kerja')
            ->assertSee('Jam Istirahat')
            ->assertSee('Punch In');
    }

    public function test_attendance_lifecycle(): void
    {
        // 1. Check in
        $this->actingAs($this->admin)
            ->post(route('admin.attendance', ['action' => 'check-in']))
            ->assertSessionHas('success');

        $this->assertDatabaseHas('presensis', [
            'user_id' => $this->admin->id,
            'status' => 'bekerja',
        ]);

        // 2. Start break
        $this->actingAs($this->admin)
            ->post(route('admin.attendance', ['action' => 'start-break']))
            ->assertSessionHas('success');

        $this->assertDatabaseHas('presensis', [
            'user_id' => $this->admin->id,
            'status' => 'istirahat',
        ]);

        // 3. Stop break
        $this->actingAs($this->admin)
            ->post(route('admin.attendance', ['action' => 'stop-break']))
            ->assertSessionHas('success');

        $this->assertDatabaseHas('presensis', [
            'user_id' => $this->admin->id,
            'status' => 'bekerja',
        ]);

        // 4. Check out
        $this->actingAs($this->admin)
            ->post(route('admin.attendance', ['action' => 'check-out']))
            ->assertSessionHas('success');

        $this->assertDatabaseHas('presensis', [
            'user_id' => $this->admin->id,
            'status' => 'selesai',
        ]);
    }

    public function test_can_view_monitoring(): void
    {
        $this->actingAs($this->admin)
            ->get(route('admin.monitoring'))
            ->assertOk()
            ->assertSee('Monitoring')
            ->assertSee('Sedang Bekerja')
            ->assertSee('Belum Mulai')
            ->assertSee('Daftar Aktivitas Karyawan');
    }

    public function test_can_view_and_export_laporan(): void
    {
        $this->actingAs($this->admin)
            ->get(route('admin.laporan'))
            ->assertOk()
            ->assertSee('Laporan')
            ->assertSee('Ringkasan Periode')
            ->assertSee('Total Jam Kerja')
            ->assertSee('Tepat Waktu');

        $response = $this->actingAs($this->admin)
            ->get(route('admin.laporan.export'));

        $response->assertOk();
        $this->assertTrue(str_contains($response->headers->get('content-type'), 'text/csv'));
    }

    public function test_can_register_new_employee_with_faces(): void
    {
        Storage::fake('public');

        $response = $this->actingAs($this->admin)
            ->post(route('admin.registrasi-wajah.store'), [
                'name' => 'Aldo Saputra',
                'email' => 'aldo@example.com',
                'phone' => '08123456789',
                'division' => 'Divisi IT',
                'position' => 'Programmer',
                'address' => 'Solo',
                'password' => 'password123',
                'face_depan' => UploadedFile::fake()->image('depan.jpg'),
                'face_samping_kiri' => UploadedFile::fake()->image('kiri.jpg'),
                'face_samping_kanan' => UploadedFile::fake()->image('kanan.jpg'),
                'face_menunduk' => UploadedFile::fake()->image('menunduk.jpg'),
                'face_menengadah' => UploadedFile::fake()->image('menengadah.jpg'),
            ]);

        $newEmp = User::where('email', 'aldo@example.com')->first();
        $this->assertNotNull($newEmp);
        $response->assertRedirect(route('admin.karyawan.detail', $newEmp->id));
    }

    public function test_karyawan_list_detail_and_management(): void
    {
        $karyawan = User::create([
            'name' => 'Mochammad Elang',
            'email' => 'elang@example.com',
            'password' => 'password123',
            'role' => 'karyawan',
            'is_active' => true,
        ]);

        // List
        $this->actingAs($this->admin)
            ->get(route('admin.karyawan'))
            ->assertOk()
            ->assertSee('Mochammad Elang')
            ->assertSee('Lihat detail');

        // Detail
        $this->actingAs($this->admin)
            ->get(route('admin.karyawan.detail', $karyawan->id))
            ->assertOk()
            ->assertSee('Mochammad Elang')
            ->assertSee('Data Wajah Terdaftar')
            ->assertSee('Foto Depan');

        // Update
        $this->actingAs($this->admin)
            ->put(route('admin.karyawan.update', $karyawan->id), [
                'name' => 'Elang Updated',
                'email' => $karyawan->email,
                'phone' => '08199999999',
            ])->assertSessionHas('success');

        $this->assertDatabaseHas('users', ['id' => $karyawan->id, 'name' => 'Elang Updated']);

        // Delete
        $this->actingAs($this->admin)
            ->delete(route('admin.karyawan.delete', $karyawan->id))
            ->assertRedirect(route('admin.karyawan'));

        $this->assertDatabaseMissing('users', ['id' => $karyawan->id]);
    }

    public function test_can_view_and_manage_akun(): void
    {
        // View detail mode
        $this->actingAs($this->admin)
            ->get(route('admin.akun'))
            ->assertOk()
            ->assertSee('Account Details')
            ->assertSee('Jane Cooper');

        // View edit mode
        $this->actingAs($this->admin)
            ->get(route('admin.akun', ['tab' => 'edit']))
            ->assertOk()
            ->assertSee('Detail Akun')
            ->assertSee('Perbarui');

        // View password mode
        $this->actingAs($this->admin)
            ->get(route('admin.akun', ['tab' => 'password']))
            ->assertOk()
            ->assertSee('Pengaturan Password')
            ->assertSee('Reset Password');
    }
}

