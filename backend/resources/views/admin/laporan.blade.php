@extends('layouts.admin')

@section('title', 'Laporan · LookIn')

@section('styles')
<style>
    .page-header-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
        flex-wrap: wrap;
        gap: 16px;
    }

    .page-title {
        font-size: 22px;
        font-weight: 700;
        color: #1E293B;
    }

    .filter-form {
        display: flex;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
    }

    .filter-label {
        font-size: 14px;
        font-weight: 600;
        color: #334155;
    }

    .date-input-wrapper {
        display: flex;
        align-items: center;
        gap: 8px;
        background: #FFFFFF;
        border: 1px solid #C4D9EC;
        border-radius: var(--radius-sm);
        padding: 8px 14px;
        font-size: 13px;
        font-weight: 500;
        color: #64748B;
    }

    .date-input-wrapper input {
        border: none;
        outline: none;
        font-family: inherit;
        font-size: 13px;
        color: #334155;
        background: transparent;
    }

    .btn-export {
        background: #0080FF;
        color: #FFFFFF;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 9px 18px;
        border-radius: var(--radius-sm);
        font-size: 13px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        text-decoration: none;
        font-family: inherit;
    }

    .btn-export:hover {
        background: #006ee0;
    }

    /* Ringkasan Periode */
    .summary-card {
        background: #FFFFFF;
        border-radius: var(--radius-lg);
        padding: 30px;
        border: 1px solid var(--border);
        box-shadow: var(--shadow-sm);
        margin-bottom: 36px;
    }

    .summary-title {
        font-size: 18px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 20px;
    }

    .summary-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 16px;
    }

    .summary-tile {
        background: #F3F8FC;
        border-radius: var(--radius-md);
        padding: 20px 24px;
    }

    .summary-tile-label {
        font-size: 13px;
        font-weight: 600;
        color: #64748B;
        margin-bottom: 8px;
    }

    .summary-tile-value {
        font-size: 32px;
        font-weight: 800;
        color: #0080FF;
        letter-spacing: -0.5px;
    }

    /* Preview Section */
    .preview-section {
        margin-top: 30px;
    }

    .preview-title {
        font-size: 18px;
        font-weight: 700;
        color: #1E293B;
        margin-bottom: 16px;
    }

    .preview-header {
        display: grid;
        grid-template-columns: 2.2fr 1.2fr 1fr 1fr 1fr 1.2fr;
        padding: 0 24px 12px 24px;
        font-size: 12px;
        font-weight: 700;
        color: #1E293B;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }

    .preview-header .center {
        text-align: center;
    }

    .preview-row {
        display: grid;
        grid-template-columns: 2.2fr 1.2fr 1fr 1fr 1fr 1.2fr;
        align-items: center;
        padding: 14px 24px;
        margin-bottom: 6px;
        border-radius: var(--radius-sm);
    }

    .preview-row.bg-blue {
        background: #DDF0FF;
    }

    .preview-row.bg-gray {
        background: #ECEFF3;
    }

    .employee-cell {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .emp-avatar {
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

    .emp-name {
        font-size: 15px;
        font-weight: 700;
        color: #1E293B;
    }

    .metric-cell {
        font-size: 14px;
        font-weight: 600;
        color: #1E293B;
        text-align: center;
    }

    @media (max-width: 900px) {
        .summary-grid {
            grid-template-columns: 1fr;
        }
        .preview-header, .preview-row {
            grid-template-columns: 2fr 1fr 1fr 1fr;
        }
        .col-hide-mobile {
            display: none;
        }
    }
</style>
@endsection

@section('content')
    <div class="page-header-row">
        <h1 class="page-title">Laporan</h1>

        <form method="GET" action="{{ route('admin.laporan') }}" class="filter-form">
            <span class="filter-label">Show Entries</span>

            <div class="date-input-wrapper">
                <span>From:</span>
                <input type="date" name="from" value="{{ $fromDate }}">
            </div>

            <div class="date-input-wrapper">
                <span>To:</span>
                <input type="date" name="to" value="{{ $toDate }}">
            </div>

            <button type="submit" class="btn btn-primary" style="padding: 9px 18px; font-size: 13px;">
                Tampilkan Laporan
            </button>

            <a href="{{ route('admin.laporan.export', ['from' => $fromDate, 'to' => $toDate]) }}" class="btn-export">
                Export
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17l10-10M17 17V7H7"/></svg>
            </a>
        </form>
    </div>

    <!-- Ringkasan Periode Card -->
    <div class="summary-card">
        <h2 class="summary-title">Ringkasan Periode</h2>
        <div class="summary-grid">
            <div class="summary-tile">
                <div class="summary-tile-label">Total Jam Kerja</div>
                <div class="summary-tile-value">{{ $totalWorkHours }} Jam</div>
            </div>

            <div class="summary-tile">
                <div class="summary-tile-label">Total Jam Istirahat</div>
                <div class="summary-tile-value">{{ $totalBreakHours }} Jam</div>
            </div>

            <div class="summary-tile">
                <div class="summary-tile-label">Tepat Waktu</div>
                <div class="summary-tile-value">{{ $onTimeRate }}%</div>
            </div>

            <div class="summary-tile">
                <div class="summary-tile-label">Total Keterlambatan</div>
                <div class="summary-tile-value">{{ $totalLateCount }} Kali</div>
            </div>
        </div>
    </div>

    <!-- Preview Table -->
    <div class="preview-section">
        <h2 class="preview-title">Preview</h2>

        <div class="preview-header">
            <div>KARYAWAN</div>
            <div class="center">JAM KERJA</div>
            <div class="center">CUTI</div>
            <div class="center">IZIN</div>
            <div class="center col-hide-mobile">SAKIT</div>
            <div class="center col-hide-mobile">LEMBUR</div>
        </div>

        @foreach ($reportList as $idx => $item)
            <div class="preview-row {{ $idx % 2 == 0 ? 'bg-blue' : 'bg-gray' }}">
                <div class="employee-cell">
                    <div class="emp-avatar">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    </div>
                    <span class="emp-name">{{ $item['user']->name }}</span>
                </div>

                <div class="metric-cell">{{ $item['jam_kerja'] }}</div>
                <div class="metric-cell">{{ $item['cuti'] }}</div>
                <div class="metric-cell">{{ $item['izin'] }}</div>
                <div class="metric-cell col-hide-mobile">{{ $item['sakit'] }}</div>
                <div class="metric-cell col-hide-mobile">{{ $item['lembur'] }}</div>
            </div>
        @endforeach
    </div>
@endsection

