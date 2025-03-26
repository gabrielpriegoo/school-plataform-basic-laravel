<?php

use App\Http\Controllers\AlunosController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::get('/alunos', [AlunosController::class, 'index'])->name('alunos.index');
Route::get('/alunos/{id}', [])->name('alunos.show');
Route::post('/alunos', [])->name('alunos.store');
Route::put('/alunos/{id}', [])->name('alunos.update');
Route::delete('/alunos/{id}', [])->name('alunos.destroy');
