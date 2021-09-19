import 'package:flutter/material.dart';
import 'package:std_db/dbHelper.dart';
import 'db.dart';
import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student DB',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Student DB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Student _student = Student();
  List<Student> _students = [];

  DatabaseHelper? _dbHelper;

  final _formKey = GlobalKey<FormState>();
  final nameValue = TextEditingController();
  final placeValue = TextEditingController();
  final emailValue = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
            child: Text(widget.title, style: TextStyle(color: Colors.white))),
        actions: [
          IconButton(
            onPressed: () {
              print('Search Icon Clicked');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => searchPageState()));
            },
            icon: Icon(Icons.search),
            color: Colors.white,
          )
        ],
      ),
      body: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_form(), _list()],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  _form() => Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameValue,
              decoration: InputDecoration(hintText: 'Name'),
              onSaved: (val) => setState(() {
                _student.name = val;
              }),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Invalid credentials !';
                }
                if (val.length < 3) {
                  return 'Invalid Credentials !';
                }
                return null;
              },
            ),
            TextFormField(
              controller: placeValue,
              decoration: InputDecoration(hintText: 'Subject'),
              onSaved: (val) => setState(() {
                _student.place = val;
              }),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Invalid credentials !';
                }
                if (val.length < 3) {
                  return 'Invalid credentials !';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailValue,
              decoration: InputDecoration(hintText: 'College'),
              onSaved: (val) => setState(() {
                _student.email = val;
              }),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Invalid credentials !';
                }
                if (val.length < 3) {
                  return 'Invalid credentials !';
                }
                return null;
              },
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _onSubmit();
                },
              ),
            )
          ],
        ),
      ));

  _search() async {}

  _refreshStudents() async {
    List<Student> students = await _dbHelper!.getAllStudents();
    setState(() {
      _students = students;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (_student.id == null) {
        await _dbHelper!.insertStudent(_student);
        _refreshStudents();
        _reset();
      } else {
        await _dbHelper!.updateStudent(_student);
        _refreshStudents();
        _reset();
      }
    }
  }

  _reset() {
    setState(() {
      var form = _formKey.currentState;
      form!.reset();
      nameValue.clear();
      placeValue.clear();
      emailValue.clear();
      _student.id = null;
    });
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.all(16),
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Column(children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    title: Text(_students[index].name!.toUpperCase(),
                        style: TextStyle(color: Colors.black)),
                    subtitle: Text(_students[index].place!.toUpperCase()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _dbHelper!.deleteStudent(_students[index].id!);
                        _refreshStudents();
                        _reset();
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _student = _students[index];
                        nameValue.text = _students[index].name!;
                        placeValue.text = _students[index].place!;
                        emailValue.text = _students[index].email!;
                      });
                    },
                  ),
                  Divider(
                    height: 5.0,
                  )
                ]);
              },
              itemCount: _students.length,
            )),
      );
}

class searchPageState extends StatefulWidget {
  @override
  searchPage createState() => searchPage();
}

class searchPage extends State<searchPageState> {
  Student _student = Student();
  List<Student> _students = [];

  void initState() {
    DatabaseHelper? _dbHelper;
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Search...', prefixIcon: Icon(Icons.search)),
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text('Search', style: TextStyle(color: Colors.white))),
            _searchList()
          ],
        ),
      ),
    );
  }

  _searchList() {
    Expanded(
      child: Card(margin: EdgeInsets.all(8.0), child: ListView(children: [
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.blue,
          ),
          title: Text('Name', style: TextStyle(color: Colors.black)),
          subtitle: Text('Place', style: TextStyle(color: Colors.black)),
        )
      ],)),
    );
  }
}
