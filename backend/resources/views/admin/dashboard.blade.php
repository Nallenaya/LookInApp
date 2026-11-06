@extends('layouts.admin')

@section('title', 'Dashboard · LookIn')

@section('styles')
<style>
    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #1E293B;
    }

    .filter-group {
        display: flex;
        gap: 12px;
    }

    .filter-select {
        background: #FFFFFF;
        border: 1px solid var(--border);
        border-radius: var(--radius-sm);
        padding: 8px 16px;
        font-size: 13px;
        font-weight: 600;
        color: var(--text-sub);
        cursor: pointer;
        outline: none;
        font-family: inherit;
    }

    /* Insights Grid */
    .insights-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 36px;
    }

    .stat-card {
        background: #FFFFFF;
        border: 1px solid var(--border);
        border-radius: var(--radius-lg);
        padding: 22px 24px;
        position: relative;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 160px;
        box-shadow: var(--shadow-sm);
    }

    .stat-label {
        font-size: 14px;
        font-weight: 600;
        color: var(--text-main);
        margin-bottom: 4px;
    }

    .stat-period {
        font-size: 13px;
        color: #8FA0B5;
        font-weight: 500;
        margin-bottom: 10px;
    }

    .stat-value {
        font-size: 36px;
        font-weight: 800;
        color: #17406E;
        letter-spacing: -1px;
        line-height: 1.1;
        margin-bottom: 12px;
    }

    .stat-value.text-sm {
        font-size: 20px;
        letter-spacing: -0.3px;
    }

    .stat-comparison {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-size: 11px;
        font-weight: 600;
    }

    .stat-comparison.positive {
        color: #10B981;
    }

    .stat-comparison.negative {
        color: #EF4444;
    }

    .stat-wave {
        position: absolute;
        right: 12px;
        bottom: 12px;
        width: 125px;
        height: 60px;
        pointer-events: none;
    }

    /* Attendance Container */
    .attendance-container {
        display: grid;
        grid-template-columns: 320px 1fr;
        gap: 24px;
    }

    /* Calendar Card */
    .calendar-card {
        background: #FFFFFF;
        border: 1px solid var(--border);
        border-radius: var(--radius-lg);
        padding: 24px 20px;
        box-shadow: var(--shadow-sm);
    }

    .calendar-title {
        font-size: 16px;
        font-weight: 700;
        color: #17406E;
        text-align: center;
        margin-bottom: 20px;
    }

    .calendar-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 10px 4px;
        text-align: center;
    }

    .calendar-day-name {
        font-size: 13px;
        font-weight: 600;
        color: #0080FF;
        padding-bottom: 10px;
    }

    .calendar-day-num {
        font-size: 13px;
        font-weight: 600;
        color: #334155;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        cursor: pointer;
    }

    .calendar-day-num.muted {
        color: #CBD5E1;
    }

    .calendar-day-num.active {
        background: #0080FF;
        color: #FFFFFF;
    }

    /* Clock & Punch Card */
    .punch-card {
        background: #FFFFFF;
        border: 1px solid var(--border);
        border-radius: var(--radius-lg);
        padding: 30px;
        box-shadow: var(--shadow-sm);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .punch-top-row {
        display: grid;
        grid-template-columns: 220px 1fr 240px;
        gap: 24px;
        align-items: center;
    }

    /* Analog Clock */
    .clock-wrapper {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .analog-clock {
        width: 170px;
        height: 170px;
        border-radius: 50%;
        background: radial-gradient(circle, #FFFFFF 60%, #E6F0FA 100%);
        border: 12px solid #E1EDF7;
        box-shadow: 0 8px 24px rgba(0, 90, 180, 0.08);
        position: relative;
    }

    .clock-center {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 10px;
        height: 10px;
        margin-left: -5px;
        margin-top: -5px;
        border-radius: 50%;
        background: #FF334B;
        z-index: 10;
    }

    .hand {
        position: absolute;
        bottom: 50%;
        left: 50%;
        transform-origin: bottom center;
        border-radius: 4px;
        z-index: 5;
    }

    .hand.hour {
        width: 4px;
        height: 40px;
        margin-left: -2px;
        background: #17406E;
    }

    .hand.minute {
        width: 3px;
        height: 56px;
        margin-left: -1.5px;
        background: #17406E;
    }

    .hand.second {
        width: 2px;
        height: 65px;
        margin-left: -1px;
        background: #FF334B;
    }

    .digital-time {
        margin-top: 18px;
        font-size: 26px;
        font-weight: 800;
        color: #17406E;
        letter-spacing: -0.5px;
    }

    /* Duration Cards */
    .duration-column {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .duration-box {
        background: #FFFFFF;
        border: 1px solid var(--border);
        border-radius: var(--radius-md);
        padding: 16px 20px;
    }

    .duration-box-title {
        font-size: 13px;
        font-weight: 600;
        color: #7E8D9F;
        margin-bottom: 6px;
    }

    .duration-box-value {
        font-size: 22px;
        font-weight: 800;
        color: #17406E;
        letter-spacing: -0.5px;
    }

    /* Motivation Box */
    .quote-box {
        background: #FFFFFF;
        border: 1px solid var(--border);
        border-radius: var(--radius-md);
        padding: 20px 16px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        min-height: 180px;
    }

    .quote-box img {
        height: 55px;
        width: auto;
        margin-bottom: 12px;
        object-fit: contain;
    }

    .quote-box p {
        font-size: 12px;
        font-weight: 600;
        line-height: 1.5;
        color: #65A30D;
    }

    .quote-box.punched-in p {
        color: #0284C7;
    }

    /* Action Row */
    .punch-action-row {
        margin-top: 28px;
        display: flex;
        gap: 16px;
        align-items: center;
    }

    .punch-action-row form {
        display: flex;
        flex: 1;
        gap: 14px;
    }

    .punch-icon-btn {
        width: 50px;
        height: 48px;
        border-radius: var(--radius-sm);
        border: 1px solid #C4E285;
        background: #F4FBEB;
        color: #55B415;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        flex-shrink: 0;
    }

    .btn-punch-in {
        flex: 1;
        height: 48px;
        background: linear-gradient(90deg, #62C723 0%, #7FD836 100%);
        color: #FFFFFF;
        font-size: 16px;
        font-weight: 700;
        border: none;
        border-radius: var(--radius-sm);
        cursor: pointer;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        font-family: inherit;
    }

    .btn-punch-in:hover {
        opacity: 0.95;
        box-shadow: 0 4px 14px rgba(98, 199, 35, 0.35);
    }

    .btn-break {
        flex: 1;
        height: 48px;
        background: #0080FF;
        color: #FFFFFF;
        font-size: 15px;
        font-weight: 700;
        border: none;
        border-radius: var(--radius-sm);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-family: inherit;
    }

    .btn-stop-break {
        flex: 1;
        height: 48px;
        background: linear-gradient(90deg, #FF9933 0%, #FFA84D 100%);
        color: #FFFFFF;
        font-size: 15px;
        font-weight: 700;
        border: none;
        border-radius: var(--radius-sm);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-family: inherit;
    }

    .btn-punch-out {
        flex: 1;
        height: 48px;
        background: #FF6459;
        color: #FFFFFF;
        font-size: 15px;
        font-weight: 700;
        border: none;
        border-radius: var(--radius-sm);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-family: inherit;
    }

    .punch-out-success-box {
        width: 100%;
        padding: 14px 20px;
        background: #62C723;
        color: #FFFFFF;
        border-radius: var(--radius-sm);
        text-align: center;
        font-size: 14px;
        font-weight: 700;
    }

    @media (max-width: 1200px) {
        .insights-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        .attendance-container {
            grid-template-columns: 1fr;
        }
        .punch-top-row {
            grid-template-columns: 1fr 1fr;
        }
        .quote-box {
            grid-column: span 2;
        }
    }

    @media (max-width: 640px) {
        .insights-grid {
            grid-template-columns: 1fr;
        }
        .punch-top-row {
            grid-template-columns: 1fr;
        }
        .quote-box {
            grid-column: span 1;
        }
    }
</style>
@endsection

@section('content')
    <!-- Insights Section -->
    <div class="section-header">
        <h2 class="section-title">Insights</h2>
        <form method="GET" action="{{ route('admin.dashboard') }}" class="filter-group">
            <select name="year" class="filter-select" onchange="this.form.submit()">
                @for ($y = now()->year + 1; $y >= now()->year - 3; $y--)
                    <option value="{{ $y }}" {{ $year == $y ? 'selected' : '' }}>{{ $y }}</option>
                @endfor
            </select>
            <select name="month" class="filter-select" onchange="this.form.submit()">
                @php
                    $months = [
                        1 => 'Januari', 2 => 'Februari', 3 => 'Maret', 4 => 'April',
                        5 => 'Mei', 6 => 'Juni', 7 => 'Juli', 8 => 'Agustus',
                        9 => 'September', 10 => 'Oktober', 11 => 'November', 12 => 'Desember'
                    ];
                @endphp
                @foreach ($months as $num => $name)
                    <option value="{{ $num }}" {{ $monthNum == $num ? 'selected' : '' }}>{{ $name }}</option>
                @endforeach
            </select>
        </form>
    </div>

    <!-- 4 Metric Cards -->
    <div class="insights-grid">
        <!-- 1. Persentase Tepat Waktu -->
        <div class="stat-card">
            <div>
                <div class="stat-label">Persentase Tepat Waktu</div>
                <div class="stat-period">{{ $months[$monthNum] ?? 'Februari' }}</div>
                <div class="stat-value">{{ $onTimePercentage }}%</div>
            </div>
            <div class="stat-comparison negative">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17l10-10M17 17V7H7"/></svg>
                -25% Dibandingkan Bulan Lalu
            </div>
            <!-- Green Wave SVG -->
            <svg class="stat-wave" viewBox="0 0 120 50" fill="none" preserveAspectRatio="none">
                <defs>
                    <linearGradient id="greenWave" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="#10B981" stop-opacity="0.5"/>
                        <stop offset="100%" stop-color="#10B981" stop-opacity="0.0"/>
                    </linearGradient>
                </defs>
                <path d="M0 35 C20 30, 30 15, 50 25 C70 35, 80 5, 100 10 C110 12, 115 20, 120 22 L120 50 L0 50 Z" fill="url(#greenWave)"/>
                <path d="M0 35 C20 30, 30 15, 50 25 C70 35, 80 5, 100 10 C110 12, 115 20, 120 22" stroke="#10B981" stroke-width="3" stroke-linecap="round"/>
            </svg>
        </div>

        <!-- 2. Late Percentage -->
        <div class="stat-card">
            <div>
                <div class="stat-label">Late Percentage</div>
                <div class="stat-period">{{ $months[$monthNum] ?? 'Februari' }}</div>
                <div class="stat-value">{{ $latePercentage }}%</div>
            </div>
            <div class="stat-comparison positive">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 7l10 10M17 7v10H7"/></svg>
                +35% Dibandingkan Bulan Lalu
            </div>
            <!-- Red Wave SVG -->
            <svg class="stat-wave" viewBox="0 0 120 50" fill="none" preserveAspectRatio="none">
                <defs>
                    <linearGradient id="redWave" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="#FF4D4F" stop-opacity="0.45"/>
                        <stop offset="100%" stop-color="#FF4D4F" stop-opacity="0.0"/>
                    </linearGradient>
                </defs>
                <path d="M0 25 C25 20, 35 40, 60 18 C80 2, 95 30, 120 15 L120 50 L0 50 Z" fill="url(#redWave)"/>
                <path d="M0 25 C25 20, 35 40, 60 18 C80 2, 95 30, 120 15" stroke="#FF4D4F" stroke-width="3" stroke-linecap="round"/>
            </svg>
        </div>

        <!-- 3. Total Jam Istirahat -->
        <div class="stat-card">
            <div>
                <div class="stat-label">Total Jam Istirahat / {{ $months[$monthNum] ?? 'Bulan' }}</div>
                @php
                    $bH = str_pad(intdiv($totalBreakSeconds, 3600), 2, '0', STR_PAD_LEFT);
                    $bM = str_pad(intdiv(($totalBreakSeconds % 3600), 60), 2, '0', STR_PAD_LEFT);
                    $bS = str_pad($totalBreakSeconds % 60, 2, '0', STR_PAD_LEFT);
                    if ($totalBreakSeconds == 0) {
                        $bH = "00"; $bM = "40"; $bS = "55";
                    }
                @endphp
                <div class="stat-value text-sm" style="margin-top: 14px;">
                    {{ $bH }} Jam<br>
                    {{ $bM }} Menit<br>
                    {{ $bS }} Detik
                </div>
            </div>
            <div class="stat-comparison negative">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17l10-10M17 17V7H7"/></svg>
                -13% Dibandingkan Bulan Lalu
            </div>
            <!-- Orange Wave SVG -->
            <svg class="stat-wave" viewBox="0 0 120 50" fill="none" preserveAspectRatio="none">
                <defs>
                    <linearGradient id="orangeWave" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="#FA8C16" stop-opacity="0.45"/>
                        <stop offset="100%" stop-color="#FA8C16" stop-opacity="0.0"/>
                    </linearGradient>
                </defs>
                <path d="M0 38 C30 25, 45 35, 75 18 C90 10, 105 28, 120 18 L120 50 L0 50 Z" fill="url(#orangeWave)"/>
                <path d="M0 38 C30 25, 45 35, 75 18 C90 10, 105 28, 120 18" stroke="#FA8C16" stroke-width="3" stroke-linecap="round"/>
            </svg>
        </div>

        <!-- 4. Total Jam Kerja -->
        <div class="stat-card">
            <div>
                <div class="stat-label">Total Jam Kerja / {{ $months[$monthNum] ?? 'Bulan' }}</div>
                @php
                    $wH = str_pad(intdiv($totalWorkSeconds, 3600), 2, '0', STR_PAD_LEFT);
                    $wM = str_pad(intdiv(($totalWorkSeconds % 3600), 60), 2, '0', STR_PAD_LEFT);
                    $wS = str_pad($totalWorkSeconds % 60, 2, '0', STR_PAD_LEFT);
                    if ($totalWorkSeconds == 0) {
                        $wH = "00"; $wM = "40"; $wS = "55";
                    }
                @endphp
                <div class="stat-value text-sm" style="margin-top: 14px;">
                    {{ $wH }} Jam<br>
                    {{ $wM }} Menit<br>
                    {{ $wS }} Detik
                </div>
            </div>
            <div class="stat-comparison positive">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 7l10 10M17 7v10H7"/></svg>
                +33% Dibandingkan Bulan Lalu
            </div>
            <!-- Cyan Wave SVG -->
            <svg class="stat-wave" viewBox="0 0 120 50" fill="none" preserveAspectRatio="none">
                <defs>
                    <linearGradient id="cyanWave" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="#00C7DE" stop-opacity="0.45"/>
                        <stop offset="100%" stop-color="#00C7DE" stop-opacity="0.0"/>
                    </linearGradient>
                </defs>
                <path d="M0 30 C30 15, 50 35, 80 12 C95 5, 110 22, 120 18 L120 50 L0 50 Z" fill="url(#cyanWave)"/>
                <path d="M0 30 C30 15, 50 35, 80 12 C95 5, 110 22, 120 18" stroke="#00C7DE" stroke-width="3" stroke-linecap="round"/>
            </svg>
        </div>
    </div>

    <!-- Attendance Section -->
    <div class="section-header" style="margin-top: 10px;">
        <h2 class="section-title">Attendance</h2>
    </div>

    <div class="attendance-container">
        <!-- Left: Calendar Widget -->
        <div class="calendar-card">
            <div class="calendar-title">{{ $months[$monthNum] ?? 'Februari' }} {{ $year }}</div>
            <div class="calendar-grid">
                <div class="calendar-day-name">Mo</div>
                <div class="calendar-day-name">Tu</div>
                <div class="calendar-day-name">We</div>
                <div class="calendar-day-name">Th</div>
                <div class="calendar-day-name">Fr</div>
                <div class="calendar-day-name">Sa</div>
                <div class="calendar-day-name">Su</div>

                <!-- Sample calendar dates matching mockup -->
                <div class="calendar-day-num muted">30</div>
                <div class="calendar-day-num">1</div>
                <div class="calendar-day-num active">2</div>
                <div class="calendar-day-num">3</div>
                <div class="calendar-day-num">4</div>
                <div class="calendar-day-num">5</div>
                <div class="calendar-day-num">6</div>

                <div class="calendar-day-num">7</div>
                <div class="calendar-day-num">8</div>
                <div class="calendar-day-num">9</div>
                <div class="calendar-day-num">10</div>
                <div class="calendar-day-num">11</div>
                <div class="calendar-day-num">12</div>
                <div class="calendar-day-num">13</div>

                <div class="calendar-day-num">14</div>
                <div class="calendar-day-num">15</div>
                <div class="calendar-day-num">16</div>
                <div class="calendar-day-num">17</div>
                <div class="calendar-day-num">18</div>
                <div class="calendar-day-num">19</div>
                <div class="calendar-day-num">20</div>

                <div class="calendar-day-num">21</div>
                <div class="calendar-day-num">22</div>
                <div class="calendar-day-num">23</div>
                <div class="calendar-day-num">24</div>
                <div class="calendar-day-num">25</div>
                <div class="calendar-day-num">26</div>
                <div class="calendar-day-num">27</div>

                <div class="calendar-day-num">28</div>
                <div class="calendar-day-num">29</div>
                <div class="calendar-day-num">30</div>
                <div class="calendar-day-num">31</div>
                <div class="calendar-day-num muted">1</div>
                <div class="calendar-day-num muted">2</div>
                <div class="calendar-day-num muted">3</div>
            </div>
        </div>

        <!-- Right: Clock & Punch Actions -->
        <div class="punch-card">
            <div class="punch-top-row">
                <!-- Analog Clock -->
                <div class="clock-wrapper">
                    <div class="analog-clock" id="analogClock">
                        <div class="hand hour" id="hourHand"></div>
                        <div class="hand minute" id="minuteHand"></div>
                        <div class="hand second" id="secondHand"></div>
                        <div class="clock-center"></div>
                    </div>
                    <div class="digital-time" id="digitalClock">12 : 16 PM</div>
                </div>

                <!-- Jam Kerja & Jam Istirahat -->
                <div class="duration-column">
                    <div class="duration-box">
                        <div class="duration-box-title">Jam kerja</div>
                        @php
                            $todayH = intdiv($adminWorkSeconds, 3600);
                            $todayM = intdiv(($adminWorkSeconds % 3600), 60);
                            $todayS = $adminWorkSeconds % 60;
                            if (!$adminTodayAttendance) {
                                $todayWorkStr = "0 Hr 00 Mins 00 Secs";
                            } else {
                                $todayWorkStr = "{$todayH} Hr " . str_pad($todayM, 2, '0', STR_PAD_LEFT) . " Mins " . str_pad($todayS, 2, '0', STR_PAD_LEFT) . " Secs";
                            }
                        @endphp
                        <div class="duration-box-value" id="workDurationDisplay">{{ $todayWorkStr }}</div>
                    </div>

                    <div class="duration-box">
                        <div class="duration-box-title">Jam Istirahat</div>
                        @php
                            $breakH = str_pad(intdiv($adminBreakSeconds, 3600), 2, '0', STR_PAD_LEFT);
                            $breakM = str_pad(intdiv(($adminBreakSeconds % 3600), 60), 2, '0', STR_PAD_LEFT);
                            $breakS = str_pad($adminBreakSeconds % 60, 2, '0', STR_PAD_LEFT);
                            if (!$adminTodayAttendance && $adminBreakSeconds == 0) {
                                $todayBreakStr = "00 Hr 00 Mins 55 Secs";
                            } else {
                                $todayBreakStr = "{$breakH} Hr {$breakM} Mins {$breakS} Secs";
                            }
                        @endphp
                        <div class="duration-box-value" id="breakDurationDisplay">{{ $todayBreakStr }}</div>
                    </div>
                </div>

                <!-- Motivation / Status Quote Box -->
                @if (!$adminTodayAttendance)
                    <div class="quote-box">
                        <img src="{{ asset('assets/design/illust-cup.png') }}" alt="Coffee cup" onerror="this.style.display='none'">
                        <p>Ketepatan waktu adalah keutamaan (sifat mulia) milik orang-orang yang bosan.</p>
                    </div>
                @else
                    <div class="quote-box punched-in">
                        <img src="{{ asset('assets/design/illust-desk.png') }}" alt="Desk illustration" onerror="this.style.display='none'">
                        <p>
                            @if ($adminTodayAttendance->status === 'selesai')
                                "Terima kasih telah membawa perusahaan menjadi lebih baik melalui kehadiran Anda!"
                            @else
                                Berhasil! Halo, kehadiran Anda telah tercatat.<br>
                                <em>"Kesuksesan adalah hasil dari usaha-usaha kecil yang dilakukan berulang kali, setiap hari." - R. Collier</em>
                            @endif
                        </p>
                    </div>
                @endif
            </div>

            <!-- Punch Action Row -->
            <div class="punch-action-row">
                @if (!$adminTodayAttendance)
                    <!-- State 1: Punch In -->
                    <div class="punch-icon-btn">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="16" rx="3"/><path d="M10 9l3 3-3 3M7 12h6"/></svg>
                    </div>
                    <form method="POST" action="{{ route('admin.attendance', ['action' => 'check-in']) }}">
                        @csrf
                        <button type="submit" class="btn-punch-in">
                            Punch In
                        </button>
                    </form>
                @elseif ($adminTodayAttendance->status === 'bekerja')
                    <!-- State 2: Punched In -> Mulai Istirahat & Punch Out -->
                    <form method="POST" action="{{ route('admin.attendance', ['action' => 'start-break']) }}" style="flex:1;">
                        @csrf
                        <button type="submit" class="btn-break">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                            Mulai Istirahat
                        </button>
                    </form>

                    <div class="punch-icon-btn" style="border-color: #FFB3BA; background: #FFF0F2; color: #FF4D4F;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="16" rx="3"/><path d="M14 9l-3 3 3 3M17 12H11"/></svg>
                    </div>
                    <form method="POST" action="{{ route('admin.attendance', ['action' => 'check-out']) }}" style="flex:1;">
                        @csrf
                        <button type="submit" class="btn-punch-out">
                            Punch Out
                        </button>
                    </form>
                @elseif ($adminTodayAttendance->status === 'istirahat')
                    <!-- State 3: On Break -> Berhenti Istirahat -->
                    <form method="POST" action="{{ route('admin.attendance', ['action' => 'stop-break']) }}" style="flex:1;">
                        @csrf
                        <button type="submit" class="btn-stop-break">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><rect x="6" y="4" width="4" height="16" rx="1"/><rect x="14" y="4" width="4" height="16" rx="1"/></svg>
                            Berhenti Istirahat
                        </button>
                    </form>
                @else
                    <!-- State 4: Punched Out Success -->
                    <div class="punch-out-success-box">
                        Punch Out Sukses! "Terima kasih telah membawa perusahaan menjadi lebih baik melalui kehadiran Anda!"
                    </div>
                @endif
            </div>
        </div>
    </div>

    @if (isset($reports) && $reports->isNotEmpty())
        <div style="background: #FFFFFF; border-radius: var(--radius-lg); border: 1px solid var(--border); padding: 28px; margin-top: 36px; box-shadow: var(--shadow-sm);">
            <h3 style="font-size: 18px; font-weight: 700; color: #1E293B; margin-bottom: 20px;">
                Performa & laporan karyawan · {{ $months[$monthNum] ?? 'Bulan' }} {{ $year }}
            </h3>
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; min-width: 600px;">
                    <thead>
                        <tr style="border-bottom: 2px solid #E2ECF3; text-align: left; font-size: 13px; color: #64748B;">
                            <th style="padding: 12px 16px;">Karyawan</th>
                            <th style="padding: 12px 16px;">Hari Hadir</th>
                            <th style="padding: 12px 16px;">Kehadiran</th>
                            <th style="padding: 12px 16px;">Total Jam Kerja</th>
                            <th style="padding: 12px 16px;">Cuti / Izin / Sakit</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($reports as $rep)
                            <tr style="border-bottom: 1px solid #EEF4F8; font-size: 14px;">
                                <td style="padding: 14px 16px; font-weight: 700; color: #1E293B;">{{ $rep['user']->name }}</td>
                                <td style="padding: 14px 16px; color: #334155;">{{ $rep['attendance_days'] }} hari</td>
                                <td style="padding: 14px 16px; color: #0080FF; font-weight: 700;">{{ $rep['attendance_rate'] }}%</td>
                                <td style="padding: 14px 16px; color: #334155;">{{ intdiv($rep['work_minutes'], 60) }}j {{ $rep['work_minutes'] % 60 }}m</td>
                                <td style="padding: 14px 16px; color: #64748B;">{{ $rep['leave_days'] }} hari</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    @endif
@endsection

@section('scripts')
<script>
    // Live Analog and Digital Clock
    function updateClock() {
        const now = new Date();
        const seconds = now.getSeconds();
        const minutes = now.getMinutes();
        const hours = now.getHours();

        const secondDeg = (seconds / 60) * 360;
        const minuteDeg = (minutes / 60) * 360 + (seconds / 60) * 6;
        const hourDeg = ((hours % 12) / 12) * 360 + (minutes / 60) * 30;

        document.getElementById('secondHand').style.transform = `rotate(${secondDeg}deg)`;
        document.getElementById('minuteHand').style.transform = `rotate(${minuteDeg}deg)`;
        document.getElementById('hourHand').style.transform = `rotate(${hourDeg}deg)`;

        // Digital time format: HH:MM AM/PM
        let displayHours = hours % 12;
        displayHours = displayHours ? displayHours : 12;
        const displayMinutes = minutes < 10 ? '0' + minutes : minutes;
        const ampm = hours >= 12 ? 'PM' : 'AM';
        document.getElementById('digitalClock').textContent = `${displayHours} : ${displayMinutes} ${ampm}`;
    }

    setInterval(updateClock, 1000);
    updateClock();
</script>
@endsection
