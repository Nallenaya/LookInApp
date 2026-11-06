<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('employee_id')->nullable()->after('email');
            $table->string('phone')->nullable()->after('employee_id');
            $table->string('division')->nullable()->after('phone');
            $table->string('position')->nullable()->after('division');
            $table->text('address')->nullable()->after('position');
            $table->string('gender')->nullable()->after('address');
            $table->date('birth_date')->nullable()->after('gender');
            $table->date('joined_date')->nullable()->after('birth_date');
            $table->string('shift_time')->nullable()->after('joined_date');
            $table->string('branch')->nullable()->after('shift_time');
            $table->string('avatar')->nullable()->after('branch');
            $table->string('face_depan')->nullable()->after('avatar');
            $table->string('face_samping_kiri')->nullable()->after('face_depan');
            $table->string('face_samping_kanan')->nullable()->after('face_samping_kiri');
            $table->string('face_menunduk')->nullable()->after('face_samping_kanan');
            $table->string('face_menengadah')->nullable()->after('face_menunduk');
        });

        Schema::table('presensis', function (Blueprint $table) {
            $table->string('status')->default('bekerja')->after('jam_masuk'); // 'bekerja', 'istirahat', 'selesai'
            $table->time('jam_mulai_istirahat')->nullable()->after('status');
            $table->time('jam_selesai_istirahat')->nullable()->after('jam_mulai_istirahat');
            $table->integer('total_istirahat_detik')->default(0)->after('jam_selesai_istirahat');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'employee_id',
                'phone',
                'division',
                'position',
                'address',
                'gender',
                'birth_date',
                'joined_date',
                'shift_time',
                'branch',
                'avatar',
                'face_depan',
                'face_samping_kiri',
                'face_samping_kanan',
                'face_menunduk',
                'face_menengadah',
            ]);
        });

        Schema::table('presensis', function (Blueprint $table) {
            $table->dropColumn([
                'status',
                'jam_mulai_istirahat',
                'jam_selesai_istirahat',
                'total_istirahat_detik',
            ]);
        });
    }
};

