@extends('layouts.admin')

@section('title', 'Karyawan · LookIn')

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

    .search-input:focus {
        border-color: var(--primary);
    }

    .search-icon {
        position: absolute;
        right: 16px;
        top: 50%;
        transform: translateY(-50%);
        color: #7E8D9F;
        pointer-events: none;
    }

    .btn-export {
        background: #0080FF;
        color: #FFFFFF;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 11px 22px;
        border-radius: var(--radius-sm);
        font-size: 14px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        text-decoration: none;
        font-family: inherit;
    }

    .btn-export:hover {
        background: #006ee0;
    }

    /* List Container */
    .karyawan-card-container {
        background: #FFFFFF;
        border-radius: var(--radius-lg);
        border: 1.5px solid #0080FF;
        padding: 30px;
        box-shadow: var(--shadow-sm);
    }

    .karyawan-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 18px 28px;
        border-radius: var(--radius-md);
        margin-bottom: 10px;
        transition: all 0.15s ease;
    }

    .karyawan-row.bg-blue {
        background: #DDF0FF;
    }

    .karyawan-row.bg-white {
        background: #FFFFFF;
        border: 1px solid #EEF4F8;
    }

    .karyawan-left {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .avatar-icon-box {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-sm);
        background: #CCD8E4;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #FFFFFF;
    }

    .karyawan-name {
        font-size: 16px;
        font-weight: 600;
        color: #1E293B;
    }

    .karyawan-action-link {
        color: #0080FF;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: color 0.15s ease;
    }

    .karyawan-action-link:hover {
        text-decoration: underline;
        color: #005bb5;
    }

    /* Pagination */
    .pagination-bar {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 16px;
        margin-top: 32px;
        font-size: 13px;
        color: #64748B;
        font-weight: 600;
    }

    .page-box {
        background: #DDF0FF;
        color: #0080FF;
        padding: 6px 14px;
        border-radius: var(--radius-sm);
        font-weight: 700;
    }

    .page-links {
        display: flex;
        align-items: center;
        gap: 8px;
        border: 1px solid #C4D9EC;
        padding: 6px 12px;
        border-radius: var(--radius-sm);
        background: #FFFFFF;
    }

    .page-links a, .page-links span {
        color: #0080FF;
        text-decoration: none;
        padding: 2px 6px;
    }

    .page-links a.active {
        font-weight: 800;
        color: #005bb5;
    }
</style>
@endsection

@section('content')
    <h1 class="page-title">Karyawan</h1>

    <div class="toolbar-row">
        <form method="GET" action="{{ route('admin.karyawan') }}" class="search-wrapper">
            <input type="text" name="search" class="search-input" placeholder="Cari Karyawan......" value="{{ $search }}" onchange="this.form.submit()">
            <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
        </form>

        <a href="{{ route('admin.karyawan.export') }}" class="btn-export">
            Export
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17l10-10M17 17V7H7"/></svg>
        </a>
    </div>

    <div class="karyawan-card-container">
        @forelse ($employees as $idx => $emp)
            <div class="karyawan-row {{ $idx % 2 == 0 ? 'bg-blue' : 'bg-white' }}">
                <div class="karyawan-left">
                    <div class="avatar-icon-box">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    </div>
                    <span class="karyawan-name">{{ $emp->name }}</span>
                </div>

                <a href="{{ route('admin.karyawan.detail', $emp->id) }}" class="karyawan-action-link">
                    Lihat detail
                </a>
            </div>
        @empty
            <div style="text-align:center; padding: 40px; color:#8FA0B5;">
                Tidak ada data karyawan ditemukan.
            </div>
        @endforelse

        <!-- Pagination -->
        <div class="pagination-bar">
            <span>Halaman</span>
            <span class="page-box">{{ $employees->perPage() }}</span>
            <div class="page-links">
                @if ($employees->onFirstPage())
                    <span style="color:#CBD5E1;">&lt;</span>
                @else
                    <a href="{{ $employees->previousPageUrl() }}">&lt;</a>
                @endif

                <a href="{{ $employees->url(1) }}" class="{{ $employees->currentPage() == 1 ? 'active' : '' }}">1</a>
                @if ($employees->lastPage() > 1)
                    <a href="{{ $employees->url(2) }}" class="{{ $employees->currentPage() == 2 ? 'active' : '' }}">2</a>
                @endif
                @if ($employees->lastPage() > 2)
                    <a href="{{ $employees->url(3) }}" class="{{ $employees->currentPage() == 3 ? 'active' : '' }}">3</a>
                @endif
                @if ($employees->lastPage() > 3)
                    <span>....</span>
                    <a href="{{ $employees->url($employees->lastPage()) }}">{{ $employees->lastPage() }}</a>
                @endif

                @if ($employees->hasMorePages())
                    <a href="{{ $employees->nextPageUrl() }}">&gt;</a>
                @else
                    <span style="color:#CBD5E1;">&gt;</span>
                @endif
            </div>
            <span class="page-box">{{ str_pad($employees->currentPage(), 2, '0', STR_PAD_LEFT) }}</span>
        </div>
    </div>
@endsection

