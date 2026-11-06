@extends('layouts.admin')

@section('title', 'Monitoring · LookIn')

@section('styles')
<style>
    .page-title {
        font-size: 22px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 24px;
    }

    /* 6 Metric Cards */
    .monitoring-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 36px;
    }

    .monitoring-card {
        border-radius: var(--radius-lg);
        padding: 24px 28px;
        color: #FFFFFF;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 140px;
        box-shadow: 0 4px 14px rgba(0,0,0,0.06);
    }

    .monitoring-card .card-title {
        font-size: 20px;
        font-weight: 700;
        letter-spacing: -0.3px;
    }

    .monitoring-card .card-value {
        font-size: 48px;
        font-weight: 800;
        line-height: 1;
        letter-spacing: -1px;
    }

    /* Specific solid background colors from design */
    .card-bekerja { background: #00D26A; }
    .card-belum   { background: #FF1E1E; }
    .card-cuti    { background: #EFE000; color: #182230; }
    .card-izin    { background: #FF7A00; }
    .card-sakit   { background: #B800FF; }
    .card-lembur  { background: #0A0E5C; }

    /* Activity Section */
    .activity-section {
        margin-top: 40px;
    }

    .activity-title {
        font-size: 20px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 18px;
    }

    .search-bar-wrapper {
        position: relative;
        margin-bottom: 24px;
        width: 100%;
    }

    .search-input {
        width: 100%;
        padding: 14px 44px 14px 20px;
        border: 1px solid #C4D9EC;
        border-radius: var(--radius-md);
        font-size: 14px;
        background: #FFFFFF;
        color: #334155;
        outline: none;
        font-family: inherit;
        transition: border-color 0.2s ease;
    }

    .search-input:focus {
        border-color: var(--primary);
    }

    .search-icon {
        position: absolute;
        right: 18px;
        top: 50%;
        transform: translateY(-50%);
        color: #7E8D9F;
        pointer-events: none;
    }

    /* Table & Rows */
    .table-container {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0 10px;
    }

    .table-header {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr;
        padding: 0 30px 10px 30px;
        font-size: 13px;
        font-weight: 700;
        color: #1E293B;
        letter-spacing: 0.5px;
    }

    .table-header .header-col.center {
        text-align: center;
    }

    .activity-row {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr;
        align-items: center;
        padding: 14px 30px;
        border-radius: var(--radius-md);
        margin-bottom: 8px;
        transition: transform 0.15s ease;
    }

    .activity-row.bg-light-blue {
        background: #DDF0FF;
    }

    .activity-row.bg-white {
        background: #FFFFFF;
        border: 1px solid #EEF4F8;
    }

    .employee-info-cell {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .employee-avatar-circle {
        width: 44px;
        height: 44px;
        border-radius: 50%;
        background: #CCD8E4;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #FFFFFF;
        flex-shrink: 0;
    }

    .employee-meta h4 {
        font-size: 15px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 3px;
    }

    .employee-meta span {
        font-size: 12px;
        font-weight: 600;
        color: #64748B;
    }

    .time-cell {
        font-size: 15px;
        font-weight: 700;
        color: #1E293B;
        text-align: center;
    }

    .status-cell {
        display: flex;
        justify-content: center;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 8px 24px;
        border-radius: 30px;
        font-size: 13px;
        font-weight: 700;
        color: #FFFFFF;
        min-width: 110px;
    }

    .badge-bekerja { background: #00D26A; }
    .badge-belum   { background: #FF1E1E; }
    .badge-cuti    { background: #EFE000; color: #182230; }
    .badge-izin    { background: #FF7A00; }
    .badge-sakit   { background: #B800FF; }
    .badge-lembur  { background: #0A0E5C; }
    .badge-selesai { background: #64748B; }

    @media (max-width: 1024px) {
        .monitoring-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 640px) {
        .monitoring-grid {
            grid-template-columns: 1fr;
        }
        .table-header, .activity-row {
            grid-template-columns: 1fr 80px 100px;
            padding: 12px 14px;
        }
    }
</style>
@endsection

@section('content')
    <h1 class="page-title">Monitoring</h1>

    <!-- 6 KPI Badges -->
    <div class="monitoring-grid">
        <div class="monitoring-card card-bekerja">
            <span class="card-title">Sedang Bekerja</span>
            <span class="card-value">{{ $displayBekerja }}</span>
        </div>

        <div class="monitoring-card card-belum">
            <span class="card-title">Belum Mulai</span>
            <span class="card-value">{{ $displayBelum }}</span>
        </div>

        <div class="monitoring-card card-cuti">
            <span class="card-title">Cuti</span>
            <span class="card-value">{{ $displayCuti }}</span>
        </div>

        <div class="monitoring-card card-izin">
            <span class="card-title">Izin</span>
            <span class="card-value">{{ $displayIzin }}</span>
        </div>

        <div class="monitoring-card card-sakit">
            <span class="card-title">Sakit</span>
            <span class="card-value">{{ $displaySakit }}</span>
        </div>

        <div class="monitoring-card card-lembur">
            <span class="card-title">Lembur</span>
            <span class="card-value">{{ $displayLembur }}</span>
        </div>
    </div>

    <!-- Activity Section -->
    <div class="activity-section">
        <h2 class="activity-title">Daftar Aktivitas Karyawan</h2>

        <div class="search-bar-wrapper">
            <input type="text" id="employeeSearch" class="search-input" placeholder="Cari Karyawan......" onkeyup="filterActivities()">
            <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
        </div>

        <div class="table-header">
            <div class="header-col">KARYAWAN</div>
            <div class="header-col center">MULAI KERJA</div>
            <div class="header-col center">STATUS</div>
        </div>

        <div id="activityList">
            @forelse ($activities as $idx => $act)
                <div class="activity-row {{ $idx % 2 == 0 ? 'bg-light-blue' : 'bg-white' }}" data-name="{{ strtolower($act['user']->name) }} {{ strtolower($act['user']->employee_id ?? '') }}">
                    <div class="employee-info-cell">
                        <div class="employee-avatar-circle">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                        </div>
                        <div class="employee-meta">
                            <h4>{{ $act['user']->name }}</h4>
                            <span>{{ $act['user']->employee_id ?? 'KRY001' }}</span>
                        </div>
                    </div>

                    <div class="time-cell">
                        {{ $act['jam_mulai'] }}
                    </div>

                    <div class="status-cell">
                        @php
                            $badgeClass = match($act['status']) {
                                'Bekerja' => 'badge-bekerja',
                                'Belum Mulai' => 'badge-belum',
                                'Cuti' => 'badge-cuti',
                                'Izin' => 'badge-izin',
                                'Sakit' => 'badge-sakit',
                                'Lembur' => 'badge-lembur',
                                default => 'badge-selesai',
                            };
                        @endphp
                        <span class="status-badge {{ $badgeClass }}">
                            {{ $act['status'] }}
                        </span>
                    </div>
                </div>
            @empty
                <div style="text-align:center; padding: 40px; color:#8FA0B5;">
                    Belum ada data aktivitas karyawan.
                </div>
            @endforelse
        </div>
    </div>
@endsection

@section('scripts')
<script>
    function filterActivities() {
        const query = document.getElementById('employeeSearch').value.toLowerCase();
        const rows = document.querySelectorAll('#activityList .activity-row');
        rows.forEach(row => {
            const text = row.getAttribute('data-name');
            if (text.includes(query)) {
                row.style.display = 'grid';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
@endsection

