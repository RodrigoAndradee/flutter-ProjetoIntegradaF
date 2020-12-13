import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second Route"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate back to first route when tapped.
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Widget Table"),
//       ),
//       body: criaTabela(),
//     );
//   }
//   criaTabela() {
//     return Table(
//       defaultColumnWidth: FixedColumnWidth(150.0),
//       border: TableBorder(
//         horizontalInside: BorderSide(
//           color: Colors.black,
//           style: BorderStyle.solid,
//           width: 1.0,
//         ),
//         verticalInside: BorderSide(
//           color: Colors.black,
//           style: BorderStyle.solid,
//           width: 1.0,
//         ),
//       ),
//       children: [
//         _criarLinhaTable("Pontos, Time, Gols"),
//         _criarLinhaTable("25, Palmeiras,16 "),
//         _criarLinhaTable("20, Santos, 5"),
//         _criarLinhaTable("17, Flamento, 6"),
//       ],
//     );
//   }
//   _criarLinhaTable(String listaNomes) {
//     return TableRow(
//       children: listaNomes.split(',').map((name) {
//         return Container(
//           alignment: Alignment.center,
//           child: Text(
//             name,
//             style: TextStyle(fontSize: 20.0),
//           ),
//           padding: EdgeInsets.all(8.0),
//         );
//       }).toList(),
//     );
//   }
// }

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Tables'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('Header Text'),
            rowsPerPage: 4,
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Título da Pesquisa')),
            ],
            source: _DataSource(context),
          ),
        ],
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

class _DataSource extends DataTableSource {
  _DataSource(this.context) {
    _rows = <_Row>[
      _Row('Cell A1', 'CellB1'),
      // _Row('Cell A2', 'CellB2', 'CellC2', 2),
      // _Row('Cell A3', 'CellB3', 'CellC3', 3),
      // _Row('Cell A4', 'CellB4', 'CellC4', 4),
    ];
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