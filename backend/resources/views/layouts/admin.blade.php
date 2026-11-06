<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>@yield('title', 'LookIn Admin')</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0080FF;
            --primary-hover: #006ee0;
            --primary-light: #EBF4FF;
            --bg: #F3F8FC;
            --surface: #FFFFFF;
            --border: #E2ECF3;
            --border-light: #EEF4F8;
            --text-main: #182230;
            --text-muted: #7E8D9F;
            --text-sub: #4A5868;
            --success: #00D26A;
            --danger: #FF3B30;
            --warning: #FF9500;
            --radius-lg: 18px;
            --radius-md: 12px;
            --radius-sm: 8px;
            --shadow-sm: 0 2px 10px rgba(18, 55, 90, 0.03);
            --shadow-md: 0 6px 20px rgba(18, 55, 90, 0.06);
            --font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-family);
            background-color: var(--bg);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* Sidebar */
        aside.sidebar {
            width: 250px;
            background: var(--surface);
            min-height: 100vh;
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            z-index: 100;
            padding: 32px 0 24px 0;
        }

        .sidebar-brand {
            padding: 0 32px 24px;
        }

        .sidebar-brand img {
            height: 38px;
            width: auto;
            display: block;
            object-fit: contain;
        }

        .sidebar-user-heading {
            padding: 10px 32px 24px;
        }

        .sidebar-user-heading h3 {
            font-size: 20px;
            font-weight: 700;
            color: var(--primary);
            letter-spacing: -0.3px;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1;
        }

        .sidebar-nav a, .sidebar-nav button.nav-link {
            display: flex;
            align-items: center;
            width: 100%;
            padding: 14px 32px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.2s ease;
            border: none;
            background: transparent;
            text-align: left;
            cursor: pointer;
            font-family: inherit;
        }

        .sidebar-nav a:hover, .sidebar-nav button.nav-link:hover {
            color: var(--primary);
            background: #F8FBFE;
        }

        .sidebar-nav a.active {
            background: var(--primary);
            color: #FFFFFF;
            font-weight: 700;
        }

        .sidebar-nav a.active:hover {
            background: var(--primary);
            color: #FFFFFF;
        }

        /* Main Shell */
        .main-shell {
            margin-left: 250px;
            flex: 1;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: var(--bg);
        }

        /* Topbar */
        header.topbar {
            height: 80px;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            position: sticky;
            top: 0;
            z-index: 90;
            background: transparent;
        }

        .topbar-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: var(--text-main);
            font-weight: 600;
            font-size: 15px;
            position: relative;
            cursor: pointer;
            padding: 6px 12px;
            border-radius: var(--radius-sm);
            transition: background 0.15s ease;
        }

        .topbar-profile:hover {
            background: rgba(255, 255, 255, 0.7);
        }

        .topbar-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #FFFFFF;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            background: #e2edf6;
        }

        .topbar-chevron {
            color: #8FA0B5;
            font-size: 12px;
            transition: transform 0.2s ease;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 8px;
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-md);
            width: 190px;
            display: none;
            flex-direction: column;
            padding: 6px;
            z-index: 1000;
        }

        .dropdown-menu.show {
            display: flex;
        }

        .dropdown-item {
            padding: 10px 14px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-sub);
            text-decoration: none;
            border-radius: var(--radius-sm);
            transition: all 0.15s ease;
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
            font-family: inherit;
        }

        .dropdown-item:hover {
            background: var(--primary-light);
            color: var(--primary);
        }

        /* Content Area */
        main.content-area {
            padding: 0 40px 60px 40px;
            max-width: 1560px;
            width: 100%;
            margin: 0 auto;
        }

        /* Global UI Elements */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 11px 22px;
            font-size: 14px;
            font-weight: 700;
            border-radius: var(--radius-sm);
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            font-family: inherit;
        }

        .btn-primary {
            background: var(--primary);
            color: #FFFFFF;
        }

        .btn-primary:hover {
            background: var(--primary-hover);
        }

        .btn-success {
            background: linear-gradient(90deg, #62C723 0%, #7FD836 100%);
            color: #FFFFFF;
        }

        .btn-success:hover {
            opacity: 0.95;
            box-shadow: 0 4px 14px rgba(98, 199, 35, 0.3);
        }

        .btn-danger {
            background: #FF4D4F;
            color: #FFFFFF;
        }

        .btn-danger:hover {
            background: #E03E40;
        }

        .btn-orange {
            background: linear-gradient(90deg, #FF9933 0%, #FFA84D 100%);
            color: #FFFFFF;
        }

        .btn-orange:hover {
            opacity: 0.95;
        }

        .btn-outline {
            background: #FFFFFF;
            border: 1px solid var(--border);
            color: var(--text-sub);
        }

        .btn-outline:hover {
            background: #F8FBFE;
            border-color: var(--primary);
            color: var(--primary);
        }

        .alert-banner {
            padding: 14px 20px;
            border-radius: var(--radius-md);
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-banner.success {
            background: #EAF9EE;
            color: #198754;
            border: 1px solid #BCEBCA;
        }

        .alert-banner.error {
            background: #FFF1F0;
            color: #D32F2F;
            border: 1px solid #FFCCC7;
        }

        /* Responsive */
        @media (max-width: 992px) {
            aside.sidebar {
                width: 200px;
            }
            .main-shell {
                margin-left: 200px;
            }
            header.topbar, main.content-area {
                padding-left: 24px;
                padding-right: 24px;
            }
        }

        @media (max-width: 768px) {
            aside.sidebar {
                position: static;
                width: 100%;
                min-height: auto;
                border-right: none;
                border-bottom: 1px solid var(--border);
                padding: 16px 0;
            }
            .sidebar-nav {
                flex-direction: row;
                overflow-x: auto;
                padding: 0 16px;
            }
            .sidebar-nav a, .sidebar-nav button.nav-link {
                padding: 10px 16px;
                white-space: nowrap;
            }
            .sidebar-brand {
                padding: 0 20px 16px;
            }
            .sidebar-user-heading {
                display: none;
            }
            body {
                flex-direction: column;
            }
            .main-shell {
                margin-left: 0;
            }
            header.topbar {
                height: 64px;
                padding: 0 20px;
            }
            main.content-area {
                padding: 0 16px 40px;
            }
        }
    </style>
    @yield('styles')
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <a href="{{ route('admin.dashboard') }}">
                <img src="{{ asset('assets/design/lookin-logo.png') }}" alt="LookIn Logo">
            </a>
        </div>

        <div class="sidebar-user-heading">
            <h3>{{ auth()->user()->name ?? 'Jane Cooper' }}</h3>
        </div>

        <nav class="sidebar-nav">
            <a href="{{ route('admin.dashboard') }}" class="{{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">
                Dashboard
            </a>
            <a href="{{ route('admin.monitoring') }}" class="{{ request()->routeIs('admin.monitoring') ? 'active' : '' }}">
                Monitoring
            </a>
            <a href="{{ route('admin.laporan') }}" class="{{ request()->routeIs('admin.laporan') ? 'active' : '' }}">
                Laporan
            </a>
            <a href="{{ route('admin.registrasi-wajah') }}" class="{{ request()->routeIs('admin.registrasi-wajah') ? 'active' : '' }}">
                Registrasi Wajah
            </a>
            <a href="{{ route('admin.karyawan') }}" class="{{ request()->routeIs('admin.karyawan*') ? 'active' : '' }}">
                Karyawan
            </a>
            <a href="{{ route('admin.akun') }}" class="{{ request()->routeIs('admin.akun') ? 'active' : '' }}">
                Akun
            </a>
            <form method="POST" action="{{ route('admin.logout') }}" style="margin-top: 6px;">
                @csrf
                <button type="submit" class="nav-link">
                    Log out
                </button>
            </form>
        </nav>
    </aside>

    <!-- Main Shell -->
    <div class="main-shell">
        <header class="topbar">
            <div class="topbar-profile" id="profileDropdownBtn">
                <img src="{{ asset('assets/design/avatar-small.png') }}" alt="Avatar" class="topbar-avatar" onerror="this.src='{{ asset('assets/design/jane-cooper.png') }}'">
                <span>{{ auth()->user()->name ?? 'Jane Cooper' }}</span>
                <span class="topbar-chevron">▼</span>

                <div class="dropdown-menu" id="profileDropdown">
                    <a href="{{ route('admin.akun') }}" class="dropdown-item">Akun Saya</a>
                    <a href="{{ route('admin.akun') }}?tab=password" class="dropdown-item">Ganti Password</a>
                    <form method="POST" action="{{ route('admin.logout') }}">
                        @csrf
                        <button type="submit" class="dropdown-item" style="color: var(--danger);">Log out</button>
                    </form>
                </div>
            </div>
        </header>

        <main class="content-area">
            @if (session('success'))
                <div class="alert-banner success">
                    <span>✓</span> {{ session('success') }}
                </div>
            @endif
            @if (session('error'))
                <div class="alert-banner error">
                    <span>⚠</span> {{ session('error') }}
                </div>
            @endif
            @if ($errors->any())
                <div class="alert-banner error">
                    <span>⚠</span> {{ $errors->first() }}
                </div>
            @endif

            @yield('content')
        </main>
    </div>

    <script>
        // Dropdown toggle
        const dropdownBtn = document.getElementById('profileDropdownBtn');
        const dropdownMenu = document.getElementById('profileDropdown');
        if (dropdownBtn && dropdownMenu) {
            dropdownBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });
            document.addEventListener('click', () => {
                dropdownMenu.classList.remove('show');
            });
        }
    </script>
    @yield('scripts')
</body>
</html>
