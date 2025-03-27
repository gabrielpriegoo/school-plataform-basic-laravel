<?php

namespace App\Http\Controllers;

use App\Models\Aluno;
use Illuminate\Http\Request;

class AlunosController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Aluno::get();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => ['required', 'string', 'between:2,100'],
            'born' => ['required', 'date'],
            'gender' => ['required', 'size:1'],
            'turma_id' => ['required', 'int', 'exists:turmas,id']
        ]);

        $AlunosCreate = $request->all();

        return response(Aluno::create($AlunosCreate), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Aluno $alunoId)
    {
        return $alunoId;
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
