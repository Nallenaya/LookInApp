@extends('layouts.admin')

@section('title', 'Detail Karyawan · ' . $employee->name)

@section('styles')
<style>
    .page-title {
        font-size: 22px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 24px;
    }

    .toolbar-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
        gap: 20px;
        flex-wrap: wrap;
    }

    .search-wrapper {
        position: relative;
        flex: 1;
        max-width: 480px;
    }

    .search-input {
        width: 100%;
        padding: 12px 44px 12px 18px;
        border: 1px solid #C4D9EC;
        border-radius: var(--radius-md);
        font-size: 14px;
        background: #FFFFFF;
        color: #334155;
        outline: none;
        font-family: inherit;
    }

    .search-icon {
        position: absolute;
        right: 16px;
        top: 50%;
        transform: translateY(-50%);
        color: #7E8D9F;
        pointer-events: none;
    }

    .action-btn-group {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .btn-edit {
        background: #FF8C00;
        color: #FFFFFF;
        padding: 10px 24px;
        border-radius: var(--radius-sm);
        font-size: 14px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        font-family: inherit;
    }

    .btn-delete {
        background: #FF3B30;
        color: #FFFFFF;
        padding: 10px 20px;
        border-radius: var(--radius-sm);
        font-size: 14px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        font-family: inherit;
    }

    .btn-export {
        background: #0080FF;
        color: #FFFFFF;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 10px 20px;
        border-radius: var(--radius-sm);
        font-size: 14px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        text-decoration: none;
        font-family: inherit;
    }

    /* Detail Card */
    .detail-card {
        background: #FFFFFF;
        border-radius: var(--radius-lg);
        border: 1.5px solid #0080FF;
        padding: 36px;
        box-shadow: var(--shadow-sm);
    }

    .detail-card-title {
        font-size: 18px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 28px;
    }

    .employee-profile-header {
        display: flex;
        align-items: center;
        gap: 28px;
        margin-bottom: 36px;
    }

    .large-avatar-box {
        width: 90px;
        height: 100px;
        border-radius: var(--radius-sm);
        border: 1px solid #C4D9EC;
        background: #F3F8FC;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #94A3B8;
        flex-shrink: 0;
    }

    .profile-meta h2 {
        font-size: 26px;
        font-weight: 800;
        color: #1E293B;
        letter-spacing: -0.5px;
        margin-bottom: 4px;
    }

    .profile-meta .emp-code {
        font-size: 14px;
        color: #64748B;
        font-weight: 500;
        margin-bottom: 2px;
    }

    .profile-meta .emp-job {
        font-size: 14px;
        color: #64748B;
        font-weight: 500;
    }

    /* Form Fields Grid */
    .fields-grid-2 {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px 32px;
        margin-bottom: 40px;
    }

    .field-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .field-label {
        font-size: 14px;
        font-weight: 600;
        color: #334155;
    }

    .field-input {
        background: #E5E7EB;
        border: 1px solid transparent;
        border-radius: var(--radius-sm);
        padding: 14px 18px;
        font-size: 14px;
        font-family: inherit;
        color: #1E293B;
        outline: none;
    }

    .field-input:focus {
        background: #FFFFFF;
        border-color: #0080FF;
    }

    /* Face Section */
    .face-section-title {
        font-size: 18px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 24px;
    }

    .face-cards-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 24px;
    }

    .face-card {
        background: #EAEFF4;
        border-radius: var(--radius-md);
        padding: 16px;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
    }

    .face-photo-wrapper {
        width: 100%;
        height: 180px;
        border-radius: var(--radius-md);
        overflow: hidden;
        margin-bottom: 12px;
        background: #CBD5E1;
        position: relative;
    }

    .face-photo-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .face-photo-title {
        font-size: 14px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 4px;
    }

    .face-status-badge {
        font-size: 12px;
        font-weight: 700;
        color: #10B981;
        margin-bottom: 6px;
    }

    .face-change-link {
        font-size: 12px;
        font-weight: 600;
        color: #0080FF;
        cursor: pointer;
        text-decoration: none;
    }

    .face-change-link:hover {
        text-decoration: underline;
    }

    @media (max-width: 900px) {
        .face-cards-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        .fields-grid-2 {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 600px) {
        .face-cards-grid {
            grid-template-columns: 1fr;
        }
    }
</style>
@endsection

@section('content')
    <h1 class="page-title">Karyawan</h1>

    <div class="toolbar-row">
        <form method="GET" action="{{ route('admin.karyawan') }}" class="search-wrapper">
            <input type="text" name="search" class="search-input" placeholder="Cari Karyawan......">
            <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
        </form>

        <div class="action-btn-group">
            <button type="button" class="btn-edit" id="toggleEditBtn" onclick="toggleEditMode()">Edit</button>

            <form method="POST" action="{{ route('admin.karyawan.delete', $employee->id) }}" onsubmit="return confirm('Apakah Anda yakin ingin menghapus karyawan ini?')">
                @csrf
                @method('DELETE')
                <button type="submit" class="btn-delete">Hapus karyawan</button>
            </form>

            <a href="{{ route('admin.karyawan.export') }}" class="btn-export">
                Export
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17l10-10M17 17V7H7"/></svg>
            </a>
        </div>
    </div>

    <!-- Detail Karyawan Container -->
    <div class="detail-card">
        <h3 class="detail-card-title">Detail Karyawan</h3>

        <div class="employee-profile-header">
            <div class="large-avatar-box">
                <svg width="50" height="50" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
            </div>
            <div class="profile-meta">
                <h2>{{ $employee->name }}</h2>
                <div class="emp-code">{{ $employee->employee_id ?? 'K-086' }} - {{ $employee->division ?? 'Divisi IT' }}</div>
                <div class="emp-job">{{ $employee->position ?? 'Programmer' }}</div>
            </div>
        </div>

        <form method="POST" action="{{ route('admin.karyawan.update', $employee->id) }}" id="updateEmployeeForm" enctype="multipart/form-data">
            @csrf
            @method('PUT')

            <div class="fields-grid-2">
                <div class="field-group">
                    <label class="field-label">Nama Lengkap</label>
                    <input type="text" name="name" class="field-input" value="{{ $employee->name }}" readonly>
                </div>

                <div class="field-group">
                    <label class="field-label">Email</label>
                    <input type="email" name="email" class="field-input" value="{{ $employee->email }}" readonly>
                </div>

                <div class="field-group">
                    <label class="field-label">Nomor Telepon</label>
                    <input type="text" name="phone" class="field-input" value="{{ $employee->phone ?? '081234567890' }}" readonly>
                </div>

                <div class="field-group">
                    <label class="field-label">Divisi</label>
                    <input type="text" name="division" class="field-input" value="{{ $employee->division ?? 'IT' }}" readonly>
                </div>

                <div class="field-group">
                    <label class="field-label">Jabatan</label>
                    <input type="text" name="position" class="field-input" value="{{ $employee->position ?? 'Programmer' }}" readonly>
                </div>

                <div class="field-group">
                    <label class="field-label">Alamat</label>
                    <input type="text" name="address" class="field-input" value="{{ $employee->address ?? 'Solo' }}" readonly>
                </div>

                <div class="field-group">
                    <label class="field-label">Username Akun Karyawan</label>
                    <input type="text" class="field-input" value="{{ explode('@', $employee->email)[0] }}" readonly>
                </div>

                <div class="field-group">
                    <label class="field-label">Password Akun Karyawan</label>
                    <input type="password" name="password" class="field-input" value="********" readonly placeholder="Masukkan password baru untuk mengubah">
                </div>
            </div>

            <!-- Data Wajah Terdaftar -->
            <h3 class="face-section-title">Data Wajah Terdaftar</h3>

            <div class="face-cards-grid">
                <!-- 1. Depan -->
                <div class="face-card">
                    <div class="face-photo-wrapper">
                        <img id="imgDepan" src="{{ $employee->face_depan ? asset($employee->face_depan) : asset('assets/design/face-depan.png') }}" alt="Foto Depan">
                    </div>
                    <div class="face-photo-title">Foto Depan</div>
                    <div class="face-status-badge">Terdaftar</div>
                    <label for="changeDepan" class="face-change-link">Ganti Foto</label>
                    <input type="file" id="changeDepan" name="face_depan" style="display:none;" accept="image/*" onchange="previewImg(this, 'imgDepan')">
                </div>

                <!-- 2. Samping Kiri -->
                <div class="face-card">
                    <div class="face-photo-wrapper">
                        <img id="imgKiri" src="{{ $employee->face_samping_kiri ? asset($employee->face_samping_kiri) : asset('assets/design/face-kiri.png') }}" alt="Samping Kiri">
                    </div>
                    <div class="face-photo-title">Samping Kiri</div>
                    <div class="face-status-badge">Terdaftar</div>
                    <label for="changeKiri" class="face-change-link">Ganti Foto</label>
                    <input type="file" id="changeKiri" name="face_samping_kiri" style="display:none;" accept="image/*" onchange="previewImg(this, 'imgKiri')">
                </div>

                <!-- 3. Samping Kanan -->
                <div class="face-card">
                    <div class="face-photo-wrapper">
                        <img id="imgKanan" src="{{ $employee->face_samping_kanan ? asset($employee->face_samping_kanan) : asset('assets/design/face-kanan.png') }}" alt="Samping Kanan">
                    </div>
                    <div class="face-photo-title">Samping Kanan</div>
                    <div class="face-status-badge">Terdaftar</div>
                    <label for="changeKanan" class="face-change-link">Ganti Foto</label>
                    <input type="file" id="changeKanan" name="face_samping_kanan" style="display:none;" accept="image/*" onchange="previewImg(this, 'imgKanan')">
                </div>

                <!-- 4. Sedikit Menunduk -->
                <div class="face-card">
                    <div class="face-photo-wrapper">
                        <img id="imgMenunduk" src="{{ $employee->face_menunduk ? asset($employee->face_menunduk) : asset('assets/design/face-menunduk.png') }}" alt="Sedikit Menunduk">
                    </div>
                    <div class="face-photo-title">Sedikit Menunduk</div>
                    <div class="face-status-badge">Terdaftar</div>
                    <label for="changeMenunduk" class="face-change-link">Ganti Foto</label>
                    <input type="file" id="changeMenunduk" name="face_menunduk" style="display:none;" accept="image/*" onchange="previewImg(this, 'imgMenunduk')">
                </div>

                <!-- 5. Sedikit Menengadah -->
                <div class="face-card">
                    <div class="face-photo-wrapper">
                        <img id="imgMenengadah" src="{{ $employee->face_menengadah ? asset($employee->face_menengadah) : asset('assets/design/face-menengadah.png') }}" alt="Sedikit Mengadah">
                    </div>
                    <div class="face-photo-title">Sedikit Mengadah</div>
                    <div class="face-status-badge">Terdaftar</div>
                    <label for="changeMenengadah" class="face-change-link">Ganti Foto</label>
                    <input type="file" id="changeMenengadah" name="face_menengadah" style="display:none;" accept="image/*" onchange="previewImg(this, 'imgMenengadah')">
                </div>
            </div>

            <div id="saveBtnContainer" style="display: none; justify-content: center; margin-top: 32px;">
                <button type="submit" class="btn btn-primary" style="padding: 12px 40px; font-size: 15px;">
                    Simpan Perubahan
                </button>
            </div>
        </form>
    </div>
@endsection

@section('scripts')
<script>
    let isEditing = false;
    function toggleEditMode() {
        isEditing = !isEditing;
        const inputs = document.querySelectorAll('.field-input');
        const saveBtn = document.getElementById('saveBtnContainer');
        const editBtn = document.getElementById('toggleEditBtn');

        inputs.forEach(input => {
            if (isEditing) {
                input.removeAttribute('readonly');
                input.style.background = '#FFFFFF';
                input.style.borderColor = '#0080FF';
            } else {
                input.setAttribute('readonly', true);
                input.style.background = '#E5E7EB';
                input.style.borderColor = 'transparent';
            }
        });

        if (isEditing) {
            saveBtn.style.display = 'flex';
            editBtn.textContent = 'Batal Edit';
            editBtn.style.background = '#64748B';
        } else {
            saveBtn.style.display = 'none';
            editBtn.textContent = 'Edit';
            editBtn.style.background = '#FF8C00';
        }
    }

    function previewImg(input, targetId) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById(targetId).src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
            document.getElementById('saveBtnContainer').style.display = 'flex';
        }
    }
</script>
@endsection

