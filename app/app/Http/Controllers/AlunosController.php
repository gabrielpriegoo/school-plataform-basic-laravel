<?php

namespace App\Http\Controllers;

use App\Http\Requests\AlunoRequest;
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
    public function store(AlunoRequest $request)
    {
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
    public function update(AlunoRequest $request, Aluno $alunoId)
    {
        $alunoId->update($request->all());

        return  $alunoId;
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Aluno $alunoId)
    {
        $alunoId->delete();

        return response()->json([
            'message' => 'Aluno deletado com sucesso!',
        ]);
    }
}
