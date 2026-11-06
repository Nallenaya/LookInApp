<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login Admin · LookIn Presensi</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0080FF;
            --primary-hover: #006ee0;
            --bg: #F3F8FC;
            --surface: #FFFFFF;
            --border: #C4D9EC;
            --text-main: #182230;
            --text-muted: #64748B;
            --font-family: 'Plus Jakarta Sans', sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-family);
            background: var(--bg);
            color: var(--text-main);
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 24px;
        }

        .login-card {
            width: min(100%, 440px);
            background: var(--surface);
            border: 1px solid #D5E4F2;
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 12px 36px rgba(0, 80, 160, 0.08);
            text-align: center;
        }

        .brand-logo {
            margin-bottom: 24px;
            display: inline-block;
        }

        .brand-logo img {
            height: 48px;
            width: auto;
            object-fit: contain;
        }

        h1 {
            font-size: 24px;
            font-weight: 800;
            color: #17406E;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        p.subtitle {
            color: var(--text-muted);
            font-size: 14px;
            margin-bottom: 28px;
        }

        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            padding: 13px 16px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            color: var(--text-main);
            background: #FFFFFF;
            outline: none;
            transition: all 0.2s ease;
        }

        input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(0, 128, 255, 0.12);
        }

        button.btn-login {
            width: 100%;
            margin-top: 10px;
            border: none;
            border-radius: 10px;
            background: var(--primary);
            color: #FFFFFF;
            padding: 14px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
            transition: background 0.2s ease;
        }

        button.btn-login:hover {
            background: var(--primary-hover);
        }

        .error-alert {
            background: #FFF1F0;
            color: #D32F2F;
            border: 1px solid #FFCCC7;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 20px;
            text-align: left;
        }

        .hint {
            font-size: 13px;
            color: #8FA0B5;
            margin-top: 24px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
<main class="login-card">
    <div class="brand-logo">
        <img src="{{ asset('assets/design/lookin-logo.png') }}" alt="LookIn" onerror="this.src='{{ asset('assets/design/logo.png') }}'">
    </div>

    <h1>Admin Dashboard</h1>
    <p class="subtitle">Masuk ke panel web administrator LookIn.</p>

    @if ($errors->any())
        <div class="error-alert" role="alert">
            {{ $errors->first() }}
        </div>
    @endif

    <form method="POST" action="{{ route('admin.login.submit') }}">
        @csrf
        <div class="form-group">
            <label for="email">Email Admin</label>
            <input id="email" name="email" type="email" value="{{ old('email', 'admin@lookin.com') }}" autocomplete="username" required autofocus>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input id="password" name="password" type="password" value="password123" autocomplete="current-password" required>
        </div>

        <button type="submit" class="btn-login">Masuk ke Dashboard</button>
    </form>

    <p class="hint">Akun HRD dan karyawan masuk melalui aplikasi LookIn Mobile.</p>
</main>
</body>
</html>
