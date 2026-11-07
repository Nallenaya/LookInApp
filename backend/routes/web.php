<?php

use App\Http\Controllers\AdminWebController;
use Illuminate\Support\Facades\Route;

Route::get('/', [AdminWebController::class, 'loginForm']);
Route::get('/admin/login', [AdminWebController::class, 'loginForm'])->name('admin.login');
Route::get('/admin/reset-password', fn () => view('admin.reset'))->name('admin.password.reset');
Route::post('/admin/login', [AdminWebController::class, 'login'])->middleware('throttle:10,1')->name('admin.login.submit');

Route::middleware(['auth', 'role:admin'])->prefix('admin')->name('admin.')->group(function () {
    // 1. Dashboard
    Route::get('/', [AdminWebController::class, 'dashboard'])->name('dashboard');
    Route::post('/logout', [AdminWebController::class, 'logout'])->name('logout');
    Route::post('/attendance/{action}', [AdminWebController::class, 'attendance'])->name('attendance');

    // 2. Monitoring
    Route::get('/monitoring', [AdminWebController::class, 'monitoring'])->name('monitoring');

    // 3. Laporan
    Route::get('/laporan', [AdminWebController::class, 'laporan'])->name('laporan');
    Route::get('/laporan/export', [AdminWebController::class, 'exportLaporan'])->name('laporan.export');

    // 4. Registrasi Wajah / Karyawan
    Route::get('/registrasi-wajah', [AdminWebController::class, 'registrasiWajahForm'])->name('registrasi-wajah');
    Route::post('/registrasi-wajah', [AdminWebController::class, 'storeKaryawan'])->name('registrasi-wajah.store');

    // 5. Karyawan Management
    Route::get('/karyawan', [AdminWebController::class, 'karyawanIndex'])->name('karyawan');
    Route::get('/karyawan/export', [AdminWebController::class, 'exportKaryawan'])->name('karyawan.export');
    Route::get('/karyawan/{id}', [AdminWebController::class, 'karyawanDetail'])->name('karyawan.detail');
    Route::put('/karyawan/{id}', [AdminWebController::class, 'karyawanUpdate'])->name('karyawan.update');
    Route::delete('/karyawan/{id}', [AdminWebController::class, 'karyawanDelete'])->name('karyawan.delete');

    // 6. Akun
    Route::get('/akun', [AdminWebController::class, 'akun'])->name('akun');
    Route::put('/akun/password', [AdminWebController::class, 'updatePassword'])->name('akun.password');
    Route::put('/profile', [AdminWebController::class, 'updateProfile'])->name('profile.update');

    // Legacy requests & user management compatibility
    Route::post('/requests', [AdminWebController::class, 'submitRequest'])->name('requests.store');
    Route::patch('/requests/{employeeRequest}/decision', [AdminWebController::class, 'decideRequest'])->name('requests.decision');
    Route::post('/users', [AdminWebController::class, 'storeUser'])->name('users.store');
    Route::put('/users/{user}', [AdminWebController::class, 'updateUser'])->name('users.update');
    Route::patch('/users/{user}/toggle', [AdminWebController::class, 'toggleUser'])->name('users.toggle');
});
