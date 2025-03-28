<?php

use App\Http\Controllers\AlunosController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/alunos', [AlunosController::class, 'index'])->name('alunos.index');
Route::get('/alunos/{alunoId}', [AlunosController::class, 'show'])->name('alunos.show');
Route::post('/alunos', [AlunosController::class, 'store'])->name('alunos.store');
Route::put('/alunos/{alunoId}', [AlunosController::class, 'update'])->name('alunos.update');
Route::delete('/alunos/{alunoId}', [AlunosController::class, 'destroy'])->name('alunos.destroy');
