import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/services/todo_service.dart';

import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<StatefulWidget> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      final todo = widget.todo;
      isEdit = true;
      titleController.text = todo!['title'];
      descriptionController.text = todo['description'];
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            minLines: 5,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // Get the data from form
    final todo = widget.todo;
    if (todo == null) return;
    // Submit updated data to the server
    final isSucess = await TodoService.updateTodo(todo['_id'], body);
    // Show success or fail message on status
    if (isSucess) {
      showSuccessMessage(context, message: 'Updation Success');
    } else {
      showErrorMessage(context, message: 'Updation Failed');
    }
  }

  Future<void> submitData() async {
  
    // Submit data to the server
    final isSuccess = await TodoService.addTodo(body);
    // Show success or fail message on status
    if (isSuccess) {
      // reset the form
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map get body{
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false, // default value will be false
    };
  }
}
