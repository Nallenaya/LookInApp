<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Reset Password · LookIn Presensi</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #1989F0;
            --primary-hover: #1272CE;
            --left-bg: #EAF4FD;
            --right-bg: #5FA5EC;
            --text-dark: #1E293B;
            --text-muted: #64748B;
            --font: 'Plus Jakarta Sans', sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font);
            min-height: 100vh;
            display: flex;
            background: var(--left-bg);
        }

        .login-container {
            display: flex;
            width: 100vw;
            min-height: 100vh;
        }

        /* Left Side */
        .left-pane {
            flex: 1;
            background: #EAF4FD;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 50px 80px;
            max-width: 600px;
        }

        .title-login {
            font-size: 32px;
            font-weight: 800;
            color: #0F172A;
            margin-bottom: 20px;
        }

        .welcome-title {
            font-size: 20px;
            font-weight: 700;
            color: #1E293B;
            margin-bottom: 6px;
        }

        .welcome-sub {
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 28px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 13px 16px;
            background: #FFFFFF;
            border: 1px solid #7E96AD;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            color: var(--text-dark);
            outline: none;
            transition: all 0.2s ease;
        }

        .form-group input::placeholder {
            color: #94A3B8;
        }

        .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(25, 137, 240, 0.15);
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #FFFFFF;
            font-size: 15px;
            font-weight: 700;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 10px;
            transition: background 0.2s ease;
        }

        .btn-submit:hover {
            background: var(--primary-hover);
        }

        .login-back {
            text-align: center;
            margin-top: 24px;
            font-size: 13px;
            color: #64748B;
        }

        .login-back a {
            color: #0284C7;
            text-decoration: none;
            font-weight: 600;
        }

        .login-back a:hover {
            text-decoration: underline;
        }

        /* Right Side */
        .right-pane {
            flex: 1.2;
            background: radial-gradient(circle at center, #67AEF5 0%, #4489D8 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            position: relative;
            overflow: hidden;
        }

        .right-card {
            background: #3B82F6;
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 28px;
            padding: 70px 50px;
            max-width: 480px;
            width: 100%;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
        }

        .right-card .logo-img {
            max-width: 260px;
            margin-bottom: 50px;
            filter: drop-shadow(0 4px 6px rgba(0,0,0,0.1));
        }

        .quote-text {
            color: #FFFFFF;
            font-size: 22px;
            font-weight: 600;
            line-height: 1.55;
            letter-spacing: -0.2px;
        }

        @media (max-width: 900px) {
            .right-pane {
                display: none;
            }
            .left-pane {
                max-width: 100%;
                padding: 40px 24px;
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <!-- Left Pane: Form Reset Password -->
    <div class="left-pane">
        <h1 class="title-login">Reset Password</h1>
        <h2 class="welcome-title">Selamat Datang</h2>
        <p class="welcome-sub">Silakan masukkan data login presensi Anda sebelum reset password</p>

        <form method="POST" action="{{ route('admin.login') }}">
            @csrf
            <div class="form-group">
                <label for="email">Email ID</label>
                <input id="email" name="email" type="email" placeholder="Masukkan Email ID" required autofocus>
            </div>

            <div class="form-group">
                <label for="username">Username</label>
                <input id="username" name="username" type="text" placeholder="Masukkan username" required>
            </div>

            <div class="form-group">
                <label for="password">password</label>
                <input id="password" name="password" type="password" placeholder="Masukkan password" required>
            </div>

            <div class="form-group">
                <label for="password_confirmation">konfirmasi password</label>
                <input id="password_confirmation" name="password_confirmation" type="password" placeholder="masukan konfirmasi Password" required>
            </div>

            <button type="submit" class="btn-submit">Register</button>
        </form>

        <div class="login-back">
            Sudah memiliki Akun? <a href="{{ route('admin.login') }}">Login Disini</a>
        </div>
    </div>

    <!-- Right Pane: LookIn Card & Quote -->
    <div class="right-pane">
        <div class="right-card">
            <img class="logo-img" src="{{ asset('assets/design/lookin-logo.png') }}" alt="LookIn" onerror="this.src='{{ asset('assets/design/logo.png') }}'">
            <p class="quote-text">
                “Kehadiran adalah langkah pertama menuju kesuksesan. Hadirlah untuk meraih keberhasilan.”
            </p>
        </div>
    </div>
</div>
</body>
</html>

