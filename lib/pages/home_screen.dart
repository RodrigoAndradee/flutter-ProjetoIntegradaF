import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_app/StorageUtil.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

void _onLoading() async{

  await Future.delayed(Duration(milliseconds: 1000));

  _refreshController.loadComplete();
}

Future<Albuns> getTasks() async {

  final http.Response response = await http.get(
    'http://192.168.1.109:3000/research?userId=1234',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );

  if (response.statusCode == 200) {

    final res = response.body;

    StorageUtil.putString("response", res);
    _refreshController.refreshCompleted();

  } else {
    print(response.statusCode);
  }
}

class Album {

  final String title;

  Album(this.title);

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      json['title'],
    );
  }
}

class Albuns {

  final List<Album> albuns;

  Albuns(this.albuns);

  factory Albuns.fromJson(Map<String, dynamic> json) {
    return Albuns(
      (json['body'] as List).map((i) {
        return Album.fromJson(i);
      }).toList()
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();

}

class _FavoriteWidgetState extends State<FavoriteWidget> {

  bool _refresh = false;

  @override
  Widget build(BuildContext context) {

    void _toggleRefresh(){
      setState(() {
        if(_refresh){
          _refresh = true;
        }
      });
    }

    getTasks();

    final res =  StorageUtil.getString("response");
    final album =  Albuns.fromJson(jsonDecode(res));

    return Scaffold(
      appBar: AppBar(
        title: Text('Todas as Pesquisas'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: () async{

          _toggleRefresh();
          FavoriteWidget();
        },
        onLoading: _onLoading,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PaginatedDataTable(
              header: Text('Pesquisas'),
              rowsPerPage: album.albuns.length,
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Título da Pesquisa')),
              ],
              source: _DataSource(context),
            ),
          ],
        ),
      ),
    );
  }

}

class _Row {
  _Row(
      this.valueA,
      this.valueB,
      );

  final String valueA;
  final String valueB;

  bool selected = false;
}

class _DataSource extends DataTableSource{

  _DataSource(this.context) {

    final res =  StorageUtil.getString("response");
    final album =  Albuns.fromJson(jsonDecode(res));

    _rows = <_Row>[];

    for(var i = 0; i< album.albuns.length; i++){
      _rows.add(_Row((i+1).toString(), album.albuns[i].title));
    }
  }

  final BuildContext context;
  List<_Row> _rows;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(row.valueA)),
        DataCell(Text(row.valueB)),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}