@extends('layouts.admin')

@section('title', 'Registrasi Karyawan · LookIn')

@section('styles')
<style>
    .page-title {
        font-size: 22px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 28px;
    }

    .form-container {
        background: #FFFFFF;
        border-radius: var(--radius-lg);
        padding: 40px;
        border: 1px solid var(--border);
        box-shadow: var(--shadow-sm);
        max-width: 1200px;
        margin: 0 auto;
    }

    .section-title {
        font-size: 16px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 20px;
    }

    .section-desc {
        font-size: 14px;
        color: #64748B;
        margin-bottom: 24px;
    }

    /* 2 Column Form Grid */
    .form-grid-2 {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px 28px;
        margin-bottom: 40px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .form-label {
        font-size: 14px;
        font-weight: 600;
        color: #334155;
    }

    .form-input {
        background: #E5E7EB;
        border: 1px solid transparent;
        border-radius: var(--radius-sm);
        padding: 14px 18px;
        font-size: 14px;
        font-family: inherit;
        color: #1E293B;
        outline: none;
        transition: all 0.2s ease;
    }

    .form-input:focus {
        background: #FFFFFF;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(0, 128, 255, 0.12);
    }

    /* 5 Angle Upload Grid */
    .upload-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 24px;
        margin-bottom: 24px;
    }

    .upload-card {
        border: 2px dashed #0080FF;
        border-radius: var(--radius-lg);
        background: #F8FBFE;
        padding: 32px 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        cursor: pointer;
        position: relative;
        min-height: 150px;
        transition: all 0.2s ease;
    }

    .upload-card:hover {
        background: #EFF6FF;
        border-color: #0066CC;
    }

    .upload-card.full-width {
        grid-column: span 1;
    }

    .upload-icon {
        color: #0080FF;
        margin-bottom: 8px;
    }

    .upload-title {
        font-size: 16px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 4px;
    }

    .upload-subtitle {
        font-size: 13px;
        font-weight: 600;
        color: #0080FF;
    }

    .file-hidden-input {
        position: absolute;
        inset: 0;
        opacity: 0;
        cursor: pointer;
        width: 100%;
        height: 100%;
    }

    .preview-image {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: var(--radius-lg);
        display: none;
    }

    .upload-card.has-file .preview-image {
        display: block;
    }

    .upload-card.has-file .upload-content {
        position: relative;
        z-index: 2;
        background: rgba(255, 255, 255, 0.85);
        padding: 6px 14px;
        border-radius: var(--radius-sm);
    }

    .warning-text {
        color: #EF4444;
        font-size: 13px;
        font-weight: 600;
        text-align: center;
        margin-top: 14px;
        margin-bottom: 24px;
    }

    .btn-submit-container {
        display: flex;
        justify-content: center;
    }

    .btn-submit-employee {
        width: 480px;
        max-width: 100%;
        padding: 14px;
        background: #0080FF;
        color: #FFFFFF;
        font-size: 15px;
        font-weight: 700;
        border: none;
        border-radius: var(--radius-sm);
        cursor: pointer;
        transition: background 0.2s ease;
        font-family: inherit;
    }

    .btn-submit-employee:hover {
        background: #006ee0;
    }

    @media (max-width: 768px) {
        .form-grid-2, .upload-grid {
            grid-template-columns: 1fr;
        }
        .form-container {
            padding: 24px 16px;
        }
    }
</style>
@endsection

