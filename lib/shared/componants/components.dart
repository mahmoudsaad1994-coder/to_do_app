import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultFormFeild({
  required TextEditingController controller,
  required TextInputType inputType,
  required String labelText,
  required IconData prefixIcon,
  required var validat,
  bool isPassword = false,
  bool readOnly = false,
  var inSubmit,
  var onChanged,
  var suffixOnPressed,
  Function()? onTap,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixOnPressed == null
            ? null
            : IconButton(
                icon: isPassword
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility_outlined),
                onPressed: suffixOnPressed),
      ),
      keyboardType: inputType,
      obscureText: isPassword,
      onFieldSubmitted: inSubmit,
      onChanged: onChanged,
      validator: validat,
      onTap: onTap,
      readOnly: readOnly,
    );

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key('${model['id']}'),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${model['date']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (model['status'] != 'new')
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'new', id: model['id']);
              },
              icon: const Icon(
                Icons.restart_alt_rounded,
                color: Colors.red,
              ),
            ),
          if (model['status'] != 'done')
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
          if (model['status'] != 'archive')
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
        ],
      ),
    ),
  );
}

ConditionalBuilder tasksBuilder(List<Map<dynamic, dynamic>> tasks) {
  return ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.separated(
      itemCount: tasks.length,
      itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
      separatorBuilder: (context, index) =>
          const Divider(height: 10, indent: 20, endIndent: 20),
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, please add some tasks',
            style: TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
