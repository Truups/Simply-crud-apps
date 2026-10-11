import "package:flutter/material.dart";
import "package:crud_apps/models/journals.dart";
import "package:crud_apps/repositories/journal_repository.dart";


class JournalFormWidget extends StatefulWidget {
  final Journals? journals;
  const JournalFormWidget({super.key, this.journals});

  @override
  State<JournalFormWidget> createState() => _JournalFormWidgetState();
}

class _JournalFormWidgetState extends State<JournalFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String title = "", description = "";

  @override
  void initState(){
    super.initState();
    title = widget.journals?.title ?? "";
    description = widget.journals?.description ?? "";
  }

  // Create Method
  Future<void> _save()async{
    if(!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final now = DateTime.now();
    final journals = Journals(
      id: widget.journals?.id,
      title: title,
      description: description,
      createdAt: now,
      updatedAt: now
    );
    if(widget.journals == null){
      await JournalRepository.addJournals(journals);
    }else{
      await JournalRepository.updateJournals(journals);
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(labelText: "Title"),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => title = v ?? '',
            ),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(labelText: "Description"),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => description = v ?? '',
            ),
            const SizedBox(height: 20),
            // Row Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                ),
                ElevatedButton(
                    onPressed: _save,
                    child: const Text("Save")
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
