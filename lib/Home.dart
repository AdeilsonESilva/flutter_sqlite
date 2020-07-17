import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Database> _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, 'banco.db');

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, version) {
        var sql =
            'CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)';
        db.execute(sql);
      },
    );

    // print('aberto: ${bd.isOpen}');
    return bd;
  }

  void _salvar() async {
    var bd = await _recuperarBancoDados();

    var pk =
        await bd.insert('usuarios', {'nome': 'Adeilson Silva', 'idade': 37});

    print(pk);
  }

  void _listarUsuarios() async {
    var bd = await _recuperarBancoDados();

    var resultado = await bd.query('usuarios');
    // var resultado = await bd.query('usuarios', columns: ['nome']);
    // var resultado = await bd.query('usuarios',
    //     where: 'idade >= ? and nome like ?', whereArgs: [30, 'Ade%']);
    // var resultado = await bd
    //     .query('usuarios', where: 'idade BETWEEN ? AND ?', whereArgs: [20, 60]);
    // var resultado = await bd.query('usuarios',
    //     where: 'idade BETWEEN ? AND ?',
    //     whereArgs: [20, 60],
    //     orderBy: 'UPPER(nome) DESC');
    // var resultado = await bd.query('usuarios',
    //     columns: ['*', 'UPPER(nome) as nomeMauisculo'],
    //     where: 'idade BETWEEN ? AND ?',
    //     whereArgs: [20, 60],
    //     orderBy: 'UPPER(nome) DESC');
    // var resultado = await bd.query('usuarios',
    //     columns: ['*', 'UPPER(nome) as nomeMauisculo'],
    //     where: 'idade BETWEEN ? AND ?',
    //     whereArgs: [20, 60],
    //     orderBy: 'UPPER(nome) DESC',
    //     limit: 1);

    resultado.forEach((element) {
      print('item id: ${element['id']}'
          ' nome: ${element['nome']}'
          // ' nomeMauisculo: ${element['nomeMauisculo']}'
          ' idade: ${element['idade']}');
    });
    // print(resultado);
  }

  void _listarUsuarioPeloId(int id) async {
    var bd = await _recuperarBancoDados();

    var resultado =
        await bd.query('usuarios', where: 'id = ?', whereArgs: [id]);

    print(resultado.first);
  }

  void _excluirUsuario(int id) async {
    var bd = await _recuperarBancoDados();

    int retorno = await bd.delete('usuarios', where: 'id = ?', whereArgs: [id]);
    print('Removidos: $retorno');
  }

  void _atualizarUsuario(int id) async {
    var bd = await _recuperarBancoDados();

    int retorno = await bd.update(
      'usuarios',
      {'nome': 'Adeilson E Silva', 'idade': 28},
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Atualizados: $retorno');
  }

  @override
  Widget build(BuildContext context) {
    _atualizarUsuario(2);
    _listarUsuarios();

    return Scaffold(
      appBar: AppBar(
        title: Text('Banco de Dados'),
      ),
      body: Container(),
    );
  }
}