@section('content')
    <h1 class="page-title">Registrasi Karyawan</h1>

    <div class="form-container">
        <form method="POST" action="{{ route('admin.registrasi-wajah.store') }}" enctype="multipart/form-data">
            @csrf

            <!-- Section 1: Informasi Karyawan -->
            <h2 class="section-title">Informasi Karyawan:</h2>

            <div class="form-grid-2">
                <div class="form-group">
                    <label class="form-label">Nama Lengkap</label>
                    <input type="text" name="name" class="form-input" required value="{{ old('name') }}">
                </div>

                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" required value="{{ old('email') }}">
                </div>

                <div class="form-group">
                    <label class="form-label">Nomor Telepon</label>
                    <input type="text" name="phone" class="form-input" value="{{ old('phone') }}">
                </div>

                <div class="form-group">
                    <label class="form-label">Divisi</label>
                    <input type="text" name="division" class="form-input" placeholder="e.g. Divisi IT" value="{{ old('division') }}">
                </div>

                <div class="form-group">
                    <label class="form-label">Jabatan</label>
                    <input type="text" name="position" class="form-input" placeholder="e.g. Programmer" value="{{ old('position') }}">
                </div>

                <div class="form-group">
                    <label class="form-label">Alamat</label>
                    <input type="text" name="address" class="form-input" value="{{ old('address') }}">
                </div>

                <div class="form-group">
                    <label class="form-label">Username Akun Karyawan</label>
                    <input type="text" name="username" class="form-input" value="{{ old('username') }}">
                </div>

                <div class="form-group">
                    <label class="form-label">Password Akun Karyawan</label>
                    <input type="password" name="password" class="form-input" required minlength="6">
                </div>
            </div>

            <!-- Section 2: Upload Foto Wajah -->
            <h2 class="section-title">Upload Foto Wajah Karyawan</h2>
            <p class="section-desc">Unggah Foto Wajah Dari Beberapa Sudut Untuk Proses Registrasi.</p>

            <div class="upload-grid">
                <!-- 1. Depan -->
                <div class="upload-card" onclick="document.getElementById('inputDepan').click()">
                    <img id="previewDepan" class="preview-image" alt="Preview Depan">
                    <div class="upload-content">
                        <svg class="upload-icon" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/><path d="M12 9v6M9 12h6"/></svg>
                        <div class="upload-title">Depan</div>
                        <div class="upload-subtitle">+ Upload Foto</div>
                    </div>
                    <input type="file" id="inputDepan" name="face_depan" class="file-hidden-input" accept="image/*" onchange="previewFace(this, 'previewDepan')">
                </div>

                <!-- 2. Samping Kiri -->
                <div class="upload-card" onclick="document.getElementById('inputKiri').click()">
                    <img id="previewKiri" class="preview-image" alt="Preview Kiri">
                    <div class="upload-content">
                        <svg class="upload-icon" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/><path d="M12 9v6M9 12h6"/></svg>
                        <div class="upload-title">Samping Kiri</div>
                        <div class="upload-subtitle">+ Upload Foto</div>
                    </div>
                    <input type="file" id="inputKiri" name="face_samping_kiri" class="file-hidden-input" accept="image/*" onchange="previewFace(this, 'previewKiri')">
                </div>

                <!-- 3. Samping Kanan -->
                <div class="upload-card" onclick="document.getElementById('inputKanan').click()">
                    <img id="previewKanan" class="preview-image" alt="Preview Kanan">
                    <div class="upload-content">
                        <svg class="upload-icon" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/><path d="M12 9v6M9 12h6"/></svg>
                        <div class="upload-title">Samping Kanan</div>
                        <div class="upload-subtitle">+ Upload Foto</div>
                    </div>
                    <input type="file" id="inputKanan" name="face_samping_kanan" class="file-hidden-input" accept="image/*" onchange="previewFace(this, 'previewKanan')">
                </div>

                <!-- 4. Sedikit Menunduk -->
                <div class="upload-card" onclick="document.getElementById('inputMenunduk').click()">
                    <img id="previewMenunduk" class="preview-image" alt="Preview Menunduk">
                    <div class="upload-content">
                        <svg class="upload-icon" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/><path d="M12 9v6M9 12h6"/></svg>
                        <div class="upload-title">Sedikit Menunduk</div>
                        <div class="upload-subtitle">+ Upload Foto</div>
                    </div>
                    <input type="file" id="inputMenunduk" name="face_menunduk" class="file-hidden-input" accept="image/*" onchange="previewFace(this, 'previewMenunduk')">
                </div>

                <!-- 5. Sedikit Menengadah -->
                <div class="upload-card full-width" onclick="document.getElementById('inputMenengadah').click()">
                    <img id="previewMenengadah" class="preview-image" alt="Preview Menengadah">
                    <div class="upload-content">
                        <svg class="upload-icon" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/><path d="M12 9v6M9 12h6"/></svg>
                        <div class="upload-title">Sedikit Menengadah</div>
                        <div class="upload-subtitle">+ Upload Foto</div>
                    </div>
                    <input type="file" id="inputMenengadah" name="face_menengadah" class="file-hidden-input" accept="image/*" onchange="previewFace(this, 'previewMenengadah')">
                </div>
            </div>

            <p class="warning-text">Pastikan Wajah terlihat jelas dan pencahayaan cukup!</p>

            <div class="btn-submit-container">
                <button type="submit" class="btn-submit-employee">
                    Daftarkan Karyawan
                </button>
            </div>
        </form>
    </div>
@endsection

@section('scripts')
<script>
    function previewFace(input, previewId) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.getElementById(previewId);
                img.src = e.target.result;
                input.parentElement.classList.add('has-file');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
@endsection

