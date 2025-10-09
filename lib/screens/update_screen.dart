import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/models/todo.dart';
import 'package:flutter_laravel/providers/todo_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key, required this.todo});

  final Todo todo;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _createdBy = '';
  String _description = '';
  String _pathName = '';
  XFile? _imageFile;
  bool loading = false;

  @override
  void initState() {
    setState(() {
      _title = widget.todo.title;
      _createdBy = widget.todo.createdBy;
      _description = widget.todo.description ?? "";
      _pathName = widget.todo.pathName ?? '';
    });

    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEdit() async {
    if (_formKey.currentState!.validate()) {
      
      setState(() {
        loading = true;
      });
      _formKey.currentState!.save();

      await context
          .read<TodoProvider>()
          .updateTodoList(
            id: widget.todo.id,
            title: _title,
            createdBy: _createdBy,
            description: _description,
            imageFile: _imageFile,
          )
          .whenComplete(() {
            setState(() {
              loading = false;
            });

            Navigator.pop(context);
          });
    }
  }

  void _pickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Row(
          children: [
            FlutterLogo(size: 40),
            SizedBox(width: 6),
            Text(
              'Flutter',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_imageFile != null)
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 1,
                        margin: EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Card(
                            child: Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ) else 
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 1,
                        margin: EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Card(
                            child: Image.network(
                              "http://192.168.1.78:8000${_pathName}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.book_rounded,
                          size: 24,
                          color: Colors.blue,
                        ),
                        hintText: 'Title',
                      ),
                      initialValue: _title,
                      onSaved: (value) => {_title = value ?? ''},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title!';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.blue,
                        ),
                        hintText: 'Created by',
                      ),
                      initialValue: _createdBy,
                      onSaved: (value) => {_createdBy = value ?? ''},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a creator name!';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        hintText: 'Description',
                      ),
                      initialValue: _description,
                      onSaved: (value) => {_description = value ?? ''},
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilledButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: _onEdit,
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        FilledButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: _pickImage,
                          child: Text(
                            'Change picture',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (loading) Positioned(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
