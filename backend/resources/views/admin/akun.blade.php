@extends('layouts.admin')

@section('title', 'Akun Saya · LookIn')

@section('styles')
<style>
    .account-wrapper {
        max-width: 1200px;
        margin: 0 auto;
        background: #FFFFFF;
        border-radius: var(--radius-lg);
        overflow: hidden;
        border: 1px solid var(--border);
        box-shadow: var(--shadow-sm);
    }

    /* Blue Top Banner */
    .account-banner {
        height: 140px;
        background: linear-gradient(180deg, #96CDFA 0%, #B6DEFC 100%);
        position: relative;
        display: flex;
        justify-content: flex-end;
        align-items: flex-start;
        padding: 20px 28px;
    }

    .banner-actions {
        display: flex;
        gap: 12px;
    }

    .banner-icon-btn {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        background: #FFFFFF;
        border: 1px solid #D5E7F7;
        color: #0080FF;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        text-decoration: none;
        transition: all 0.2s ease;
        box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    }

    .banner-icon-btn:hover, .banner-icon-btn.active {
        background: #0080FF;
        color: #FFFFFF;
    }

    /* Profile Center Info */
    .profile-center {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-top: -65px;
        margin-bottom: 30px;
        position: relative;
        z-index: 10;
    }

    .avatar-wrapper {
        position: relative;
        width: 130px;
        height: 130px;
        margin-bottom: 12px;
    }

    .avatar-img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid #FFFFFF;
        box-shadow: 0 4px 14px rgba(0,0,0,0.1);
        background: #E2EDF6;
    }

    .avatar-camera-btn {
        position: absolute;
        bottom: 2px;
        right: 45px;
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: #FFFFFF;
        border: 1px solid #C4D9EC;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #0080FF;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        cursor: pointer;
    }

    .profile-name {
        font-size: 22px;
        font-weight: 800;
        color: #17406E;
        margin-bottom: 2px;
    }

    .profile-role {
        font-size: 15px;
        font-weight: 600;
        color: #17406E;
    }

    /* Account Body */
    .account-body {
        padding: 0 48px 48px 48px;
    }

    .tab-section-title {
        font-size: 16px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 24px;
        padding-bottom: 8px;
        border-bottom: 1px solid #EEF4F8;
    }

    /* Tab 1: Account Details (View Mode) */
    .details-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px 48px;
    }

    .detail-item-group label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #0080FF;
        margin-bottom: 4px;
    }

    .detail-item-group .value {
        font-size: 15px;
        font-weight: 600;
        color: #1E293B;
    }

    /* Tab 2: Edit Form */
    .edit-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px 36px;
    }

    .edit-form-group {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .edit-form-group label {
        font-size: 13px;
        font-weight: 600;
        color: #334155;
    }

    .edit-input, .edit-select {
        border: 1px solid #C4D9EC;
        border-radius: var(--radius-sm);
        padding: 11px 14px;
        font-size: 14px;
        font-family: inherit;
        color: #1E293B;
        background: #FFFFFF;
        outline: none;
    }

    .edit-input:focus, .edit-select:focus {
        border-color: #0080FF;
    }

    .btn-update {
        background: #0080FF;
        color: #FFFFFF;
        padding: 12px 36px;
        font-size: 14px;
        font-weight: 700;
        border-radius: var(--radius-sm);
        border: none;
        cursor: pointer;
        font-family: inherit;
        transition: background 0.2s ease;
    }

    .btn-update:hover {
        background: #006ee0;
    }

    /* Tab 3: Password Form */
    .password-form-container {
        max-width: 800px;
    }

    .password-fields {
        display: flex;
        flex-direction: column;
        gap: 18px;
        margin-bottom: 28px;
    }

    .password-group {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .password-group label {
        font-size: 13px;
        font-weight: 600;
        color: #334155;
    }

    .password-input {
        border: 1px solid #C4D9EC;
        border-radius: var(--radius-sm);
        padding: 12px 16px;
        font-size: 14px;
        font-family: inherit;
        color: #1E293B;
        background: #FFFFFF;
        outline: none;
    }

    .password-input:focus {
        border-color: #0080FF;
    }

    .password-btn-row {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
    }

    .btn-cancel {
        background: #FFFFFF;
        border: 1px solid #0080FF;
        color: #0080FF;
        padding: 11px 28px;
        font-size: 14px;
        font-weight: 700;
        border-radius: var(--radius-sm);
        cursor: pointer;
        text-decoration: none;
        font-family: inherit;
    }

    .btn-reset-pass {
        background: #0080FF;
        color: #FFFFFF;
        padding: 11px 28px;
        font-size: 14px;
        font-weight: 700;
        border-radius: var(--radius-sm);
        border: none;
        cursor: pointer;
        font-family: inherit;
    }

    @media (max-width: 768px) {
        .details-grid, .edit-grid {
            grid-template-columns: 1fr;
        }
        .account-body {
            padding: 0 20px 32px 20px;
        }
    }
</style>
@endsection

@section('content')
    <div class="account-wrapper">
        <!-- Top Banner -->
        <div class="account-banner">
            <div class="banner-actions">
                <!-- Edit Icon Button -->
                <a href="{{ route('admin.akun', ['tab' => 'edit']) }}" class="banner-icon-btn {{ $tab === 'edit' ? 'active' : '' }}" title="Edit Profile">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
                </a>

                <!-- Lock/Password Icon Button -->
                <a href="{{ route('admin.akun', ['tab' => 'password']) }}" class="banner-icon-btn {{ $tab === 'password' ? 'active' : '' }}" title="Ganti Password">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                </a>
            </div>
        </div>

        <!-- Center Avatar & Role -->
        <div class="profile-center">
            <div class="avatar-wrapper">
                <img src="{{ asset('assets/design/jane-cooper.png') }}" alt="{{ $user->name }}" class="avatar-img" onerror="this.src='{{ asset('assets/design/avatar-small.png') }}'">
                <div class="avatar-camera-btn" title="Ganti Foto">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                </div>
            </div>
            <h2 class="profile-name">{{ $user->name }}</h2>
            <div class="profile-role">Atmin1</div>
        </div>

        <!-- Body Tabs -->
        <div class="account-body">
            @if ($tab === 'detail')
                <!-- TAB 1: Account Details (View Mode) -->
                <h3 class="tab-section-title">Account Details</h3>

                <div class="details-grid">
                    <div class="detail-item-group">
                        <label>Employee ID</label>
                        <div class="value">{{ $user->employee_id ?? '20210000' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Official Email ID</label>
                        <div class="value">{{ $user->email }}</div>
                    </div>

                    @php
                        $nameParts = explode(' ', $user->name, 2);
                        $firstName = $nameParts[0] ?? 'Jane';
                        $lastName = $nameParts[1] ?? 'Cooper';
                    @endphp

                    <div class="detail-item-group">
                        <label>First Name</label>
                        <div class="value">{{ $firstName }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Last Name</label>
                        <div class="value">{{ $lastName }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Date of Birth</label>
                        <div class="value">{{ $user->birth_date ? Carbon\Carbon::parse($user->birth_date)->format('d/m/Y') : '06/12/1990' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Gender</label>
                        <div class="value">{{ $user->gender ?? 'Laki-Laki' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Phone Number</label>
                        <div class="value">{{ $user->phone ?? '0123456789' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Shift Time</label>
                        <div class="value">{{ $user->shift_time ?? '10:00:59 - 19:00:59' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Role</label>
                        <div class="value">{{ $user->position ?? 'UI/UX DESIGNER' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Branch</label>
                        <div class="value">{{ $user->branch ?? 'Hyderabad (India)' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Address</label>
                        <div class="value">{{ $user->address ?? '534 Spear Street San Francisco, CA 94105 United States' }}</div>
                    </div>

                    <div class="detail-item-group">
                        <label>Joined Date</label>
                        <div class="value">{{ $user->joined_date ? Carbon\Carbon::parse($user->joined_date)->format('d-m-Y') : '25-06-2020' }}</div>
                    </div>
                </div>

            @elseif ($tab === 'edit')
                <!-- TAB 2: Edit Mode -->
                <h3 class="tab-section-title">Detail Akun</h3>

                <form method="POST" action="{{ route('admin.profile.update') }}">
                    @csrf
                    @method('PUT')

                    <div class="edit-grid">
                        <div class="edit-form-group">
                            <label>Id Karyawan</label>
                            <input type="text" class="edit-input" value="{{ $user->employee_id ?? '20210000' }}" readonly>
                        </div>

                        <div class="edit-form-group">
                            <label>Email Perusahaan</label>
                            <input type="email" name="email" class="edit-input" value="{{ $user->email }}" required>
                        </div>

                        @php
                            $nameParts = explode(' ', $user->name, 2);
                            $firstName = $nameParts[0] ?? 'Jane';
                            $lastName = $nameParts[1] ?? 'Cooper';
                        @endphp

                        <div class="edit-form-group">
                            <label>Nama Pertama</label>
                            <input type="text" name="name" class="edit-input" value="{{ $user->name }}" required>
                        </div>

                        <div class="edit-form-group">
                            <label>Nama Akhir</label>
                            <input type="text" class="edit-input" value="{{ $lastName }}">
                        </div>

                        <div class="edit-form-group">
                            <label>Tanggal Lahir</label>
                            <input type="date" name="birth_date" class="edit-input" value="{{ $user->birth_date ? Carbon\Carbon::parse($user->birth_date)->format('Y-m-d') : '1990-12-06' }}">
                        </div>

                        <div class="edit-form-group">
                            <label>Kelamin</label>
                            <select name="gender" class="edit-select">
                                <option value="Laki-Laki" {{ ($user->gender ?? 'Laki-Laki') === 'Laki-Laki' ? 'selected' : '' }}>Laki-Laki</option>
                                <option value="Perempuan" {{ ($user->gender ?? '') === 'Perempuan' ? 'selected' : '' }}>Perempuan</option>
                            </select>
                        </div>

                        <div class="edit-form-group">
                            <label>Nomor Telepon</label>
                            <input type="text" name="phone" class="edit-input" value="{{ $user->phone ?? '0987654321' }}">
                        </div>

                        <div class="edit-form-group">
                            <label>Waktu Shift</label>
                            <select name="shift_time" class="edit-select">
                                <option value="10:00:59 - 19:00:59">10:00:59 - 19:00:59</option>
                                <option value="08:00:00 - 17:00:00">08:00:00 - 17:00:00</option>
                                <option value="09:00:00 - 18:00:00">09:00:00 - 18:00:00</option>
                            </select>
                        </div>

                        <div class="edit-form-group">
                            <label>Peran</label>
                            <select name="position" class="edit-select">
                                <option value="UI/UX DESIGNER">UI/UX DESIGNER</option>
                                <option value="Administrator">Administrator</option>
                                <option value="Project Manager">Project Manager</option>
                            </select>
                        </div>

                        <div class="edit-form-group">
                            <label>Cabang</label>
                            <select name="branch" class="edit-select">
                                <option value="Hyderabad">Hyderabad</option>
                                <option value="Jakarta">Jakarta</option>
                                <option value="Solo">Solo</option>
                                <option value="Yogyakarta">Yogyakarta</option>
                            </select>
                        </div>

                        <div class="edit-form-group">
                            <label>Alamat</label>
                            <input type="text" name="address" class="edit-input" value="{{ $user->address ?? 'Madhapur, Hyderabad' }}">
                        </div>

                        <div class="edit-form-group">
                            <label>Tanggal Bergabung</label>
                            <input type="text" class="edit-input" value="{{ $user->joined_date ? Carbon\Carbon::parse($user->joined_date)->format('d-m-Y') : '25-06-2020' }}" readonly>
                        </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; margin-top: 32px;">
                        <button type="submit" class="btn-update">Perbarui</button>
                    </div>
                </form>

            @elseif ($tab === 'password')
                <!-- TAB 3: Pengaturan Password -->
                <div class="password-form-container">
                    <h3 class="tab-section-title">Pengaturan Password</h3>

                    <form method="POST" action="{{ route('admin.akun.password') }}">
                        @csrf
                        @method('PUT')

                        <div class="password-fields">
                            <div class="password-group">
                                <label>Password Lama</label>
                                <input type="password" name="current_password" class="password-input" placeholder="Masukkan Password Lama" required>
                            </div>

                            <div class="password-group">
                                <label>Password Baru</label>
                                <input type="password" name="password" class="password-input" placeholder="Masukkan Password Baru" required minlength="8">
                            </div>

                            <div class="password-group">
                                <label>Konfirmasi Password</label>
                                <input type="password" name="password_confirmation" class="password-input" placeholder="Masukan Konfirmasi Password" required minlength="8">
                            </div>
                        </div>

                        <div class="password-btn-row">
                            <a href="{{ route('admin.akun', ['tab' => 'detail']) }}" class="btn-cancel">Batal</a>
                            <button type="submit" class="btn-reset-pass">Reset Password</button>
                        </div>
                    </form>
                </div>
            @endif
        </div>
    </div>
@endsection

