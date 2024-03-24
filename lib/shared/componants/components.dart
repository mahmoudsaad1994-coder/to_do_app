import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../../models/task_model.dart';
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
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
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

Widget buildTaskItem(TaskModel model, context) {
  return Dismissible(
    key: Key('${model.id}'),
    onDismissed: (direction) {
      if (model.status == 'archive') {
        AppCubit.get(context).deleteData(id: model.id!);
      } else {
        AppCubit.get(context).updateData(status: 'archive', id: model.id!);
      }
    },
    child: Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: (model.status != 'new') ? Colors.grey[300] : Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${model.time}'),
              Text('${model.date}'),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.title}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${model.description}',
                  style: const TextStyle(color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (model.status != 'new')
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(status: 'new', id: model.id!);
              },
              icon: const Icon(
                Icons.restart_alt_rounded,
                color: Colors.red,
              ),
            ),
          if (model.status != 'done')
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(status: 'done', id: model.id!);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
          if (model.status != 'archive')
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model.id!);
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

ConditionalBuilder tasksBuilder(List<TaskModel> tasks) {
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
